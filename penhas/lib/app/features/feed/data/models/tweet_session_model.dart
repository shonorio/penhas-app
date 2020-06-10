import 'package:penhas/app/features/feed/data/models/tweet_model.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_entity.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_session_entity.dart';

class TweetSessionModel extends TweetSessionEntity {
  final bool hasMore;
  final TweetSessionOrder orderBy;
  final List<TweetEntity> tweets;

  TweetSessionModel(this.hasMore, this.orderBy, this.tweets)
      : super(hasMore: hasMore, orderBy: orderBy, tweets: tweets);

  factory TweetSessionModel.fromJson(Map<String, Object> jsonData) {
    final hasMore = jsonData['has_more'] == 1 ?? false;
    final orderBy = jsonData['order_by'] == 'latest_first'
        ? TweetSessionOrder.latestFirst
        : TweetSessionOrder.oldestFirst;
    final tweets = _parseTweet(jsonData['tweets']);

    return TweetSessionModel(hasMore, orderBy, tweets);
  }

  static List<TweetEntity> _parseTweet(List<Object> tweets) {
    if (tweets == null || tweets.isEmpty) {
      return [];
    }

    return tweets
        .map((e) => e as Map<String, Object>)
        .map((e) => TweetModel.fromJson(e))
        .toList();
  }
}