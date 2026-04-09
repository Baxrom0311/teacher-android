import 'package:flutter/material.dart';

class StaggeredFadeIn extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final Offset offset;

  const StaggeredFadeIn({
    super.key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 600),
    this.offset = const Offset(0, 30),
  });

  @override
  State<StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(begin: widget.offset, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
