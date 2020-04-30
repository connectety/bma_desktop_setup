// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RawButton extends StatefulWidget {
  const RawButton({
    @required this.onPressed,
    Key key,
    this.child,
    this.shape,
    this.decoration,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final ShapeBorder shape;

  final BoxDecoration decoration;

  @override
  _RawButtonState createState() => _RawButtonState();
}

class _RawButtonState extends State<RawButton> {
  @override
  Widget build(BuildContext context) {
    const VisualDensity density = VisualDensity();
    final Offset densityAdjustment = density.baseSizeAdjustment;
    final BoxConstraints effectiveConstraints = density.effectiveConstraints(
      const BoxConstraints(minWidth: 88, minHeight: 36),
    );

    final Widget result = ConstrainedBox(
      constraints: effectiveConstraints,
      child: Material(
        shape: widget.shape,
        type: MaterialType.transparency,
        child: Ink(
          decoration: widget.decoration,
          child: InkWell(
            onTap: widget.onPressed,
            customBorder: widget.shape,
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: widget.child,
            ),
          ),
        ),
      ),
    );

    return Semantics(
      container: true,
      button: true,
      child: _InputPadding(
        minSize: Size(
          kMinInteractiveDimension + densityAdjustment.dx,
          kMinInteractiveDimension + densityAdjustment.dy,
        ),
        child: result,
      ),
    );
  }
}

class _InputPadding extends SingleChildRenderObjectWidget {
  const _InputPadding({
    Key key,
    Widget child,
    this.minSize,
  }) : super(key: key, child: child);

  final Size minSize;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderInputPadding(minSize);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant _RenderInputPadding renderObject) {
    renderObject.minSize = minSize;
  }
}

class _RenderInputPadding extends RenderShiftedBox {
  _RenderInputPadding(this._minSize, [RenderBox child]) : super(child);

  Size get minSize => _minSize;
  Size _minSize;

  set minSize(Size value) {
    if (_minSize == value) {
      return;
    }
    _minSize = value;
    markNeedsLayout();
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child.getMinIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child.getMinIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    if (child != null) {
      return math.max(child.getMaxIntrinsicWidth(height), minSize.width);
    }
    return 0;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    if (child != null) {
      return math.max(child.getMaxIntrinsicHeight(width), minSize.height);
    }
    return 0;
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      final double height = math.max(child.size.width, minSize.width);
      final double width = math.max(child.size.height, minSize.height);
      size = constraints.constrain(Size(height, width));
      final BoxParentData childParentData = child.parentData;
      // ignore: cascade_invocations
      childParentData.offset =
          Alignment.center.alongOffset(size - child.size);
    } else {
      size = Size.zero;
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {Offset position}) {
    if (super.hitTest(result, position: position)) {
      return true;
    }
    final Offset center = child.size.center(Offset.zero);
    return result.addWithRawTransform(
      transform: MatrixUtils.forceToPoint(center),
      position: center,
      hitTest: (BoxHitTestResult result, Offset position) {
        // ignore: prefer_asserts_with_message
        assert(position == center);
        return child.hitTest(result, position: center);
      },
    );
  }
}
