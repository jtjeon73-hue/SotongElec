import 'dart:math' as math;

class CalcResult {
  const CalcResult({
    required this.ok,
    this.value,
    this.unit = '',
    this.steps = const [],
    this.error,
    this.formula = '',
  });

  final bool ok;
  final double? value;
  final String unit;
  final List<String> steps;
  final String? error;
  final String formula;

  factory CalcResult.fail(String message) =>
      CalcResult(ok: false, error: message);

  factory CalcResult.ok({
    required double value,
    required String unit,
    required List<String> steps,
    required String formula,
  }) => CalcResult(
    ok: true,
    value: value,
    unit: unit,
    steps: steps,
    formula: formula,
  );
}

class ElectricalCalculators {
  static double? _parse(String raw, {bool allowNegative = false}) {
    final t = raw.trim().replaceAll(',', '');
    if (t.isEmpty) return null;
    final v = double.tryParse(t);
    if (v == null) return null;
    if (!allowNegative && v < 0) return null;
    return v;
  }

  static CalcResult ohmsLaw({
    required String voltage,
    required String current,
    required String resistance,
    required String solveFor, // V | I | R
  }) {
    final v = _parse(voltage, allowNegative: true);
    final i = _parse(current, allowNegative: true);
    final r = _parse(resistance);
    switch (solveFor) {
      case 'V':
        if (i == null || r == null) {
          return CalcResult.fail('전류(I)와 저항(R)을 숫자로 입력하세요.');
        }
        final result = i * r;
        return CalcResult.ok(
          value: result,
          unit: 'V',
          formula: r'V = I \times R',
          steps: ['V = $i × $r', 'V = ${result.toStringAsFixed(4)} V'],
        );
      case 'I':
        if (v == null || r == null) {
          return CalcResult.fail('전압(V)과 저항(R)을 입력하세요.');
        }
        if (r == 0) return CalcResult.fail('저항이 0이면 전류를 계산할 수 없습니다.');
        final result = v / r;
        return CalcResult.ok(
          value: result,
          unit: 'A',
          formula: r'I = V / R',
          steps: ['I = $v / $r', 'I = ${result.toStringAsFixed(4)} A'],
        );
      case 'R':
        if (v == null || i == null) {
          return CalcResult.fail('전압(V)과 전류(I)를 입력하세요.');
        }
        if (i == 0) return CalcResult.fail('전류가 0이면 저항을 계산할 수 없습니다.');
        final result = v / i;
        return CalcResult.ok(
          value: result,
          unit: 'Ω',
          formula: r'R = V / I',
          steps: ['R = $v / $i', 'R = ${result.toStringAsFixed(4)} Ω'],
        );
      default:
        return CalcResult.fail('계산 대상을 선택하세요.');
    }
  }

  static CalcResult power({
    required String voltage,
    required String current,
    required String resistance,
    required String mode, // VI | I2R | V2R
  }) {
    switch (mode) {
      case 'VI':
        final v = _parse(voltage, allowNegative: true);
        final i = _parse(current, allowNegative: true);
        if (v == null || i == null) {
          return CalcResult.fail('전압과 전류를 입력하세요.');
        }
        final p = v * i;
        return CalcResult.ok(
          value: p,
          unit: 'W',
          formula: r'P = V \times I',
          steps: ['P = $v × $i', 'P = ${p.toStringAsFixed(4)} W'],
        );
      case 'I2R':
        final i = _parse(current, allowNegative: true);
        final r = _parse(resistance);
        if (i == null || r == null) {
          return CalcResult.fail('전류와 저항을 입력하세요.');
        }
        final p = i * i * r;
        return CalcResult.ok(
          value: p,
          unit: 'W',
          formula: r'P = I^2 R',
          steps: ['P = ($i)² × $r', 'P = ${p.toStringAsFixed(4)} W'],
        );
      case 'V2R':
        final v = _parse(voltage, allowNegative: true);
        final r = _parse(resistance);
        if (v == null || r == null) {
          return CalcResult.fail('전압과 저항을 입력하세요.');
        }
        if (r == 0) return CalcResult.fail('저항이 0이면 계산할 수 없습니다.');
        final p = (v * v) / r;
        return CalcResult.ok(
          value: p,
          unit: 'W',
          formula: r'P = V^2 / R',
          steps: ['P = ($v)² / $r', 'P = ${p.toStringAsFixed(4)} W'],
        );
      default:
        return CalcResult.fail('모드를 선택하세요.');
    }
  }

