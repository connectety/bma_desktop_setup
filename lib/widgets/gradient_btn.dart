import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    required this.onPressed,
    required this.gradient,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(80)),
    Key? key,
  }) : super(key: key);

  GradientButton.icon({
    required this.onPressed,
    required this.gradient,
    required Widget icon,
    required Widget label,
    this.borderRadius = const BorderRadius.all(Radius.circular(80)),
    Key? key,
  })  : child = Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[icon, const SizedBox(width: 8), label],
        ),
        super(key: key);

  final VoidCallback onPressed;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
        RawMaterialButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          padding: const EdgeInsetsDirectional.only(start: 12, end: 16),
          child: child,
        ),
      ],
    );
  }
}

Widget backBtnFactory(BuildContext context) {
  return GradientButton.icon(
    onPressed: () => Navigator.pop(context),
    gradient: const LinearGradient(colors: <Color>[
      Color(0xff000000),
      Color(0xff434343),
    ]),
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    label: const Text(
      'Back',
      style: TextStyle(color: Colors.white),
    ),
  );
}
