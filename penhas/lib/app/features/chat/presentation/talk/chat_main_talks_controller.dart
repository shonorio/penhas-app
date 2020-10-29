import 'package:dartz/dartz.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/features/authentication/presentation/shared/map_failure_message.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_channel_available_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_channel_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_channel_open_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_main_tile_entity.dart';
import 'package:penhas/app/features/chat/domain/entities/chat_user_entity.dart';

import 'package:penhas/app/features/chat/domain/repositories/chat_channel_repository.dart';
import 'package:penhas/app/features/chat/domain/states/chat_main_talks_state.dart';

part 'chat_main_talks_controller.g.dart';

class ChatMainTalksController extends _ChatMainTalksControllerBase
    with _$ChatMainTalksController {
  ChatMainTalksController({
    @required IChatChannelRepository chatChannelRepository,
  }) : super(chatChannelRepository);
}

abstract class _ChatMainTalksControllerBase with Store, MapFailureMessage {
  final IChatChannelRepository _chatChannelRepository;

  _ChatMainTalksControllerBase(this._chatChannelRepository) {
    _init();
  }

  Future<void> _init() async {
    await loadScreen();
  }

  @observable
  ObservableFuture<Either<Failure, ChatChannelAvailableEntity>> _fetchProgress;

  @observable
  ChatMainTalksState currentState = ChatMainTalksState.initial();

  @action
  Future<void> reload() async {}

  @action
  Future<void> openChannel(ChatChannelEntity channel) async {
    ChatChannelOpenEntity session =
        ChatChannelOpenEntity(token: channel.token, session: null);

    await forwardToChat(session);
  }

  @action
  Future<void> openAssistantCard(ChatMainSupportTile data) async {
    if (data.quizSession != null) {
      return Modular.to.popAndPushNamed('/quiz', arguments: data.quizSession);
    }

    ChatChannelOpenEntity session =
        ChatChannelOpenEntity(token: data.channel.token, session: null);

    await forwardToChat(session);
  }
}

extension _ChatMainTalksControllerBasePrivate on _ChatMainTalksControllerBase {
  Future<void> forwardToChat(ChatChannelOpenEntity session) async {
    return Modular.to.pushNamed("/mainboard/chat", arguments: session).then(
      (value) async {
        if (value is bool && value) {
          await loadScreen();
        }
      },
    );
  }

  Future<void> loadScreen() async {
    currentState = ChatMainTalksState.loading();
    _fetchProgress = ObservableFuture(_chatChannelRepository.listChannel());

    final response = await _fetchProgress;

    response.fold(
      (failure) => handleLoadPageError(failure),
      (session) => handleLoadSession(session),
    );
  }

  void handleLoadSession(ChatChannelAvailableEntity session) {
    List<ChatMainTileEntity> tiles = List<ChatMainTileEntity>();
    List<ChatMainSupportTile> cards = List<ChatMainSupportTile>();

    if (session.assistant != null) {
      cards.add(
        ChatMainSupportTile(
          title: session.assistant.title,
          content: session.assistant.subtitle,
          channel: ChatChannelEntity(
            token: null,
            lastMessageTime: null,
            lastMessageIsMime: null,
            user: ChatUserEntity(
              userId: null,
              activity: null,
              blockedMe: false,
              avatar: session.assistant.avatar,
              nickname: session.assistant.title,
            ),
          ),
          quizSession: session.assistant.quizSession,
        ),
      );
    }

    if (session.support != null) {
      cards.add(
        ChatMainSupportTile(
          title: session.support.user.nickname,
          content: "Fale com as adminstradoras do app",
          channel: session.support,
        ),
      );
    }

    if (cards.isNotEmpty) {
      tiles.add(ChatMainAssistantCardTile(cards: cards));
    }

    if (session.channels.isNotEmpty) {
      final total = session.channels.length;
      final title = total > 1 ? "Suas conversas ($total)" : "Sua conversa";
      tiles.add(ChatMainChannelHeaderTile(title: title));
      final channels = session.channels
          .map((e) => ChatMainChannelCardTile(channel: e))
          .toList();
      tiles.addAll(channels);
    }

    currentState = ChatMainTalksState.loaded(tiles);
  }

  void handleLoadPageError(Failure failure) {
    final message = mapFailureMessage(failure);
    currentState = ChatMainTalksState.error(message);
  }
}