import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final void Function(String)? onChanged;

  const SearchInput({
    super.key,
    required this.placeholder,
    required this.onChanged,
    required this.focusNode,
    required this.controller,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late ValueNotifier<String> _text;

  @override
  void initState() {
    super.initState();
    //valueNotifier renderiza el espacio par alimpiar lo escrito en el TextFile
    _text = ValueNotifier(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: (text) {
          _text.value = text;
          widget.onChanged!(text);
        },
        decoration: InputDecoration(
          labelText: widget.placeholder,
          border: const OutlineInputBorder(),
          suffixIcon: ValueListenableBuilder<String>(
            valueListenable: _text,
            builder: (_, text, child) {
              if (text.isNotEmpty) {
                return child!;
              }
              return const SizedBox();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CupertinoButton(
                  padding: const EdgeInsets.all(10),
                  color: Colors.black,
                  child: const Icon(Icons.close_rounded),
                  onPressed: () {
                    //limpiar el campo
                    widget.controller.text = '';
                    _text.value = '';
                    widget.onChanged!('');
                  }),
            ),
          ),
        ),
      ),
      // placeholder: placeholder,
      // decoration: BoxDecoration(
      //   color: Colors.black12,
      //   border: Border.all(
      //     width: 1,
      //     color: Colors.black12,
      //   ),
      // ),
    );
  }
}
