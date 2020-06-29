import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/core/managers/app_configuration.dart';
import 'package:penhas/app/features/feed/domain/entities/tweet_filter_session_entity.dart';

abstract class ITweetRepository {
  Future<Either<Failure, TweetFilterSessionEntity>> retreive();
}

class TweetFilterPreference {
  final ITweetRepository _repository;
  final IAppConfiguration _appConfiguration;

  TweetFilterPreference(
      {@required ITweetRepository repository,
      @required IAppConfiguration appConfiguration})
      : _repository = repository,
        _appConfiguration = appConfiguration;

  Future<Either<Failure, TweetFilterSessionEntity>> retreive() async {
    final serverResponse = await _repository.retreive();

    return serverResponse.fold(
      (failure) => left(failure),
      (session) => _rebuildResponse(session),
    );
  }

  Future<Either<Failure, TweetFilterSessionEntity>> _rebuildResponse(
      TweetFilterSessionEntity response) async {
    final currentCategory =
        await _appConfiguration.getCategoryPreference() ?? [];
    final currentTags = await _appConfiguration.getTagsPreference() ?? [];

    if (currentCategory.isEmpty && currentTags.isEmpty) {
      return right(response);
    }

    List<TweetFilterEntity> rebuildedCategory;
    if (currentCategory.isNotEmpty) {
      final setCategory = Set<String>.from(currentCategory);
      final indexCategory = response.categories.indexWhere(
        (e) => setCategory.contains(e.id),
      );
      if (indexCategory >= 0) {
        rebuildedCategory = response.categories
            .map((e) => e.copyWith(isSelected: setCategory.contains(e.id)))
            .toList();
      }
    }

    List<TweetFilterEntity> rebuildedTags;
    if (currentTags.isNotEmpty) {
      final setTags = Set<String>.from(currentTags);
      rebuildedTags = response.tags
          .map((e) => e.copyWith(isSelected: setTags.contains(e.id)))
          .toList();
    }

    return right(TweetFilterSessionEntity(
        categories: rebuildedCategory ?? response.categories,
        tags: rebuildedTags ?? response.tags));
  }

  Future<void> saveCategory(List<TweetFilterEntity> categories) {
    final List<String> codes = categories.map((e) => e.id).toList();
    return _appConfiguration.saveCategoryPreference(codes: codes);
  }

  Future<void> saveTags(List<TweetFilterEntity> tags) {
    final List<String> codes = tags.map((e) => e.id).toList();
    return _appConfiguration.saveTagsPreference(codes: codes);
  }

  Future<List<String>> getCategory() {
    return _appConfiguration.getCategoryPreference();
  }

  Future<List<String>> getTags() {
    return _appConfiguration.getTagsPreference();
  }
}
