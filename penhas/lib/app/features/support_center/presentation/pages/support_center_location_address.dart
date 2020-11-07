import 'package:flutter/material.dart';
import 'package:penhas/app/shared/design_system/colors.dart';

class SupportCenterLocationAddress extends StatelessWidget {
  final String _message;
  final VoidCallback _onPressed;

  const SupportCenterLocationAddress({
    Key key,
    @required String message,
    @required VoidCallback onPressed,
  })  : this._message = message,
        this._onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignSystemColors.systemBackgroundColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
            child: Container(
              height: 89,
              decoration: BoxDecoration(
                color: DesignSystemColors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 8.0,
                  )
                ],
              ),
              child: FlatButton(
                padding: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.place),
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _message,
                              style: addressTextStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                onPressed: _onPressed,
              ),
            ),
          )
        ],
      ),
    );
  }
}

extension _TextStylePrivate on SupportCenterLocationAddress {
  TextStyle get addressTextStyle => TextStyle(
      color: DesignSystemColors.darkIndigoThree,
      fontFamily: 'Lato',
      fontSize: 14.0,
      letterSpacing: 0.45,
      fontWeight: FontWeight.bold);
}