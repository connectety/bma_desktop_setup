import 'package:flutter/material.dart';

class GradientInputBorder extends UnderlineInputBorder {
  const GradientInputBorder({
    required this.gradient,
    BorderSide borderSide = const BorderSide(),
    BorderRadius borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(4),
    ),
  }) : super(borderSide: borderSide, borderRadius: borderRadius);

  final Gradient gradient;

  @override
  GradientInputBorder copyWith({
    BorderSide? borderSide,
    BorderRadius? borderRadius,
    Gradient? gradient,
  }) {
    return GradientInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
      gradient: gradient ?? this.gradient,
    );
  }

  @override
  GradientInputBorder scale(double t) {
    return GradientInputBorder(
      borderSide: borderSide.scale(t),
      gradient: gradient,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientInputBorder) {
      return GradientInputBorder(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
        gradient: gradient,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is GradientInputBorder) {
      return GradientInputBorder(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
        gradient: gradient,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    if (borderRadius.bottomLeft != Radius.zero ||
        borderRadius.bottomRight != Radius.zero) {
      canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
    }

    final Rect outer = borderRadius.toRRect(rect).outerRect;
    final Shader shader = gradient.createShader(outer);
    final Paint paint = borderSide.toPaint()..shader = shader;

    canvas.drawLine(rect.bottomLeft, rect.bottomRight, paint);
  }

  @override
  bool operator ==(Object other) =>
      other is GradientInputBorder && gradient == other.gradient;

  @override
  int get hashCode => hashValues(borderSide, gradient);
}
