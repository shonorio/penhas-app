import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:penhas/app/features/appstate/domain/entities/app_state_entity.dart';
import 'package:penhas/app/shared/design_system/colors.dart';

class QuizMessageWidget extends StatelessWidget {
  final QuizMessageEntity message;

  const QuizMessageWidget({
    Key key,
    @required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDisplayTextResponse =
        message.type == QuizMessageType.displayTextResponse;
    EdgeInsetsGeometry margin = isDisplayTextResponse
        ? EdgeInsets.only(left: 36.0, right: 12.0, bottom: 8.0, top: 8.0)
        : EdgeInsets.only(left: 12.0, right: 36.0, bottom: 8.0, top: 8.0);

    EdgeInsetsGeometry padding = EdgeInsets.symmetric(
      horizontal: 8.0,
    );

    Color color = isDisplayTextResponse
        ? DesignSystemColors.ligthPurple
        : Color.fromRGBO(239, 239, 239, 1.0);
    Color textColor = isDisplayTextResponse ? Colors.white : Colors.black;

    Radius radius = Radius.circular(16.0);

    BorderRadiusGeometry borderRadius = isDisplayTextResponse
        ? BorderRadius.only(
            topLeft: radius, topRight: radius, bottomLeft: radius)
        : BorderRadius.only(
            topLeft: radius, topRight: radius, bottomRight: radius);

    AlignmentGeometry alignment =
        isDisplayTextResponse ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      margin: margin,
      alignment: alignment,
      child: Container(
        padding: padding,
        // margin: margin,
        decoration: BoxDecoration(color: color, borderRadius: borderRadius),
        child: Container(
          child: HtmlWidget(
            message.content,
            textStyle: TextStyle(fontSize: 15.0, color: textColor),
          ),
        ),
      ),
    );
  }
}