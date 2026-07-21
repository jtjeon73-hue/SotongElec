import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';

/// SotongElec 브랜드 심벌 + (선택) 워드마크
class BrandLogo extends StatelessWidget {
  const BrandLogo({
    super.key,
    this.compact = false,
    this.onDark = true,
    this.symbolSize = 40,
    this.showSubtitle = true,
  });

  final bool compact;
  final bool onDark;
  final double symbolSize;
  final bool showSubtitle;

  static const symbolAsset = 'assets/branding/sotong_elec_symbol.svg';

  @override
  Widget build(BuildContext context) {
    final symbol = SvgPicture.asset(
      symbolAsset,
      width: symbolSize,
      height: symbolSize,
      semanticsLabel: 'SotongElec',
    );

    if (compact) {
      return symbol;
    }

    final titleColor = onDark ? Colors.white : AppColors.deepNavy;
    final subColor = onDark ? const Color(0xFF94A3B8) : AppColors.teal;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        symbol,
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppConstants.appName,
                style: TextStyle(
                  color: titleColor,
                  fontSize: symbolSize >= 40 ? 22 : 16,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              if (showSubtitle) ...[
                const SizedBox(height: 2),
                Text(
                  AppConstants.appSubtitle,
                  style: TextStyle(
                    color: subColor,
                    fontSize: symbolSize >= 40 ? 12 : 11,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
