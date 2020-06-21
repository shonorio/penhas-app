import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_entity.dart';
import 'package:penhas/app/features/feed/presentation/stores/tweet_controller.dart';
import 'package:penhas/app/features/feed/presentation/tweet/widgets/tweet_avatar.dart';
import 'package:penhas/app/features/feed/presentation/tweet/widgets/tweet_body.dart';
import 'package:penhas/app/features/feed/presentation/tweet/widgets/tweet_bottom.dart';
import 'package:penhas/app/features/feed/presentation/tweet/widgets/tweet_title.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

class ReplyTweet extends StatelessWidget {
  final TweetEntity tweet;
  final BuildContext _context;

  final ITweetController controller;

  const ReplyTweet({
    Key key,
    @required this.tweet,
    @required this.controller,
    @required BuildContext context,
  })  : assert(tweet != null),
        assert(context != null),
        assert(controller != null),
        this._context = context,
        super(key: key);

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
            _buildMainTweet(_context),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
              child: Divider(
                height: 2,
                color: DesignSystemColors.warnGrey,
              ),
            ),
            Text('Comentário', style: kTextStyleFeedTweetReplyHeader),
            SizedBox(height: 20),
            // expanded replied tweets
            ..._expandeRepliedTweeters(_context),
            _buildReplyAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainTweet(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.detail(tweet),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TweetAvatar(
                avatar: SvgPicture.network(
                  tweet.avatar,
                  color: DesignSystemColors.darkIndigo,
                  height: 36,
                ),
              ),
              flex: 1,
            ),
            SizedBox(width: 6.0),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TweetTitle(
                    tweet: tweet,
                    context: context,
                    controller: controller,
                  ),
                  TweetBody(content: tweet.content),
                  TweetBottom(
                    tweet: tweet,
                    controller: controller,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _expandeRepliedTweeters(BuildContext context) {
    return tweet.lastReply
        .map(
          (e) => _RepliedTweet(
            repliedTweet: e,
            context: context,
            controller: controller,
          ),
        )
        .toList();
  }

  Widget _buildReplyAction() {
    return tweet.totalReply > 1
        ? Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                child: Divider(
                  height: 2,
                  color: DesignSystemColors.warnGrey,
                ),
              ),
              FlatButton(
                onPressed: () {},
                color: Colors.white,
                highlightColor: Colors.white,
                splashColor: Colors.white,
                child: Text(
                  "Ver todos os comentários",
                  style: kTextStyleFeedTweetShowReply,
                ),
              ),
            ],
          )
        : Container();
  }
}

class _RepliedTweet extends StatelessWidget {
  final TweetEntity tweet;
  final BuildContext _context;
  final ITweetController controller;

  const _RepliedTweet({
    Key key,
    @required TweetEntity repliedTweet,
    @required BuildContext context,
    @required this.controller,
  })  : assert(repliedTweet != null),
        tweet = repliedTweet,
        _context = context,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.detail(tweet),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TweetTitle(
              tweet: tweet,
              context: context,
              controller: controller,
            ),
            TweetBody(content: tweet.content),
            TweetBottom(tweet: tweet, controller: controller),
          ],
        ),
      ),
    );
  }
}