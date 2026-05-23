import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CipherText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool isCiphered;

  const CipherText({
    Key? key,
    required this.text,
    this.style,
    this.isCiphered = false,
  }) : super(key: key);

  @override
  State<CipherText> createState() => _CipherTextState();
}

class _CipherTextState extends State<CipherText> {
  final String _chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ@#\$%&*<>?';
  final Random _rnd = Random();
  String _currentText = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateText();
  }

  @override
  void didUpdateWidget(covariant CipherText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.isCiphered != widget.isCiphered) {
      _updateText();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateText() {
    _timer?.cancel();
    if (!widget.isCiphered) {
      setState(() {
        _currentText = widget.text;
      });
    } else {
      // Start rapid cipher animation
      _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _currentText = _generateRandomString(widget.text.length);
        });
      });
    }
  }

  String _generateRandomString(int length) {
    return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _currentText,
      style: widget.style,
    );
  }
}
