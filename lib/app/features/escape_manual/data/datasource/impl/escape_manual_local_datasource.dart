import 'dart:async';

import '../../../../../core/extension/iterable.dart';
import '../../../../../core/storage/collection_store.dart';
import '../../model/escape_manual_local.dart';
import '../escape_manual_datasource.dart';

export '../escape_manual_datasource.dart' show IEscapeManualLocalDatasource;

class EscapeManualLocalDatasource implements IEscapeManualLocalDatasource {
  EscapeManualLocalDatasource({
    required ICollectionStore<EscapeManualTaskLocalModel> store,
  }) : _store = store;

  final ICollectionStore<EscapeManualTaskLocalModel> _store;

  @override
  Stream<Iterable<EscapeManualTaskLocalModel>> fetchTasks() =>
      _store.watchAll();

  @override
  Future<void> saveTask(EscapeManualTaskLocalModel task) async {
    await _store.put(task.id, task);
  }

  @override
  Future<void> removeTask(EscapeManualTaskLocalModel task) async {
    await saveTask(task.copyWith(isRemoved: true));
  }

  @override
  Future<void> clearBefore(DateTime date) async {
    final tasks = await _store.all();
    final keys = tasks.mapNotNull((task) {
      if (task.updatedAt?.isBefore(date) == true) {
        return task.id;
      }
      return null;
    });

    await _store.removeAll(keys);
  }
}