  static CalcResult singlePhasePower({
    required String voltage,
    required String current,
    required String pf,
  }) {
    final v = _parse(voltage);
    final i = _parse(current);
    final cos = _parse(pf, allowNegative: true);
    if (v == null || i == null || cos == null) {
      return CalcResult.fail('전압, 전류, 역률을 입력하세요.');
    }
    if (cos < -1 || cos > 1) {
      return CalcResult.fail('역률은 -1 ~ 1 범위여야 합니다.');
    }
    final p = v * i * cos;
    return CalcResult.ok(
      value: p,
      unit: 'W',
      formula: r'P = V I \cos\theta',
      steps: ['P = $v × $i × $cos', 'P = ${p.toStringAsFixed(4)} W'],
    );
  }

  static CalcResult threePhasePower({
    required String lineVoltage,
    required String lineCurrent,
    required String pf,
    bool useSqrt3 = true,
  }) {
    final v = _parse(lineVoltage);
    final i = _parse(lineCurrent);
    final cos = _parse(pf, allowNegative: true);
    if (v == null || i == null || cos == null) {
      return CalcResult.fail('선간전압, 선전류, 역률을 입력하세요.');
    }
    if (cos < -1 || cos > 1) {
      return CalcResult.fail('역률은 -1 ~ 1 범위여야 합니다.');
    }
    final factor = useSqrt3 ? math.sqrt(3) : 3;
    final p = factor * v * i * cos;
    return CalcResult.ok(
      value: p,
      unit: 'W',
      formula: useSqrt3
          ? r'P = \sqrt{3} V_L I_L \cos\theta'
          : r'P = 3 V_P I_P \cos\theta',
      steps: [
        'P = ${useSqrt3 ? '√3' : '3'} × $v × $i × $cos',
        'P = ${p.toStringAsFixed(4)} W',
      ],
    );
  }

  static CalcResult powerFactor({
    required String active,
    required String apparent,
  }) {
    final p = _parse(active, allowNegative: true);
    final s = _parse(apparent);
    if (p == null || s == null) {
      return CalcResult.fail('유효전력과 피상전력을 입력하세요.');
    }
    if (s == 0) return CalcResult.fail('피상전력이 0입니다.');
    final pf = p / s;
    if (pf.abs() > 1) {
      return CalcResult.fail('|P/S| > 1 입니다. 입력값을 확인하세요.');
    }
    return CalcResult.ok(
      value: pf,
      unit: '',
      formula: r'\cos\theta = P / S',
      steps: ['pf = $p / $s', 'pf = ${pf.toStringAsFixed(4)}'],
    );
  }

  static CalcResult voltageDrop({
    required String current,
    required String resistance,
    required String reactance,
    required String length,
    required String pf,
    bool singlePhase = true,
  }) {
    final i = _parse(current);
    final r = _parse(resistance);
    final x = _parse(reactance);
    final l = _parse(length);
    final cos = _parse(pf, allowNegative: true);
    if (i == null || r == null || x == null || l == null || cos == null) {
      return CalcResult.fail('모든 입력을 숫자로 입력하세요.');
    }
    if (cos < -1 || cos > 1) {
      return CalcResult.fail('역률 범위 오류');
    }
    final sin = math.sqrt(math.max(0, 1 - cos * cos));
    final factor = singlePhase ? 2.0 : math.sqrt(3);
    final vd = factor * i * l * (r * cos + x * sin);
    return CalcResult.ok(
      value: vd,
      unit: 'V',
      formula: singlePhase
          ? r'e = 2 I \ell (R\cos\theta + X\sin\theta)'
          : r'e = \sqrt{3} I \ell (R\cos\theta + X\sin\theta)',
      steps: [
        'sinθ = ${sin.toStringAsFixed(4)}',
        'e = $factor × $i × $l × ($r×$cos + $x×${sin.toStringAsFixed(4)})',
        'e = ${vd.toStringAsFixed(4)} V',
      ],
    );
  }

