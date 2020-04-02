
import 'package:flutter/material.dart';

class TextFieldSelect<T> extends StatelessWidget {
  final _controller = TextEditingController();
  final List<MapEntry<String, T>> dropdownItems;
  final void Function(T value) onSelectedElement;
  final T selectedValue;

  TextFieldSelect({@required this.dropdownItems, this.selectedValue, @required this.onSelectedElement});

  @override
  Widget build(BuildContext context) {
    if (this.selectedValue != null) {
      this._controller.text = this.dropdownItems.firstWhere((element) => element.value == this.selectedValue).key;
    }
    return TextField(
      showCursor: true,
      readOnly: true,
      controller: _controller,
      decoration: InputDecoration(
        labelText: "Select a type",
        suffix: DropdownButton<MapEntry<String, T>>(
          isDense: true,
          items: dropdownItems.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e.key),
            );
          }).toList(),
          onChanged: (e) {
            this._controller.text = e.key;
            this.onSelectedElement(e.value);
          },
        )
      )
    );
  }
}