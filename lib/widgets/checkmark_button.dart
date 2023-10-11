import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';

class CheckmarkButton extends StatefulWidget {
  final bool isChecked;
  final VoidCallback? onPressed;

  CheckmarkButton({
    Key? key,
    required this.isChecked,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CheckmarkButtonState createState() => _CheckmarkButtonState();
}

class _CheckmarkButtonState extends State<CheckmarkButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(
      begin: widget.isChecked ? 32.0 : 30.0,
      end: widget.isChecked ? 30.0 : 32.0,
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: widget.isChecked ? greenColor : secondaryColor,
      end: widget.isChecked ? secondaryColor : greenColor,
    ).animate(_controller);
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
        return IconButton(
          onPressed: () {
            widget.onPressed?.call();
            if (!_controller.isAnimating) {
              _controller.forward().whenComplete(() {
                _controller.reverse();
              });
            }
          },
          icon: Icon(
            widget.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }
}
