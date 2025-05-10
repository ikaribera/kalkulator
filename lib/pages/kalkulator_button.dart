import 'package:flutter/material.dart';

class KalkulatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  const KalkulatorButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.grey,
    this.textColor = Colors.white,
  });

  @override
  _KalkulatorButtonState createState() => _KalkulatorButtonState();
}

class _KalkulatorButtonState extends State<KalkulatorButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  void _onTap() {
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.9 : 1.0;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: widget.color,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: _onTap,
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Transform.scale(
              scale: scale,
              child: SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    widget.label,
                    style: TextStyle(fontSize: 24, color: widget.textColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