  static CalcResult seriesResistance(List<String> values) {
    final parsed = <double>[];
    for (final v in values) {
      final n = _parse(v);
      if (n == null) return CalcResult.fail('모든 저항을 올바른 숫자로 입력하세요.');
      parsed.add(n);
    }
    if (parsed.isEmpty) return CalcResult.fail('저항을 하나 이상 입력하세요.');
    final sum = parsed.fold<double>(0, (a, b) => a + b);
    return CalcResult.ok(
      value: sum,
      unit: 'Ω',
      formula: r'R = R_1 + R_2 + \cdots',
      steps: ['R = ${parsed.join(' + ')}', 'R = ${sum.toStringAsFixed(4)} Ω'],
    );
  }

  static CalcResult parallelResistance(List<String> values) {
    final parsed = <double>[];
    for (final v in values) {
      final n = _parse(v);
      if (n == null) return CalcResult.fail('모든 저항을 올바른 숫자로 입력하세요.');
      if (n == 0) return CalcResult.fail('0 Ω 병렬은 계산할 수 없습니다.');
      parsed.add(n);
    }
    if (parsed.isEmpty) return CalcResult.fail('저항을 하나 이상 입력하세요.');
    final inv = parsed.fold<double>(0, (a, b) => a + 1 / b);
    final r = 1 / inv;
    return CalcResult.ok(
      value: r,
      unit: 'Ω',
      formula: r'1/R = 1/R_1 + 1/R_2 + \cdots',
      steps: [
        '1/R = ${parsed.map((e) => '1/$e').join(' + ')}',
        'R = ${r.toStringAsFixed(4)} Ω',
      ],
    );
  }

  static CalcResult transformerCapacity({
    required String voltage,
    required String current,
    bool threePhase = false,
  }) {
    final v = _parse(voltage);
    final i = _parse(current);
    if (v == null || i == null) {
      return CalcResult.fail('전압과 전류를 입력하세요.');
    }
    final s = (threePhase ? math.sqrt(3) : 1) * v * i / 1000;
    return CalcResult.ok(
      value: s,
      unit: 'kVA',
      formula: threePhase ? r'S = \sqrt{3} V I / 1000' : r'S = V I / 1000',
      steps: [
        'S = ${threePhase ? '√3 × ' : ''}$v × $i / 1000',
        'S = ${s.toStringAsFixed(4)} kVA',
      ],
    );
  }

  static CalcResult turnsRatio({required String v1, required String v2}) {
    final a = _parse(v1);
    final b = _parse(v2);
    if (a == null || b == null) {
      return CalcResult.fail('1차·2차 전압을 입력하세요.');
    }
    if (b == 0) return CalcResult.fail('2차 전압이 0입니다.');
    final n = a / b;
    return CalcResult.ok(
      value: n,
      unit: '',
      formula: r'a = V_1 / V_2 = N_1 / N_2',
      steps: ['a = $a / $b', 'a = ${n.toStringAsFixed(4)}'],
    );
  }

  static CalcResult motorCurrent({
    required String powerKw,
    required String voltage,
    required String pf,
    required String efficiency,
    bool threePhase = true,
  }) {
    final p = _parse(powerKw);
    final v = _parse(voltage);
    final cos = _parse(pf);
    final eff = _parse(efficiency);
    if (p == null || v == null || cos == null || eff == null) {
      return CalcResult.fail('모든 값을 입력하세요.');
    }
    if (v == 0 || cos == 0 || eff == 0) {
      return CalcResult.fail('0으로 나눌 수 없습니다.');
    }
    if (eff > 1) {
      return CalcResult.fail('효율은 0~1(또는 소수)로 입력하세요. 예: 0.85');
    }
    final denom = (threePhase ? math.sqrt(3) : 1) * v * cos * eff;
    final i = (p * 1000) / denom;
    return CalcResult.ok(
      value: i,
      unit: 'A',
      formula: threePhase
          ? r'I = P / (\sqrt{3} V \eta \cos\theta)'
          : r'I = P / (V \eta \cos\theta)',
      steps: [
        'I = ${p * 1000} / (${threePhase ? '√3×' : ''}$v×$eff×$cos)',
        'I = ${i.toStringAsFixed(4)} A',
      ],
    );
  }

