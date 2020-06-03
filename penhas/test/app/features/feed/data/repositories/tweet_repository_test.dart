import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:penhas/app/core/entities/valid_fiel.dart';
import 'package:penhas/app/core/network/network_info.dart';
import 'package:penhas/app/features/feed/data/datasources/tweet_data_source.dart';
import 'package:penhas/app/features/feed/data/models/tweet_model.dart';
import 'package:penhas/app/features/feed/data/models/tweet_session_model.dart';
import 'package:penhas/app/features/feed/data/repositories/tweet_repository.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_engage_request_option.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_entity.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_request_option.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_session_entity.dart';
import 'package:penhas/app/features/feed/domain/repositories/i_tweet_repositories.dart';

import '../../../../../utils/json_util.dart';

class MockNetworkInfo extends Mock implements INetworkInfo {}

class MockTweetDataSource extends Mock implements ITweetDataSource {}

void main() {
  ITweetRepository repository;
  INetworkInfo networkInfo;
  ITweetDataSource dataSource;
  Map<String, Object> jsonSession;

  setUp(() async {
    networkInfo = MockNetworkInfo();
    dataSource = MockTweetDataSource();
    repository =
        TweetRepository(dataSource: dataSource, networkInfo: networkInfo);
  });

  group('TweetRepository', () {
    TweetSessionModel sessionModel;
    setUp(() async {
      jsonSession = await JsonUtil.getJson(from: 'feed/retrieve_response.json');
      sessionModel = TweetSessionModel.fromJson(jsonSession);
      when(dataSource.retrieve(option: anyNamed('option')))
          .thenAnswer((_) => Future.value(sessionModel));
    });
    group('retrieve()', () {
      test('should retrieve tweets from a valid session', () async {
        // arrange
        final TweetSessionEntity expectedSession = sessionModel;
        // act
        final receivedSession =
            await repository.retrieve(option: TweetRequestOption());
        // assert
        expect(receivedSession, right(expectedSession));
      });
    });

    group('create()', () {
      setUp(() async {
        when(dataSource.create(option: anyNamed('option')))
            .thenAnswer((_) => Future.value(ValidField()));
      });
      test('should create tweet from a valid session', () async {
        // arrange
        final requestOption = TweetCreateRequestOption('are you talk to me?');
        final expected = right(ValidField());
        // act
        final received = await repository.create(option: requestOption);
        // assert
        expect(expected, received);
      });
    });

    group('like()', () {
      Map<String, Object> jsonData;
      setUp(() async {
        jsonData =
            await JsonUtil.getJson(from: 'feed/tweet_like_response.json');
        final tweetModel = TweetModel.fromJson(jsonData['tweet']);

        when(dataSource.like(option: anyNamed('option')))
            .thenAnswer((_) => Future.value(tweetModel));
      });

      test('should favorite a valid tweet', () async {
        // arrange
        final requestOption =
            TweetEngageRequestOption(tweetId: '200520T0032210001');
        final expected = right(TweetModel(
          '200528T2055370004',
          'penhas',
          551,
          '2020-05-28 20:55:37',
          0,
          1,
          false,
          'sleep 6',
          'https://elasv2-api.appcivico.com/avatar/padrao.svg',
          TweetMeta(liked: true, owner: true),
          null,
        ));
        // act
        final received = await repository.like(option: requestOption);
        // assert
        expect(expected, received);
      });
    });

    group('comment()', () {
      setUp(() async {
        when(dataSource.comment(option: anyNamed('option')))
            .thenAnswer((_) => Future.value(ValidField()));
      });

      test('should reply a valid tweet', () async {
        // arrange
        final requestOption = TweetEngageRequestOption(
          tweetId: '200528T2055370004',
          message: 'um breve comentario',
        );
        final expected = right(ValidField());
        // act
        final received = await repository.comment(option: requestOption);
        // assert
        expect(expected, received);
      });
    });

    group('report()', () {
      setUp(() async {
        when(dataSource.report(option: anyNamed('option')))
            .thenAnswer((_) => Future.value(ValidField()));
      });

      test('should report a valid tweet', () async {
        // arrange
        final requestOption = TweetEngageRequestOption(
          tweetId: '200528T2055370004',
          message: 'esse tweet me ofende pq XPTO',
        );
        final expected = right(ValidField());
        // act
        final received = await repository.report(option: requestOption);
        // assert
        expect(expected, received);
      });
    });
  });
}
