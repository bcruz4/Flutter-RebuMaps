import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String placeholder;
  final void Function(String)? onChanged;
  const SearchInput({
    super.key,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoTextField(
        onChanged: onChanged,
        placeholder: placeholder,
        decoration: BoxDecoration(
          color: Colors.black12,
          border: Border.all(
            width: 1,
            color: Colors.black12,
          ),
        ),
      ),
    );
  }
}
