import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/core/network/api_client.dart';
import 'package:penhas/app/features/authentication/presentation/shared/map_exception_to_failure.dart';
import 'package:penhas/app/features/filters/data/models/filter_skills_model.dart';
import 'package:penhas/app/features/filters/domain/entities/filter_tag_entity.dart';
import 'package:penhas/app/shared/logger/log.dart';

abstract class IFilterSkillRepository {
  Future<Either<Failure, List<FilterTagEntity>?>> skills();
}

class FilterSkillRepository implements IFilterSkillRepository {
  final IApiProvider? _apiProvider;

  FilterSkillRepository({
    required IApiProvider? apiProvider,
  }) : _apiProvider = apiProvider;

  @override
  Future<Either<Failure, List<FilterTagEntity>?>> skills() async {
    const endPoint = '/filter-skills';

    try {
      final response = await _apiProvider!.get(path: endPoint).parseSkills();
      return right(response);
    } catch (error, stack) {
      logError(error, stack);
      return left(MapExceptionToFailure.map(error));
    }
  }
}

extension _FutureExtension<T extends String> on Future<T> {
  Future<List<FilterTagEntity>?> parseSkills() async {
    return then((data) async {
      final jsonData = jsonDecode(data) as Map<String, dynamic>;
      return FilterSkillsModel.fromJson(jsonData).skills;
    });
  }
}
