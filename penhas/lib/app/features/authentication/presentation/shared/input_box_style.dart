import 'package:flutter/material.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

String _normalizeHitText(String text) {
  if (text == null || text.isEmpty) {
    return null;
  }

  return text;
}

class WhiteBoxDecorationStyle extends InputDecoration {
  WhiteBoxDecorationStyle({
    String labelText,
    String hintText,
    String errorText,
  }) : super(
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: kTextStyleDefaultTextFieldLabelStyle,
          hintText: hintText,
          hintStyle: kTextStyleDefaultTextFieldLabelStyle,
          errorText: _normalizeHitText(errorText),
          contentPadding: EdgeInsetsDirectional.only(end: 8.0, start: 8.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
        );
}

class PurpleBoxDecorationStyle extends InputDecoration {
  PurpleBoxDecorationStyle({
    String labelText,
    String hintText,
    String errorText,
  }) : super(
          border: OutlineInputBorder(),
          labelText: labelText,
          labelStyle: kTextStyleGreyDefaultTextFieldLabelStyle,
          hintText: hintText,
          hintStyle: kTextStyleGreyDefaultTextFieldLabelStyle,
          errorText: _normalizeHitText(errorText),
          contentPadding: EdgeInsetsDirectional.only(end: 8.0, start: 8.0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DesignSystemColors.easterPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: DesignSystemColors.easterPurple),
          ),
        );
}
/*
InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
        border: OutlineInputBorder(),
        labelText: _labelText,
        
        hintText: _hintText,
        
        errorText: _normalizeHitText(_errorText),
        contentPadding: EdgeInsetsDirectional.only(end: 8.0, start: 8.0),
      ),
*/