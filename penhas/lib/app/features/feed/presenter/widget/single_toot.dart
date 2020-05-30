import 'package:flutter/material.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_avatar.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_body.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_bottom.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_title.dart';
import 'package:penhas/app/features/feed/toot_entity.dart';

class SingleToot extends StatelessWidget {
  final TootEntity toot;

  const SingleToot({Key key, @required this.toot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 1.0),
            blurRadius: 8.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TootAvatar(),
              flex: 1,
            ),
            SizedBox(width: 6.0),
            Expanded(
              flex: 5,
              child: Column(
                children: <Widget>[
                  TootTitle(userName: toot.userName, tootTime: toot.time),
                  TootBody(bodyContent: toot.content),
                  TootBottom()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
