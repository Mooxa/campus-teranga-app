import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final bool showText;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const LogoWidget({
    super.key,
    this.width,
    this.height,
    this.showText = true,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.bleuNuit,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
      ),
      child: showText
          ? SvgPicture.asset(
              'assets/images/logo.svg',
              width: width,
              height: height,
              fit: BoxFit.contain,
            )
          : SvgPicture.asset(
              'assets/images/logo_simple.svg',
              width: width,
              height: height,
              fit: BoxFit.contain,
            ),
    );
  }
}

class LogoIcon extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;

  const LogoIcon({
    super.key,
    this.size = 40,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.bleuNuit,
        borderRadius: BorderRadius.circular(8),
      ),
      child: SvgPicture.asset(
        'assets/images/logo_simple.svg',
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
