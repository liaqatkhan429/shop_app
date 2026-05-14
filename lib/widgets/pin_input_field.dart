import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class PinInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;
  final bool obscureText;
  final bool isError;

  const PinInputField({
    super.key,
    this.length = 6,
    required this.onChanged,
    this.obscureText = true,
    this.isError = false,
  });

  @override
  State<PinInputField> createState() => _PinInputFieldState();
}

class _PinInputFieldState extends State<PinInputField> {
  final FocusNode _focusNode = FocusNode();
  String _currentText = '';

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        children: [
          // Hidden TextField for keyboard input handling
          Opacity(
            opacity: 0,
            child: TextField(
              focusNode: _focusNode,
              maxLength: widget.length,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
                setState(() {
                  _currentText = value;
                });
                widget.onChanged(value);
              },
              decoration: const InputDecoration(counterText: ''),
            ),
          ),
          // Visible Boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              final isFocused = _focusNode.hasFocus && _currentText.length == index ||
                  (_focusNode.hasFocus && index == widget.length - 1 && _currentText.length == widget.length);
              
              final hasText = index < _currentText.length;
              final char = hasText ? _currentText[index] : '';

              Color borderColor = AppColors.borderDark;
              if (widget.isError) {
                borderColor = AppColors.errorRed;
              } else if (isFocused) {
                borderColor = AppColors.primaryBlue;
              } else if (hasText) {
                borderColor = AppColors.textDarkSecondary;
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: 48,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.backgroundDark,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: isFocused ? 2 : 1),
                  boxShadow: isFocused && !widget.isError
                      ? [BoxShadow(color: AppColors.primaryBlueGlow, blurRadius: 8, spreadRadius: 1)]
                      : null,
                ),
                alignment: Alignment.center,
                child: hasText
                    ? (widget.obscureText
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: widget.isError ? AppColors.errorRed : AppColors.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          )
                        : Text(
                            char,
                            style: TextStyle(
                              color: widget.isError ? AppColors.errorRed : AppColors.textDarkPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    : null,
              );
            }),
          ),
        ],
      ),
    );
  }
}
