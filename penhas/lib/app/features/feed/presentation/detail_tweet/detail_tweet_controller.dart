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

part 'detail_tweet_controller.g.dart';

class DetailTweetController extends _DetailTweetControllerBase
    with _$DetailTweetController {
  DetailTweetController({
    @required FeedUseCases useCase,
    @required TweetEntity tweet,
  }) : super(useCase, tweet);
}

abstract class _DetailTweetControllerBase with Store, MapFailureMessage {
  final TweetEntity tweet;
  final FeedUseCases useCase;
  String tweetContent;

  _DetailTweetControllerBase(this.useCase, this.tweet);

  @observable
  ObservableFuture<Either<Failure, FeedCache>> _progress;

  @observable
  bool isAnonymousMode = false;

  @observable
  bool isEnableCreateButton = false;

  @observable
  TextEditingController editingController = TextEditingController();

  @observable
  String errorMessage = '';

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
  void setTweetContent(String content) {
    isEnableCreateButton = (content != null) && content.isNotEmpty;
    tweetContent = content;
  }

  @action
  Future<void> replyTweetPressed() async {
    _setErrorMessage('');
    if (!isEnableCreateButton) {
      return;
    }

    _progress = ObservableFuture(
        useCase.reply(mainTweet: tweet, comment: tweetContent));

    final response = await _progress;
    response.fold(
      (failure) => _setErrorMessage(mapFailureMessage(failure)),
      (valid) => _updatedTweet(),
    );
  }

  void _setErrorMessage(String message) {
    errorMessage = message;
  }

  void _updatedTweet() {
    editingController.clear();
    Modular.to.pop();
  }
}
