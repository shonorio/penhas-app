import 'package:flutter/material.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_avatar.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_body.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_bottom.dart';
import 'package:penhas/app/features/feed/presenter/widget/toot_title.dart';
import 'package:penhas/app/features/feed/toot_entity.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

class ReplyToot extends StatelessWidget {
  final TootEntity toot;
  const ReplyToot({
    Key key,
    @required this.toot,
  }) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
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
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
              child: Divider(
                height: 2,
                color: DesignSystemColors.warnGrey,
              ),
            ),
            Text('Comentário', style: kTextStyleFeedTootReplyHeader),
            SizedBox(height: 20),
            TootTitle(userName: toot.reply.userName, tootTime: toot.reply.time),
            TootBody(bodyContent: toot.reply.content),
            TootBottom(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
              child: Divider(
                height: 2,
                color: DesignSystemColors.warnGrey,
              ),
            ),
            RaisedButton(
              onPressed: () {},
              elevation: 0,
              color: Colors.transparent,
              child: Text(
                "Ver todos os comentários",
                style: kTextStyleFeedTootShowReply,
              ),
            )
          ],
        ),
      ),
    );
  }
}
