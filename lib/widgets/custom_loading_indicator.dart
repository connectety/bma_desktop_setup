import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomLoadingIndicator extends StatefulWidget {
  const CustomLoadingIndicator({
    @required this.color,
    this.height = 240.0,
    this.width = 320.0,
    this.duration = const Duration(milliseconds: 1800),
    this.lineWidth = 6,
    this.paddlePadding = 2,
    Key key,
  })  : assert(color != null, 'Please specify a color'),
        assert(height != null, 'height cant be null'),
        assert(width != null, 'width cant be null'),
        assert(lineWidth != null, 'lineWidth cant be null'),
        assert(paddlePadding != null, 'paddlePadding cant be null'),
        paddleHeight = height / 4,
        super(key: key);

  final Color color;
  final double width;
  final double height;
  final Duration duration;
  final double lineWidth;
  final double paddlePadding;

  final double paddleHeight;

  @override
  _CustomLoadingIndicatorState createState() => _CustomLoadingIndicatorState();
}

class _CustomLoadingIndicatorState extends State<CustomLoadingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> ballXAnimation;
  Animation<double> ballYAnimation;
  Animation<double> leftPaddleAnimations;
  Animation<double> rightPaddleAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() => setState(() {}))
      ..repeat();

    _createBallAnimation();
    leftPaddleAnimations = _createPaddleAnimation(0);
    rightPaddleAnimations = _createPaddleAnimation(2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animatable<double> _createTweenSequence(List<double> positions) {
    double wrapList(int i, List<double> list) => list[i % list.length];

    final List<TweenSequenceItem<double>> items = <TweenSequenceItem<double>>[];
    for (int i = 0; i < positions.length; i++) {
      final double begin = wrapList(i, positions);
      final double end = wrapList(i + 1, positions);

      Animatable<double> tween;
      if (begin == end) {
        tween = ConstantTween<double>(begin);
      } else {
        tween = Tween<double>(begin: begin, end: end);
      }

      items.add(TweenSequenceItem<double>(tween: tween, weight: 1));
    }

    return TweenSequence<double>(items);
  }

  void _createBallAnimation() {
    // plus half because the paddle is drawn from the middle
    final double paddleOffset =
        widget.lineWidth + widget.lineWidth / 2 + widget.paddlePadding;

    // 4 because of 2 times the edges and the ball radius * 2 = ball diameter
    final double pathWidth = widget.width / 2 - widget.lineWidth - paddleOffset;

    ballXAnimation = _createTweenSequence(<double>[
      0,
      pathWidth,
      0,
      -pathWidth,
      0,
      pathWidth,
      0,
      -pathWidth,
    ]).animate(_controller);

    final double halfPathHeight = (widget.height - widget.lineWidth * 4) / 2;
    final double halfPaddleHeight = halfPathHeight - (widget.paddleHeight / 2);

    ballYAnimation = _createTweenSequence(<double>[
      0,
      halfPaddleHeight,
      halfPathHeight,
      halfPaddleHeight,
      0,
      -halfPaddleHeight,
      -halfPathHeight,
      -halfPaddleHeight,
    ]).animate(_controller);
  }

  Animation<double> _createPaddleAnimation(int frameStart) {
    final double halfPathHeight = 0.5 * widget.height -
        0.5 * widget.paddleHeight -
        widget.paddlePadding -
        widget.lineWidth;

    final List<double> positions = <double>[
      -halfPathHeight,
      -halfPathHeight,
      -halfPathHeight,
      halfPathHeight,
      halfPathHeight,
      halfPathHeight,
      halfPathHeight,
      -halfPathHeight,
      -halfPathHeight,
      -halfPathHeight,
    ].sublist(frameStart, frameStart + 8);

    return _createTweenSequence(positions).animate(_controller);
  }

  Widget _ball() {
    final Matrix4 transform = Matrix4.identity()
      ..translate(ballXAnimation.value, ballYAnimation.value);

    return Transform(
      transform: transform,
      child: SizedBox.fromSize(
        size: Size.fromRadius(widget.lineWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _paddle(bool isRight) {
    // plus half because the paddle is drawn from the middle
    final double paddleOffset =
        widget.lineWidth + widget.lineWidth / 2 + widget.paddlePadding;
    final double paddleX = widget.width / 2 - paddleOffset;

    final Matrix4 transform = Matrix4.identity();
    if (isRight) {
      transform.translate(paddleX, rightPaddleAnimations.value);
    } else {
      transform.translate(-paddleX, leftPaddleAnimations.value);
    }

    return Transform(
      transform: transform,
      child: SizedBox(
        height: widget.paddleHeight,
        width: widget.lineWidth,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(color: widget.color, width: widget.lineWidth),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _Net(
              color: widget.color,
              dashWidth: widget.lineWidth,
              netHeight: widget.height,
            ),
            _ball(),
            _paddle(true),
            _paddle(false),
          ],
        ),
      ),
    );
  }
}

class _Net extends StatelessWidget {
  const _Net({
    @required this.color,
    @required this.dashWidth,
    @required this.netHeight,
    Key key,
  }) : super(key: key);

  final double dashWidth;
  final double netHeight;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const double dashHeight = 10;
    final int dashCount = (netHeight / (2 * dashHeight)).floor();

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List<Widget>.generate(dashCount, (_) {
        return SizedBox(
          width: dashWidth,
          height: dashHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(color: color),
          ),
        );
      }),
    );
  }
}
