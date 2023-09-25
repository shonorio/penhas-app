import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:penhas/app/features/appstate/domain/entities/app_state_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_assistant_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_channel_available_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_channel_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_user_entity.dart';
import 'package:penhas/app/features/chat/domain/usecases/chat_toggle_feature.dart';
import 'package:penhas/app/features/chat/presentation/chat_main_module.dart';
import 'package:penhas/app/features/chat/presentation/pages/chat_assistant_card.dart';
import 'package:penhas/app/features/chat/presentation/pages/chat_channel_card.dart';
import 'package:penhas/app/features/chat/presentation/people/chat_main_people_controller.dart';
import 'package:penhas/app/features/chat/presentation/talk/chat_main_talks_controller.dart';
import 'package:penhas/app/features/chat/presentation/talk/chat_main_talks_page.dart';

import '../../../../../utils/mocktail_extension.dart';
import '../../../../../utils/widget_test_steps.dart';
import '../../../authentication/presentation/mocks/app_modules_mock.dart';
import '../../mocks/chat_modules_mock.dart';

void main() {
  setUp(() {
    AppModulesMock.init();
    ChatModulesMock.init();

    initModule(
      ChatMainModule(),
      replaceBinds: [
        Bind<ChatPrivateToggleFeature>(
          (i) => ChatPrivateToggleFeature(
              modulesServices: AppModulesMock.appModulesServices),
        ),
        Bind<ChatMainTalksController>(
          (i) => ChatMainTalksController(
            chatChannelRepository: ChatModulesMock.channelRepository,
          ),
        ),
        Bind<ChatMainPeopleController>(
          (i) => ChatMainPeopleController(
            usersRepository: ChatModulesMock.usersRepository,
            skillRepository: ChatModulesMock.filterSkillRepository,
          ),
        ),
      ],
    );
  });

  tearDown(() {
    Modular.removeModule(ChatMainModule());
  });

  group(ChatMainTalksPage, () {
    testWidgets(
      'start with loading state',
      (tester) async {
        when(() => ChatModulesMock.channelRepository.listChannel())
            .thenSuccess((_) => ChatChannelAvailableEntityEx.empty);
        await theAppIsRunning(
            tester, const Scaffold(body: ChatMainTalksPage()));
        // start with loading state
        await iSeeWidget(CircularProgressIndicator);
      },
    );
    testWidgets(
      'without channels shows only assistant card',
      (tester) async {
        when(() => ChatModulesMock.channelRepository.listChannel())
            .thenSuccess((_) => ChatChannelAvailableEntityEx.empty);
        await theAppIsRunning(
            tester, const Scaffold(body: ChatMainTalksPage()));
        // updated state
        await mockNetworkImages(() async {
          await tester.pump();
          // i found only assistant card widgets
          await iDontSeeText('Suas conversas (2)');
          await iDontSeeWidget(ChatChannelCard, text: 'Tereza');
          await iDontSeeWidget(ChatChannelCard, text: 'Maria');
          await iSeeWidget(ChatAssistantCard, text: 'Assistente PenhaS');
          await iSeeWidget(ChatAssistantCard, text: 'Suporte PenhaS');
        });
      },
    );

    testWidgets(
      'with channel shows the channel cards',
      (tester) async {
        when(() => ChatModulesMock.channelRepository.listChannel())
            .thenSuccess((_) => ChatChannelAvailableEntityEx.withChannel);

        await theAppIsRunning(
            tester, const Scaffold(body: ChatMainTalksPage()));
        // updated state
        await mockNetworkImages(() async {
          await tester.pump();
          // i found all cards
          await iSeeWidget(ChatAssistantCard, text: 'Assistente PenhaS');
          await iSeeWidget(ChatAssistantCard, text: 'Suporte PenhaS');
          await iSeeText('Suas conversas (2)');
          await iSeeWidget(ChatChannelCard, text: 'Tereza');
          await iSeeWidget(ChatChannelCard, text: 'Maria');
        });
      },
    );
  });
}

extension ChatChannelAvailableEntityEx on ChatChannelAvailableEntity {
  static ChatChannelAvailableEntity get empty {
    return ChatChannelAvailableEntity(
      assistant: _assistant,
      support: _support,
      hasMore: false,
      nextPage: null,
      channels: const [],
    );
  }

  static ChatChannelAvailableEntity get withChannel {
    return ChatChannelAvailableEntity(
      assistant: _assistant,
      support: _support,
      hasMore: false,
      nextPage: null,
      channels: [
        ChatChannelEntity(
          token: '__my_ultra_secret_session__',
          lastMessageTime: DateTime(2020, 10, 04, 9, 20, 37),
          lastMessageIsMime: true,
          user: const ChatUserEntity(
            activity: 'há pouco tempo',
            avatar: null,
            blockedMe: false,
            nickname: 'Tereza',
            userId: null,
          ),
        ),
        ChatChannelEntity(
          token: '__my_very_secret_session__',
          lastMessageTime: DateTime(2020, 9, 28, 9, 15, 37),
          lastMessageIsMime: true,
          user: const ChatUserEntity(
            activity: 'há alguns dias',
            // avatar: 'https://api.example.com/avatar/p2.svg',
            avatar: null,
            blockedMe: false,
            nickname: 'Maria',
            userId: null,
          ),
        )
      ],
    );
  }

  static ChatAssistantEntity get _assistant {
    const currentMessage = QuizMessageEntity(
      ref: 'reset_questionnaire',
      type: QuizMessageType.yesno,
      content: 'Deseja responder o questionário novamente?',
    );

    const quizSession = QuizSessionEntity(
      currentMessage: [currentMessage],
      sessionId: 'Ada24',
      isFinished: false,
      endScreen: null,
    );

    return const ChatAssistantEntity(
      title: 'Assistente PenhaS',
      subtitle: 'Entenda se você está em situação de violência',
      avatar: null,
      quizSession: quizSession,
    );
  }

  static ChatChannelEntity get _support {
    return ChatChannelEntity(
      token: 'Sda24',
      lastMessageTime: DateTime(2020, 9, 9, 1, 0, 58),
      lastMessageIsMime: true,
      user: const ChatUserEntity(
        activity: '',
        nickname: 'Suporte PenhaS',
        avatar: 'https://api.example.com/avatar/suporte-chat.png',
        userId: null,
        blockedMe: false,
      ),
    );
  }
}
