import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class UserDetailProfileEntity extends Equatable {
  final String nickname;
  final String avatar;
  final int clientId;
  final String miniBio;
  final String skills;
  final String activity;

  UserDetailProfileEntity({
    @required this.nickname,
    @required this.avatar,
    @required this.clientId,
    @required this.miniBio,
    @required this.skills,
    @required this.activity,
  });

  @override
  List<Object> get props => [
        nickname,
        avatar,
        clientId,
        miniBio,
        skills,
        activity,
      ];

  @override
  bool get stringify => true;
}
