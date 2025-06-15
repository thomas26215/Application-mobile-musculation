import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.trainingName,
    required this.onChanged,
  }) : super(key: key);

  final String trainingName;
  final ValueChanged<String> onChanged;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.trainingName);
  }

  @override
  void didUpdateWidget(Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trainingName != oldWidget.trainingName) {
      _controller.text = widget.trainingName;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            UniconsLine.angle_left,
            color: Colors.white,
            size: 40,
          ),
        ),
        Expanded(
          child: TextField(
            controller: _controller,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Nom de l'entraînement",
              hintStyle: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.white54),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
