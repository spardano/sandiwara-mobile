import 'package:flutter/material.dart';

class TextFieldInput extends StatefulWidget {
  TextFieldInput({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.validator,
    required this.obscureText,
    required this.sufixIcon,
    required this.textColor,
    required this.textHintColor,
    required this.errorTextColor,
    required this.sufixIconColor,
  }) : super(key: key);

  final TextEditingController controller;
  final Icon icon;
  final String hintText;

  final Function validator;
  late bool obscureText;
  final bool sufixIcon;
  final Color textColor;
  final Color textHintColor;
  final Color errorTextColor;
  final Color sufixIconColor;

  @override
  State<TextFieldInput> createState() => _TextFieldInputState();
}

class _TextFieldInputState extends State<TextFieldInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) => widget.validator(value),
        obscureText: widget.obscureText,
        style: TextStyle(color: widget.textColor),
        decoration: InputDecoration(
          hintStyle:
              TextStyle(color: widget.textHintColor, fontFamily: "Sofia"),
          errorStyle: TextStyle(color: widget.errorTextColor, fontSize: 14.0),
          suffixIcon: widget.sufixIcon
              ? IconButton(
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: widget.sufixIconColor,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      widget.obscureText = !widget.obscureText;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          icon: widget.icon,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
