import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penhas/app/core/extension/either.dart';
import 'package:penhas/app/features/authentication/domain/usecases/password_validator.dart';
import 'package:penhas/app/features/authentication/presentation/shared/user_register_form_field_model.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in/sign_in_module.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in/sign_up/pages/sign_up_three/sign_up_three_controller.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in/sign_up/pages/sign_up_three/sign_up_three_page.dart';

import '../../../../../../../../utils/golden_tests.dart';
import '../../../../../../../../utils/widget_test_steps.dart';
import '../../../../mocks/app_modules_mock.dart';
import '../../../../mocks/authentication_modules_mock.dart';

void main() {
  late UserRegisterFormFieldModel userFormField;

  setUp(() {
    AppModulesMock.init();
    AuthenticationModulesMock.init();
    userFormField = UserRegisterFormFieldModel();

    initModule(SignInModule(), replaceBinds: [
      Bind<SignUpThreeController>(
        (i) => SignUpThreeController(
          AuthenticationModulesMock.userRegisterRepository,
          userFormField,
          AuthenticationModulesMock.passwordValidator,
        ),
      ),
    ]);
  });

  tearDown(() {
    Modular.removeModule(SignInModule());
  });

  group(SignUpThreePage, () {
    testWidgets(
      'shows screen widgets',
      (tester) async {
        await theAppIsRunning(tester, const SignUpThreePage());

        // check if necessary widgets are present
        await iSeeText('Crie sua conta');
        await iSeeText(
            'Informe um email e defina uma senha segura. A senha precisa ter no mínimo 8 caracteres, com ao menos 1 letra, 1 número e 1 caractere especial.');
        await iSeeSingleTextInput(text: 'E-mail');
        await iSeePasswordField(text: 'Senha');
        await iSeePasswordField(text: 'Confirmação de senha');
        await iSeeButton(text: 'Cadastrar');
      },
    );

    testWidgets(
      'shows a warning message for invalid form fields',
      (tester) async {
        when(() => AuthenticationModulesMock.passwordValidator.validate(
            any(), any())).thenAnswer((_) => failure(MinLengthRule()));

        await theAppIsRunning(tester, const SignUpThreePage());
        await iEnterIntoPasswordField(
          tester,
          text: 'Confirmação de senha',
          password: '1',
        );
        await iTapText(tester, text: 'Cadastrar');

        iSeeSingleTextInputErrorMessage(
          tester,
          text: 'E-mail',
          message: 'Endereço de email inválido',
        );
        iSeePasswordFieldErrorMessage(
          tester,
          text: 'Senha',
          message: 'Senha precisa ter no mínimo 8 caracteres',
        );
        iSeePasswordFieldErrorMessage(
          tester,
          text: 'Confirmação de senha',
          message: 'As senhas não são iguais',
        );
      },
    );
    screenshotTest(
      'looks as expected',
      fileName: 'sign_up_step_3_page',
      pageBuilder: () => const SignUpThreePage(),
    );
  });
}
