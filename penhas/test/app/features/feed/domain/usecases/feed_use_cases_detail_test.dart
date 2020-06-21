import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_entity.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_request_option.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_session_entity.dart';
import 'package:penhas/app/features/feed/domain/repositories/i_tweet_repositories.dart';
import 'package:penhas/app/features/feed/domain/usecases/feed_use_cases.dart';

class MockTweetRepository extends Mock implements ITweetRepository {}

void main() {
  ITweetRepository repository;

  setUp(() {
    repository = MockTweetRepository();
  });

  group('FeedUseCases', () {
    test('should not hit datasource on instantiate', () async {
      // act
      FeedUseCases(repository: repository);
      // assert
      verifyNoMoreInteractions(repository);
    });
    group('fetchTweetDetail', () {
      TweetEntity tweetRequest;
      TweetSessionEntity emptySession;
      int maxRowsPerRequest;

      setUp(() {
        maxRowsPerRequest = 2;
        tweetRequest = TweetEntity(
            id: 'id_1',
            userName: 'user_1',
            clientId: 1,
            createdAt: '1500-01-01 01:01:01',
            totalReply: 0,
            totalLikes: 0,
            anonymous: false,
            content: 'content 1',
            avatar: 'https:/site.com/avatas.svg',
            meta: TweetMeta(liked: false, owner: false));

        emptySession = TweetSessionEntity(
          hasMore: false,
          orderBy: TweetSessionOrder.latestFirst,
          tweets: [],
        );
      });

      test('should request with parent_id ', () async {
        // arrange
        when(repository.fetch(option: anyNamed('option')))
            .thenAnswer((_) async => right(emptySession));
        // act
        final sut = FeedUseCases(
          repository: repository,
          maxRows: maxRowsPerRequest,
        );
        await sut.fetchTweetDetail(tweetRequest);
        // assert
        verify(
          repository.fetch(
            option: TweetRequestOption(
              parent: tweetRequest.id,
              rows: maxRowsPerRequest,
            ),
          ),
        );
      });

      test('should get empty response if tweet does not have detail', () async {
        // arrange
        when(repository.fetch(option: anyNamed('option')))
            .thenAnswer((_) async => right(emptySession));
        final sut = FeedUseCases(repository: repository);
        final expected = right(FeedCache(tweets: []));
        // act
        final received = await sut.fetchTweetDetail(tweetRequest);
        // assert
        expect(expected, received);
      });
    });
  });
}