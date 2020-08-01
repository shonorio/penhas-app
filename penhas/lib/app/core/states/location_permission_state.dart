import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'location_permission_state.freezed.dart';

@freezed
abstract class LocationPermissionState with _$LocationPermissionState {
  const factory LocationPermissionState.granted() = _Granted;
  const factory LocationPermissionState.denied() = _Denied;
  const factory LocationPermissionState.deniedForever() = _DeniedForever;
  const factory LocationPermissionState.undefined() = _Undefined;
}