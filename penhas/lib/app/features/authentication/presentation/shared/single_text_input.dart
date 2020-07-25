import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

class SingleTextInput extends StatelessWidget {
  final TextInputType _keyboardType;
  final TextStyle _style;
  final void Function(String) _onChanged;
  final TextInputFormatter _inputFormatter;
  final InputDecoration _boxDecoration;

  const SingleTextInput({
    Key key,
    TextInputFormatter inputFormatter,
    TextInputType keyboardType = TextInputType.text,
    TextStyle style = kTextStyleDefaultTextFieldLabelStyle,
    @required onChanged,
    @required InputDecoration boxDecoration,
  })  : this._keyboardType = keyboardType,
        this._style = style,
        this._onChanged = onChanged,
        this._inputFormatter = inputFormatter,
        this._boxDecoration = boxDecoration,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: _style,
      keyboardType: _keyboardType,
      inputFormatters: _inputFormatter == null ? null : [_inputFormatter],
      onChanged: _onChanged,
      autofocus: false,
      decoration: _boxDecoration,
    );
  }
}
