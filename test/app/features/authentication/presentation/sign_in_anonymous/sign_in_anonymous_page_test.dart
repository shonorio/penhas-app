import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penhas/app/features/appstate/domain/entities/user_profile_entity.dart';
import 'package:penhas/app/features/authentication/domain/entities/session_entity.dart';
import 'package:penhas/app/features/authentication/domain/usecases/password_validator.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in/sign_in_module.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in_anonymous/sign_in_anonymous_controller.dart';
import 'package:penhas/app/features/authentication/presentation/sign_in_anonymous/sign_in_anonymous_page.dart';

import '../../../../../utils/golden_tests.dart';
import '../../../../../utils/widget_test_steps.dart';
import '../mocks/app_modules_mock.dart';
import '../mocks/authentication_modules_mock.dart';

void main() {
  setUp(() {
    AppModulesMock.init();
    AuthenticationModulesMock.init();

    final userProfileEntity = UserProfileEntity(
      fullName: 'fullName',
      nickname: 'nickname',
      email: 'email@testing.com',
      birthdate: DateTime(1970),
      genre: 'genre',
      minibio: 'minibio',
      race: 'race',
      avatar: 'avatar',
      skill: const ['skill1', 'skill2'],
      stealthModeEnabled: true,
      anonymousModeEnabled: true,
      jaFoiVitimaDeViolencia: false,
    );

    when(() => AppModulesMock.userProfileStore.retrieve()).thenAnswer(
      (i) async => userProfileEntity,
    );

    initModule(SignInModule(), replaceBinds: [
      Bind<SignInAnonymousController>(
        (i) => SignInAnonymousController(
          repository: AuthenticationModulesMock.authenticationRepository,
          userProfileStore: AppModulesMock.userProfileStore,
          passwordValidator: AuthenticationModulesMock.passwordValidator,
        ),
      ),
    ]);
  });

  tearDown(() {
    Modular.removeModule(SignInModule());
  });

  group(SignInAnonymousPage, () {
    testWidgets(
      'shows screen widgets',
      (tester) async {
        await theAppIsRunning(tester, const SignInAnonymousPage());

        // check if necessary widgets are present
        await iSeePasswordField(text: 'Senha');
        await iSeeButton(text: 'Entrar');
        await iSeeButton(text: 'Esqueci minha senha');
        await iSeeButton(text: 'Acessar outra conta');
      },
    );

    testWidgets(
      'invalid password shows a message error when tapping LoginButton',
      (WidgetTester tester) async {
        const validPassword = 'myStr0ngP4ssw0rd';
        const errorMessage =
            'E-mail e senha precisam estarem corretos para continuar.';

        when(() => AuthenticationModulesMock.passwordValidator
            .validate(any(), any())).thenAnswer((i) => dartz.left(EmptyRule()));

        await theAppIsRunning(tester, const SignInAnonymousPage());
        await iDontSeeText(errorMessage);
        await iEnterIntoPasswordField(tester,
            text: 'Senha', password: validPassword);
        await iTapText(tester, text: 'Entrar');
        await iSeeText(errorMessage);
      },
    );

    testWidgets(
      'success login redirect page',
      (WidgetTester tester) async {
        const sessionToken = 'sessionToken';
        const validPassword = 'myStr0ngP4ssw0rd';

        when(() => AuthenticationModulesMock.passwordValidator.validate(
            any(), any())).thenAnswer((i) => dartz.right(validPassword));
        when(
          () => AuthenticationModulesMock.authenticationRepository
              .signInWithEmailAndPassword(
            emailAddress: any(named: 'emailAddress'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (i) async =>
              dartz.right(const SessionEntity(sessionToken: sessionToken)),
        );
        when(() => AppModulesMock.appStateUseCase.check())
            .thenAnswer((i) async => dartz.right(FakeAppStateEntity()));

        when(
          () => AppModulesMock.modularNavigator
              .pushReplacementNamed(any(), arguments: any(named: 'arguments')),
        ).thenAnswer((_) => Future.value());

        await theAppIsRunning(tester, const SignInAnonymousPage());
        await iEnterIntoPasswordField(tester,
            text: 'Senha', password: validPassword);
        await iTapText(tester, text: 'Entrar');

        verify(() => AppModulesMock.modularNavigator
            .pushReplacementNamed('/mainboard')).called(1);
      },
    );

    testWidgets(
      'reset password button redirect page',
      (WidgetTester tester) async {
        when(
          () => AppModulesMock.modularNavigator
              .pushNamed(any(), arguments: any(named: 'arguments')),
        ).thenAnswer((_) => Future.value());

        await theAppIsRunning(tester, const SignInAnonymousPage());
        await iTapText(tester, text: 'Esqueci minha senha');

        verify(() => AppModulesMock.modularNavigator
            .pushNamed('/authentication/reset_password')).called(1);
      },
    );

    testWidgets(
      'change account button redirect page',
      (WidgetTester tester) async {
        when(
          () => AppModulesMock.modularNavigator
              .pushNamed(any(), arguments: any(named: 'arguments')),
        ).thenAnswer((_) => Future.value());

        await theAppIsRunning(tester, const SignInAnonymousPage());
        await iTapText(tester, text: 'Acessar outra conta');

        verify(() =>
                AppModulesMock.modularNavigator.pushNamed('/authentication'))
            .called(1);
      },
    );

    group('golden test', () {
      screenshotTest(
        'looks as expected',
        fileName: 'sign_in_anonymous_page',
        pageBuilder: () => const SignInAnonymousPage(),
      );
    });
  });
}
