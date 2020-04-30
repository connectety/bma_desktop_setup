import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'raw_material_bt.dart';

class GradientButton extends RawButton {
  GradientButton({
    @required VoidCallback onPressed,
    Key key,
    Widget child,
    Gradient gradient,
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(80)),
  }) : super(
          key: key,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: borderRadius,
          ),
          child: child,
        );

  factory GradientButton.icon({
    @required VoidCallback onPressed,
    @required Widget icon,
    @required Widget label,
    Key key,
    Gradient gradient,
  }) = _GradientButtonWithIcon;

  Widget build(BuildContext context) {
    return RawButton(
      onPressed: onPressed,
      shape: shape,
      decoration: decoration,
      child: child,
    );
  }
}

class _GradientButtonWithIcon extends GradientButton {
  _GradientButtonWithIcon({
    @required VoidCallback onPressed,
    @required Widget icon,
    @required Widget label,
    Key key,
    Gradient gradient,
  })  : assert(icon != null, 'no icon set'),
        assert(label != null, 'no label widget set'),
        super(
          key: key,
          onPressed: onPressed,
          gradient: gradient,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              const SizedBox(width: 8),
              label,
            ],
          ),
        );
}