  static CalcResult capacitorKvar({
    required String powerKw,
    required String pf1,
    required String pf2,
  }) {
    final p = _parse(powerKw);
    final c1 = _parse(pf1);
    final c2 = _parse(pf2);
    if (p == null || c1 == null || c2 == null) {
      return CalcResult.fail('전력과 역률을 입력하세요.');
    }
    if (c1 <= 0 || c1 > 1 || c2 <= 0 || c2 > 1) {
      return CalcResult.fail('역률은 0 초과 1 이하로 입력하세요.');
    }
    final t1 = math.sqrt(1 / (c1 * c1) - 1);
    final t2 = math.sqrt(1 / (c2 * c2) - 1);
    final qc = p * (t1 - t2);
    return CalcResult.ok(
      value: qc,
      unit: 'kvar',
      formula: r'Q_C = P(\tan\theta_1 - \tan\theta_2)',
      steps: [
        'tanθ1 = ${t1.toStringAsFixed(4)}, tanθ2 = ${t2.toStringAsFixed(4)}',
        'Qc = $p × (${t1.toStringAsFixed(4)} - ${t2.toStringAsFixed(4)})',
        'Qc = ${qc.toStringAsFixed(4)} kvar',
      ],
    );
  }

  static CalcResult reactance({
    required String frequency,
    required String value,
    required String type, // L | C
  }) {
    final f = _parse(frequency);
    final x = _parse(value);
    if (f == null || x == null) {
      return CalcResult.fail('주파수와 L 또는 C 값을 입력하세요.');
    }
    if (type == 'L') {
      final xl = 2 * math.pi * f * x;
      return CalcResult.ok(
        value: xl,
        unit: 'Ω',
        formula: r'X_L = 2\pi f L',
        steps: ['XL = 2π × $f × $x', 'XL = ${xl.toStringAsFixed(4)} Ω'],
      );
    }
    if (f == 0 || x == 0) {
      return CalcResult.fail('주파수 또는 커패시턴스가 0입니다.');
    }
    final xc = 1 / (2 * math.pi * f * x);
    return CalcResult.ok(
      value: xc,
      unit: 'Ω',
      formula: r'X_C = 1 / (2\pi f C)',
      steps: ['XC = 1 / (2π × $f × $x)', 'XC = ${xc.toStringAsFixed(4)} Ω'],
    );
  }

  static CalcResult impedance({required String r, required String x}) {
    final rr = _parse(r, allowNegative: true);
    final xx = _parse(x, allowNegative: true);
    if (rr == null || xx == null) {
      return CalcResult.fail('R과 X를 입력하세요.');
    }
    final z = math.sqrt(rr * rr + xx * xx);
    final ang = math.atan2(xx, rr) * 180 / math.pi;
    return CalcResult.ok(
      value: z,
      unit: 'Ω',
      formula: r'Z = \sqrt{R^2 + X^2}',
      steps: [
        'Z = √($rr² + $xx²) = ${z.toStringAsFixed(4)} Ω',
        'θ = ${ang.toStringAsFixed(2)}°',
      ],
    );
  }

  static CalcResult resonance({required String l, required String c}) {
    final ll = _parse(l);
    final cc = _parse(c);
    if (ll == null || cc == null) {
      return CalcResult.fail('L과 C를 입력하세요.');
    }
    if (ll == 0 || cc == 0) return CalcResult.fail('L 또는 C가 0입니다.');
    final f = 1 / (2 * math.pi * math.sqrt(ll * cc));
    return CalcResult.ok(
      value: f,
      unit: 'Hz',
      formula: r'f_0 = 1 / (2\pi\sqrt{LC})',
      steps: ['f0 = 1 / (2π √($ll × $cc))', 'f0 = ${f.toStringAsFixed(4)} Hz'],
    );
  }

  static CalcResult polarToRect({
    required String magnitude,
    required String angleDeg,
  }) {
    final m = _parse(magnitude);
    final a = _parse(angleDeg, allowNegative: true);
    if (m == null || a == null) {
      return CalcResult.fail('크기와 각도(°)를 입력하세요.');
    }
    final rad = a * math.pi / 180;
    final re = m * math.cos(rad);
    final im = m * math.sin(rad);
    return CalcResult.ok(
      value: re,
      unit: '',
      formula: r'a+jb = |Z|(\cos\theta + j\sin\theta)',
      steps: [
        '실수부 = ${re.toStringAsFixed(4)}',
        '허수부 = ${im.toStringAsFixed(4)}',
        '결과 = ${re.toStringAsFixed(4)} + j${im.toStringAsFixed(4)}',
      ],
    );
  }

