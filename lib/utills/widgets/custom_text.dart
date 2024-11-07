
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final Color? color;
  final bool isSmall;
  final double? fontSize;
  final TextOverflow overflow;

  const CustomText({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis, this.color, this.fontSize, this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color ?? Colors.black,
          fontWeight: isSmall ? FontWeight.w400 : FontWeight.w700,
          fontSize: fontSize
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}