import 'package:flutter/material.dart';

class LikeAnimationWidget extends StatefulWidget {
  const LikeAnimationWidget({
    required this.child,
    required this.duration,
    required this.isLikeAnimating,
    this.onLikeFinish,
    super.key,
  });
  final Widget child;
  final Duration duration;
  final bool isLikeAnimating;
  final VoidCallback? onLikeFinish;
  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: widget.duration.inMilliseconds,
      ),
    );
    scale = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }

  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    if (widget.isLikeAnimating != oldWidget.isLikeAnimating) {
      beginLikeAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  beginLikeAnimation() async {
    if (widget.isLikeAnimating) {
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(const Duration(milliseconds: 200));
      if (widget.onLikeFinish != null) {
        widget.onLikeFinish!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