  static CalcResult rectToPolar({required String real, required String imag}) {
    final re = _parse(real, allowNegative: true);
    final im = _parse(imag, allowNegative: true);
    if (re == null || im == null) {
      return CalcResult.fail('실수부와 허수부를 입력하세요.');
    }
    final mag = math.sqrt(re * re + im * im);
    final ang = math.atan2(im, re) * 180 / math.pi;
    return CalcResult.ok(
      value: mag,
      unit: '',
      formula: r'|Z|=\sqrt{a^2+b^2},\ \theta=\atan(b/a)',
      steps: [
        '|Z| = ${mag.toStringAsFixed(4)}',
        'θ = ${ang.toStringAsFixed(4)}°',
      ],
    );
  }

  static CalcResult unitConvert({
    required String value,
    required String from,
    required String to,
  }) {
    final v = _parse(value, allowNegative: true);
    if (v == null) return CalcResult.fail('값을 입력하세요.');
    const factors = {
      'mA': 1e-3,
      'A': 1.0,
      'kA': 1e3,
      'mV': 1e-3,
      'V': 1.0,
      'kV': 1e3,
      'W': 1.0,
      'kW': 1e3,
      'MW': 1e6,
      'Ω': 1.0,
      'kΩ': 1e3,
      'MΩ': 1e6,
      'Hz': 1.0,
      'kHz': 1e3,
      'MHz': 1e6,
    };
    final f1 = factors[from];
    final f2 = factors[to];
    if (f1 == null || f2 == null) {
      return CalcResult.fail('지원하지 않는 단위입니다.');
    }
    final base = v * f1;
    final out = base / f2;
    return CalcResult.ok(
      value: out,
      unit: to,
      formula: '단위 변환',
      steps: ['$v $from = ${out.toStringAsFixed(6)} $to'],
    );
  }

  static CalcResult illuminance({
    required String lumens,
    required String area,
  }) {
    final phi = _parse(lumens);
    final a = _parse(area);
    if (phi == null || a == null) {
      return CalcResult.fail('광속과 면적을 입력하세요.');
    }
    if (a == 0) return CalcResult.fail('면적이 0입니다.');
    final e = phi / a;
    return CalcResult.ok(
      value: e,
      unit: 'lx',
      formula: r'E = \Phi / A',
      steps: ['E = $phi / $a', 'E = ${e.toStringAsFixed(4)} lx'],
    );
  }

  /// 학습용 참고 — 실제 설계는 규격·전문가 검토 우선
  static CalcResult wireSizeReference({
    required String current,
    required String allowable,
  }) {
    final i = _parse(current);
    final a = _parse(allowable);
    if (i == null || a == null) {
      return CalcResult.fail('부하전류와 허용전류를 입력하세요.');
    }
    if (a <= 0) return CalcResult.fail('허용전류는 0보다 커야 합니다.');
    final margin = a - i;
    final ok = a >= i;
    return CalcResult.ok(
      value: margin,
      unit: 'A',
      formula: '허용전류 ≥ 부하전류 (학습용 참고)',
      steps: [
        '부하전류 = $i A, 허용전류 = $a A',
        ok ? '여유 = ${margin.toStringAsFixed(2)} A (조건 충족)' : '허용전류 부족',
        '※ 실제 전선 굵기는 KEC·제조사 표·전문가 검토를 따르세요.',
      ],
    );
  }

  static CalcResult protectionReference({
    required String loadCurrent,
    required String multiplier,
  }) {
    final i = _parse(loadCurrent);
    final m = _parse(multiplier);
    if (i == null || m == null) {
      return CalcResult.fail('부하전류와 배율을 입력하세요.');
    }
    final rating = i * m;
    return CalcResult.ok(
      value: rating,
      unit: 'A',
      formula: '정격 ≈ I_load × 배율 (학습용)',
      steps: [
        '정격 참고값 = $i × $m = ${rating.toStringAsFixed(2)} A',
        '※ 실제 보호기기 선정은 법령·규격·제조사 자료를 따르세요.',
      ],
    );
  }

  static CalcResult energy({required String powerKw, required String hours}) {
    final p = _parse(powerKw);
    final h = _parse(hours);
    if (p == null || h == null) {
      return CalcResult.fail('전력(kW)과 시간(h)을 입력하세요.');
    }
    final wh = p * h;
    return CalcResult.ok(
      value: wh,
      unit: 'kWh',
      formula: r'W = P t',
      steps: ['W = $p × $h', 'W = ${wh.toStringAsFixed(4)} kWh'],
    );
  }
}
