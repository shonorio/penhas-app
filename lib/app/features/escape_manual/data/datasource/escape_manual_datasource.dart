import '../../../appstate/data/model/quiz_session_model.dart';
import '../model/escape_manual_local.dart';
import '../model/escape_manual_remote.dart';

abstract class IEscapeManualDatasource {}

abstract class IEscapeManualRemoteDatasource extends IEscapeManualDatasource {
  Future<QuizSessionModel> start(String sessionId);
  Future<EscapeManualRemoteModel> fetch();
}

abstract class IEscapeManualLocalDatasource extends IEscapeManualDatasource {
  /// Retrieves the tasks not synced with the server from the local database
  Stream<Iterable<EscapeManualTaskLocalModel>> fetchTasks();
}
