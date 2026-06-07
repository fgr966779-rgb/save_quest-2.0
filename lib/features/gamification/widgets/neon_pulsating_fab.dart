import 'package:flutter/material.dart';

class NeonPulsatingFab extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;

  const NeonPulsatingFab({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color = Colors.purpleAccent,
  });

  @override
  State<NeonPulsatingFab> createState() => _NeonPulsatingFabState();
}

class _NeonPulsatingFabState extends State<NeonPulsatingFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.5 / _animation.value),
                blurRadius: 15 * _animation.value,
                spreadRadius: 2 * _animation.value,
              ),
            ],
          ),
          child: FloatingActionButton(
            heroTag: 'neon_fab',
            onPressed: widget.onPressed,
            backgroundColor: const Color(0xFF1E1E2C),
            child: Icon(widget.icon, color: widget.color),
          ),
        );
      },
    );
  }
}
