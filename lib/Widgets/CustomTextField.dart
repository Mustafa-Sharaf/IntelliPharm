
import 'package:flutter/material.dart';
import '../app_theme/AppColors.dart';
import '../app_theme/theme_extension.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;


  const CustomTextField({
    super.key,
    required this.label,
    this.icon,
    this.obscureText = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ThemeColors>()!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        maxLines: widget.obscureText ? 1 : (widget.maxLines ?? 1),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(widget.icon, color: AppColors.primaryColor)
              : null,
          labelText: widget.label,
          labelStyle: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            color: AppColors.gray,
            fontWeight: FontWeight.normal,
          ),
          floatingLabelStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),

          filled: true,
          fillColor: colors.component,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
