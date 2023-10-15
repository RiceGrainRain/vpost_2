import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';

class BookmarkButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback? onPressed;

  BookmarkButton({
    Key? key,
    required this.isLiked,
    required this.onPressed,
  }) : super(key: key);

  @override
  _BookmarkButtonState createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton>
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
      begin: widget.isLiked ? 32.0 : 30.0,
      end: widget.isLiked ? 30.0 : 32.0,
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: widget.isLiked ? Colors.amber : secondaryColor,
      end: widget.isLiked ? secondaryColor : Colors.amber,
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
            widget.isLiked ? Icons.bookmark : Icons.bookmark_border,
            color: _colorAnimation.value,
            size: _sizeAnimation.value,
          ),
        );
      },
    );
  }
}
