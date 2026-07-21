# -*- coding: utf-8 -*-
"""Generate SotongElec PNG icons from the brand design (Pillow)."""
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
WEB = ROOT / "web"
ICONS = WEB / "icons"
ASSETS = ROOT / "assets" / "branding"


def lerp(a, b, t):
    return int(a + (b - a) * t)


def draw_symbol(size: int, *, maskable: bool = False, transparent: bool = False) -> Image.Image:
    """Draw circular badge: navy ring, circuit, book, yellow bolt."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0) if transparent and not maskable else (11, 31, 58, 255))
    d = ImageDraw.Draw(img)

    # Maskable: solid background + safe content in center 80%
    # Any/transparent: transparent outside the badge circle
    cx = cy = size / 2
    if maskable:
        d.rectangle([0, 0, size, size], fill=(11, 31, 58, 255))
        # content radius keeps ~20% safe zone
        outer_r = size * 0.38
    else:
        outer_r = size * 0.43

    # Badge fill
    x0, y0 = cx - outer_r, cy - outer_r
    x1, y1 = cx + outer_r, cy + outer_r
    d.ellipse([x0, y0, x1, y1], fill=(20, 58, 102, 255))

    # Rings
    ring_w = max(2, int(size * 0.027))
    d.ellipse([x0, y0, x1, y1], outline=(31, 111, 235, 255), width=ring_w)
    inset = outer_r * 0.1
    d.ellipse(
        [x0 + inset, y0 + inset, x1 - inset, y1 - inset],
        outline=(13, 148, 136, 220),
        width=max(1, ring_w // 2),
    )

    s = outer_r  # scale reference (~220 in 512 SVG)

    def P(x, y):
        # map SVG 512 coords centered around 256 to our circle
        nx = (x - 256) / 220.0
        ny = (y - 256) / 220.0
        return (cx + nx * outer_r, cy + ny * outer_r)

    # Circuit lines
    line_w = max(2, int(size * 0.016))
    teal = (20, 184, 166, 255)
    blue = (31, 111, 235, 255)
    segments = [
        ((128, 210), (188, 210)),
        ((324, 210), (384, 210)),
        ((188, 210), (188, 168)),
        ((188, 168), (230, 168)),
        ((324, 210), (324, 168)),
        ((324, 168), (282, 168)),
        ((128, 250), (170, 250)),
        ((342, 250), (384, 250)),
    ]
    for a, b in segments:
        d.line([P(*a), P(*b)], fill=teal, width=line_w)

    def dot(xy, r_svg, color):
        px, py = P(*xy)
        rr = max(2, int(outer_r * (r_svg / 220)))
        d.ellipse([px - rr, py - rr, px + rr, py + rr], fill=color)

    for pt in [(128, 210), (384, 210)]:
        dot(pt, 10, blue)
    for pt in [(128, 250), (384, 250), (230, 168), (282, 168)]:
        dot(pt, 8, teal)

    # Book
    book = [
        P(140, 318),
        P(180, 300),
        P(220, 300),
        P(256, 312),
        P(292, 300),
        P(332, 300),
        P(372, 318),
        P(372, 368),
        P(332, 350),
        P(292, 350),
        P(256, 366),
        P(220, 350),
        P(180, 350),
        P(140, 368),
    ]
    d.polygon(book, fill=(238, 242, 247, 255), outline=(148, 163, 184, 255))
    d.line([P(256, 312), P(256, 366)], fill=(13, 148, 136, 255), width=max(1, line_w))

    # Lightning bolt
    bolt = [
        P(278, 118),
        P(208, 262),
        P(248, 262),
        P(234, 372),
        P(304, 228),
        P(264, 228),
    ]
    d.polygon(bolt, fill=(250, 204, 21, 255), outline=(253, 230, 138, 255))

    return img


def save(img: Image.Image, path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, format="PNG", optimize=True)
    print(f"wrote {path.relative_to(ROOT)} {img.size}")


def main():
    # Transparent/any icons
    sizes = {
        "sotong-elec-favicon.png": (32, False, True),
        "icons/sotong-elec-32.png": (32, False, True),
        "icons/sotong-elec-48.png": (48, False, True),
        "icons/sotong-elec-64.png": (64, False, True),
        "icons/sotong-elec-180.png": (180, False, False),  # apple: solid-ish ok
        "icons/sotong-elec-192.png": (192, False, False),
        "icons/sotong-elec-512.png": (512, False, False),
        "icons/sotong-elec-maskable-192.png": (192, True, False),
        "icons/sotong-elec-maskable-512.png": (512, True, False),
    }

    for rel, (sz, maskable, transparent) in sizes.items():
        # favicon at web root
        if rel == "sotong-elec-favicon.png":
            out = WEB / rel
        else:
            out = WEB / rel
        # For 180/192/512 any: use opaque navy outside circle for clearer PWA tiles
        # but keep circle badge look — transparent=False fills navy, then we redraw badge
        if transparent:
            img = draw_symbol(sz, maskable=False, transparent=True)
        elif maskable:
            img = draw_symbol(sz, maskable=True, transparent=False)
        else:
            # PWA any: navy square with centered badge (readable on light/dark launchers)
            img = Image.new("RGBA", (sz, sz), (11, 31, 58, 255))
            badge = draw_symbol(sz, maskable=False, transparent=True)
            img = Image.alpha_composite(img, badge)
        save(img, out)

    # Also copy favicon as classic name redirect isn't needed — we use new name
    # High-res symbol preview in assets
    save(draw_symbol(512, maskable=False, transparent=True), ASSETS / "sotong_elec_symbol.png")
    print("done")


if __name__ == "__main__":
    main()
