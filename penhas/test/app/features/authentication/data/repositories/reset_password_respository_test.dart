import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:penhas/app/core/entities/valid_fiel.dart';
import 'package:penhas/app/core/error/exceptions.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/core/network/network_info.dart';
import 'package:penhas/app/features/authentication/data/datasources/change_password_data_source.dart';
import 'package:penhas/app/features/authentication/data/models/password_reset_response_model.dart';
import 'package:penhas/app/features/authentication/data/repositories/change_password_repository.dart';
import 'package:penhas/app/features/authentication/domain/usecases/email_address.dart';
import 'package:penhas/app/features/authentication/domain/usecases/password_validator.dart';
import 'package:penhas/app/features/authentication/domain/usecases/sign_up_password.dart';
import 'package:penhas/app/shared/logger/log.dart';

import '../../../../../utils/helper.mocks.dart';
import '../../../../../utils/json_util.dart';

void main() {
  late final MockIChangePasswordDataSource dataSource =
      MockIChangePasswordDataSource();
  late final MockINetworkInfo networkInfo = MockINetworkInfo();

  late final ChangePasswordRepository sut = ChangePasswordRepository(
      changePasswordDataSource: dataSource, networkInfo: networkInfo,);
  late EmailAddress emailAddress;
  late SignUpPassword password;
  String? resetToken;

  setUp(() {
    isCrashlitycsEnabled = false;
    emailAddress = EmailAddress('valid@email.com');
    password = SignUpPassword('my_new_str0ng_P4ssw0rd', PasswordValidator());
    resetToken = '666242';
  });

  PostExpectation<dynamic> mockResetDataSource() {
    return when(dataSource.reset(
        emailAddress: anyNamed('emailAddress'),
        password: anyNamed('password'),
        resetToken: anyNamed('resetToken'),),);
  }

  PostExpectation<dynamic> mockRequestDataSource() {
    return when(dataSource.request(emailAddress: anyNamed('emailAddress')));
  }

  group('ChangePasswordRepository', () {
    setUp(() {
      when(networkInfo.isConnected).thenAnswer((_) async => true);
    });
    group('reset', () {
      test('should return ValidField for successful password changed',
          () async {
        // arrange
        mockResetDataSource().thenAnswer((_) async => ValidField());
        // act
        final result = await sut.reset(
          emailAddress: emailAddress,
          password: password,
          resetToken: resetToken,
        );
        // assert
        expect(result, right(ValidField()));
      });
      test(
          'should return ServerSideFormFieldValidationFailure for non successful change password request',
          () async {
        // arrange
        final bodyContent = await JsonUtil.getJson(
            from: 'authentication/invalid_token_error.json',);
        mockResetDataSource()
            .thenThrow(ApiProviderException(bodyContent: bodyContent));
        // act
        final result = await sut.reset(
          emailAddress: emailAddress,
          password: password,
          resetToken: resetToken,
        );
        // assert
        expect(
          result,
          left(ServerSideFormFieldValidationFailure(
            error: bodyContent['error'] as String?,
            field: bodyContent['field'] as String?,
            message: bodyContent['message'] as String?,
            reason: bodyContent['reason'] as String?,
          ),),
        );
      });
    });
    group('request', () {
      test(
          'should response ResetPasswordResponseEntity for a successful request',
          () async {
        // arrange
        final bodyContent = await JsonUtil.getJson(
            from: 'authentication/request_reset_password.json',);
        final modelResponse = PasswordResetResponseModel.fromJson(bodyContent);
        mockRequestDataSource().thenAnswer((_) async => modelResponse);
        // act
        final result = await sut.request(emailAddress: emailAddress);
        // assert
        expect(
          result,
          right(PasswordResetResponseModel(
            message: bodyContent['message'] as String?,
            digits: bodyContent['digits'] as int?,
            ttl: bodyContent['ttl'] as int?,
            ttlRetry: bodyContent['min_ttl_retry'] as int?,
          ),),
        );
      });
      test(
          'should return ServerSideFormFieldValidationFailure for non successful change password request',
          () async {
        // arrange
        final bodyContent =
            await JsonUtil.getJson(from: 'authentication/email_not_found.json');
        mockRequestDataSource()
            .thenThrow(ApiProviderException(bodyContent: bodyContent));
        // act
        final result = await sut.request(
          emailAddress: emailAddress,
        );
        // assert
        expect(
          result,
          left(ServerSideFormFieldValidationFailure(
            error: bodyContent['error'] as String?,
            field: bodyContent['field'] as String?,
            message: bodyContent['message'] as String?,
            reason: bodyContent['reason'] as String?,
          ),),
        );
      });
    });
  });
}
