import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:penhas/app/features/chat/domain/states/chat_channel_usecase_event.dart';
import 'package:penhas/app/features/chat/presentation/chat/chat_channel_controller.dart';
import 'package:penhas/app/features/chat/presentation/chat/chat_channel_page.dart';
import 'package:penhas/app/features/chat/presentation/chat_main_module.dart';
import 'package:penhas/app/features/mainboard/presentation/mainboard/mainboard_module.dart';

import '../../../../../utils/golden_tests.dart';
import '../../../../../utils/widget_test_steps.dart';
import '../../../authentication/presentation/mocks/app_modules_mock.dart';
import '../../mocks/chat_modules_mock.dart';

void main() {
  setUp(() {
    AppModulesMock.init();
    ChatModulesMock.init();

    initModules([
      MainboardModule(),
      ChatMainModule(),
    ], replaceBinds: [
      Bind<ChatChannelController>(
        (i) => ChatChannelController(
          useCase: ChatModulesMock.channelUseCase,
        ),
      ),
    ]);
  });

  tearDown(() {
    Modular.removeModule(ChatMainModule());
    Modular.removeModule(MainboardModule());
  });

  group(ChatPage, () {
    testWidgets(
      'in the initial state shows a loading page',
      (tester) async {
        when(() => ChatModulesMock.channelUseCase.dataSource).thenAnswer(
          (_) => Stream<ChatChannelUseCaseEvent>.fromIterable(
            [const ChatChannelUseCaseEvent.initial()],
          ),
        );

        await theAppIsRunning(tester, const ChatPage());
        await iSeeText('Carregando...');
      },
    );

    testWidgets(
      'shows an error message for the error state',
      (tester) async {
        when(() => ChatModulesMock.channelUseCase.dataSource).thenAnswer(
          (_) => Stream<ChatChannelUseCaseEvent>.fromIterable(
            [const ChatChannelUseCaseEvent.errorOnLoading('Server error!')],
          ),
        );

        await theAppIsRunning(tester, const ChatPage());
        await tester.pumpAndSettle();
        await iSeeText('Ocorreu um erro!');
        await iSeeText('Server error!');
      },
    );

    group(
      'golden tests',
      () {
        screenshotTest(
          'show errors as expected',
          fileName: 'chat_page_error',
          pageBuilder: () => const ChatPage(),
          setUp: () {
            when(() => ChatModulesMock.channelUseCase.dataSource).thenAnswer(
              (_) => Stream<ChatChannelUseCaseEvent>.fromIterable(
                [
                  const ChatChannelUseCaseEvent.errorOnLoading(
                      'O servidor está inacessível, o PenhaS está com acesso à Internet?')
                ],
              ),
            );
          },
        );
      },
    );
  });
}
