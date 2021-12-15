import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:penhas/app/core/entities/valid_fiel.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/core/network/api_client.dart';
import 'package:penhas/app/features/authentication/presentation/shared/map_exception_to_failure.dart';
import 'package:penhas/app/features/help_center/domain/entities/audio_entity.dart';
import 'package:penhas/app/shared/logger/log.dart';

abstract class IAudioSyncRepository {
  Future<Either<Failure, ValidField>> upload(AudioData audio);
  Future<Either<Failure, ValidField>> download(AudioEntity audio, File file);
}

class AudioData {
  AudioData({
    required this.createdAt,
    required this.sequence,
    required this.eventId,
    required this.media,
  });

  final String createdAt;
  final String sequence;
  final String eventId;
  final File media;

  AudioData({
    required this.createdAt,
    required this.sequence,
    required this.eventId,
    required this.media,
  });
}

class AudioSyncRepository implements IAudioSyncRepository {
  final IApiProvider? _apiProvider;

  AudioSyncRepository({
    required IApiProvider? apiProvider,
  }) : _apiProvider = apiProvider;

  @override
  Future<Either<Failure, ValidField>> upload(AudioData audio) async {
    final fileName = audio.media.name;
    final fileSha1 = sha1.convert(audio.media.readAsBytesSync()).toString();
    final fileData = http.MultipartFile.fromBytes(
      'media',
      audio.media.readAsBytesSync(),
      filename: fileName,
      contentType: MediaType('audio', 'acc'),
    );

    final fields = {
      'sha1': fileSha1,
      'event_id': audio.eventId,
      'event_sequence': audio.sequence,
      'cliente_created_at': audio.createdAt,
      'current_time': DateTime.now().toUtc().toIso8601String(),
    };

    try {
      final result = await _apiProvider!
          .upload(path: '/me/audios', file: fileData, fields: fields)
          .parseAPI();
      return right(result);
    } catch (error, stack) {
      logError(error, stack);
      return left(MapExceptionToFailure.map(error));
    }
  }

  @override
  Future<Either<Failure, ValidField>> download(
    AudioEntity audio,
    File file,
  ) async {
    final endPoint = ['me', 'audios', audio.id, 'download'].join('/');
    final fields = {'audio_sequences': 'all'};
    try {
      await _apiProvider!.download(
        path: endPoint,
        file: file,
        fields: fields,
      );
      return right(ValidField());
    } catch (error, stack) {
      logError(error, stack);
      return left(MapExceptionToFailure.map(error));
    }
  }
}

extension _FileExtention on File {
  String get name {
    return path.split(Platform.pathSeparator).last;
  }
}

extension _FutureExtension<T extends String> on Future<T> {
  Future<ValidField> parseAPI() async {
    return then((data) async {
      final jsonData = jsonDecode(data) as Map<String, dynamic>;
      return ValidField.fromJson(jsonData);
    });
  }
}
