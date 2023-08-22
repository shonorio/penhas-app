import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penhas/app/features/authentication/domain/usecases/password_validator.dart';
import 'package:penhas/app/features/authentication/presentation/reset_password/pages/reset_password_three/reset_password_three_controller.dart';
import 'package:penhas/app/features/authentication/presentation/reset_password/pages/reset_password_three/reset_password_three_page.dart';
import 'package:penhas/app/features/authentication/presentation/shared/user_register_form_field_model.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in/sign_in_module.dart';

import '../../../../../../../utils/golden_tests.dart';
import '../../../../../../../utils/widget_test_steps.dart';
import '../../../mocks/app_modules_mock.dart';
import '../../../mocks/authentication_modules_mock.dart';

void main() {
  late UserRegisterFormFieldModel userRegisterFormField;

  setUp(() {
    AppModulesMock.init();
    AuthenticationModulesMock.init();
    userRegisterFormField = UserRegisterFormFieldModel();

    initModule(
      SignInModule(),
      replaceBinds: [
        Bind<ResetPasswordThreeController>(
          (i) => ResetPasswordThreeController(
            AuthenticationModulesMock.changePasswordRepository,
            userRegisterFormField,
            AuthenticationModulesMock.passwordValidator,
          ),
        ),
      ],
    );
  });

  tearDown(() {
    Modular.removeModule(SignInModule());
  });

  group(ResetPasswordThreePage, () {
    testWidgets(
      'show screen widgets',
      (tester) async {
        await theAppIsRunning(tester, const ResetPasswordThreePage());

        // check that required widgets are present
        await iSeeText('Configure uma nova senha');
        await iSeeText('Crie uma senha diferente das anteriores');
        await iSeePasswordField(text: 'Senha');
        await iSeePasswordField(text: 'Confirmação de senha');
        await iSeeButton(text: 'Salvar');
      },
    );

    testWidgets(
      'invalid password shows hint message',
      (tester) async {
        when(() => AuthenticationModulesMock.passwordValidator.validate(
            any(), any())).thenAnswer((i) => dartz.left(MinLengthRule()));

        // Input a invalid password
        await theAppIsRunning(tester, const ResetPasswordThreePage());
        await iEnterIntoPasswordField(tester, text: 'Senha', password: '1');
        await iSeePasswordFieldErrorMessage(tester,
            text: 'Senha', message: 'Senha precisa ter no mínimo 8 caracteres');
      },
    );

    group('golden test', () {
      screenshotTest(
        'looks as expected',
        fileName: 'reset_password_page_step_3',
        pageBuilder: () => const ResetPasswordThreePage(),
      );
    });
  });
}
