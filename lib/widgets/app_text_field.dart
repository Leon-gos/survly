import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Function(String newText)? onTextChange;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool? obscureText;
  final String? errorText;
  final Widget? prefixIcon;
  final bool readOnly;
  final String? label;
  final TextEditingController? textController;
  final int? maxLines;

  const AppTextField({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.onTextChange,
    this.textInputAction,
    this.textInputType,
    this.obscureText,
    this.errorText,
    this.prefixIcon,
    this.readOnly = false,
    this.label,
    this.textController,
    this.maxLines,
  });

  @override
  State<StatefulWidget> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool isObscureText;

  @override
  void initState() {
    super.initState();
    isObscureText = widget.obscureText ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.textController,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon,
        prefixIconColor: Colors.grey,
        label: widget.label != null ? Text(widget.label!) : null,
        suffixIcon: widget.obscureText == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                icon: Icon(
                  isObscureText ? Icons.lock_outline : Icons.lock_open_outlined,
                  color: Colors.grey,
                  size: 20,
                ),
              )
            : widget.suffixIcon,
      ),
      readOnly: widget.readOnly,
      keyboardType: widget.textInputType,
      obscureText: isObscureText,
      onChanged: widget.onTextChange,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      maxLines: widget.maxLines ??
          (widget.textInputType == TextInputType.multiline ? 5 : 1),
    );
  }
}
