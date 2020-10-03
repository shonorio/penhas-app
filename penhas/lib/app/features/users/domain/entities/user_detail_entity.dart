import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'user_detail_profile_entity.dart';

@immutable
class UserDetailEntity extends Equatable {
  final bool isMyself;
  final UserDetailProfileEntity profile;

  UserDetailEntity({
    @required this.isMyself,
    @required this.profile,
  });

  @override
  List<Object> get props => [isMyself, profile];

  @override
  bool get stringify => true;
}