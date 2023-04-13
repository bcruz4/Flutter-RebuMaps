import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String placeholder;
  final void Function(String)? onChanged;
  final VoidCallback onClear;

  const SearchInput({
    super.key,
    required this.placeholder,
    required this.onChanged,
    required this.focusNode,
    required this.controller,
    required this.onClear,
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
    //para desaparecer el boton de borrar cammpo sino se completa la busqueda
    widget.controller.addListener(() {
      final textFromController = widget.controller.text;
      if (widget.controller.text.isEmpty && _text.value.isNotEmpty) {
        _text.value = '';
      } else if (textFromController.isNotEmpty) {
        _text.value = textFromController;
      }
    });
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
                    widget.onClear();
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
