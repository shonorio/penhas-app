import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/features/authentication/presentation/shared/map_failure_message.dart';
import 'package:penhas/app/features/authentication/presentation/shared/page_progress_indicator.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_entity.dart';
import 'package:penhas/app/features/feed/domain/usecases/feed_use_cases.dart';

part 'feed_controller.g.dart';

class FeedController extends _FeedControllerBase with _$FeedController {
  FeedController({
    @required FeedUseCases useCase,
  }) : super(useCase);
}

abstract class _FeedControllerBase with Store, MapFailureMessage {
  final FeedUseCases useCase;

  _FeedControllerBase(this.useCase);

  @observable
  ObservableFuture<Either<Failure, FeedCache>> _progress;

  @observable
  ObservableList<TweetEntity> listTweets = ObservableList<TweetEntity>();

  @observable
  String errorMessage;

  @computed
  PageProgressState get currentState {
    if (_progress == null || _progress.status == FutureStatus.rejected) {
      return PageProgressState.initial;
    }

    return _progress.status == FutureStatus.pending
        ? PageProgressState.loading
        : PageProgressState.loaded;
  }

  @action
  Future<void> fetchNextPage() async {
    _progress = ObservableFuture(useCase.fetchNewestTweet());

    final response = await _progress;
    response.fold(
      (failure) => _setErrorMessage(mapFailureMessage(failure)),
      (cache) => _updateSessionAction(cache),
    );
  }

  @action
  Future<void> like(TweetEntity tweet) async {
    if (tweet == null) {
      return;
    }

    final result = await useCase.like(tweet);
    result.fold(
      (failure) => _setErrorMessage(mapFailureMessage(failure)),
      (cache) => _updateSessionAction(cache),
    );
  }

  @action
  Future<void> reply(TweetEntity tweet) async {
    if (tweet == null) {
      return;
    }

    Modular.to.pushNamed('/mainboard/reply', arguments: tweet);
  }

  @action
  Future<void> actionDelete(TweetEntity tweet) async {
    if (tweet == null) {
      return;
    }

    final response = await useCase.delete(tweet);
    response.fold(
      (failure) => _setErrorMessage(mapFailureMessage(failure)),
      (cache) => _updateSessionAction(cache),
    );
  }

  @action
  Future<void> actionReport(TweetEntity tweet) async {
    Modular.to.showDialog(child: Text('Ola Mundo!'));
  }

  void _setErrorMessage(String msg) {
    errorMessage = msg;
  }

  void _updateSessionAction(FeedCache cache) {
    listTweets = cache.tweets.asObservable();
  }

  void _updateTweetList(TweetEntity tweet) {
    final index = listTweets.indexWhere(
      (e) => e.id == tweet.id,
    );

    if (index > 0) {
      listTweets[index] = tweet;
    }
  }
}
