import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? initialValue;
  final String? label;
  final bool disabled;

  const InputWidget({
    Key? key,
    this.onChanged,
    required this.initialValue,
    this.disabled = false,
    this.label,
  }) : super(key: key);

  @override
  InputWidgetState createState() => InputWidgetState();
}

class InputWidgetState extends State<InputWidget> {
  late TextEditingController _textEditingController;
  bool listen = true;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: widget.initialValue);
    _textEditingController.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_handleTextChange);
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _textEditingController.text) {
      listen = false;
      _textEditingController.text = widget.initialValue ?? '';
      listen = true;
    }
  }

  void _handleTextChange() {
    if (widget.onChanged != null && listen) {
      widget.onChanged!(_textEditingController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      enabled: !widget.disabled,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 15.0),
      ),
      autocorrect: false,
    );
  }
}
