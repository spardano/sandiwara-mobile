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
  }) : super(key: key);

  final TextEditingController controller;
  final Icon icon;
  final String hintText;

  final Function validator;
  late bool obscureText;
  final bool sufixIcon;

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
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintStyle: const TextStyle(color: Colors.white, fontFamily: "Sofia"),
          errorStyle: TextStyle(color: Colors.orange[300], fontSize: 14.0),
          suffixIcon: widget.sufixIcon
              ? IconButton(
                  icon: Icon(
                    widget.obscureText
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white,
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
