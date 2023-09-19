import 'package:mocktail/mocktail.dart';
import 'package:penhas/app/features/chat/domain/repositories/chat_channel_repository.dart';
import 'package:penhas/app/features/filters/data/repositories/filter_skill_repository.dart';
import 'package:penhas/app/features/users/data/repositories/users_repository.dart';

class ChatModulesMock {
  static late IUsersRepository usersRepository;
  static late IChatChannelRepository channelRepository;
  static late IFilterSkillRepository filterSkillRepository;

  static void init() {
    _initMocks();
  }

  static void _initMocks() {
    usersRepository = MockUsersRepository();
    channelRepository = MockChatChannelRepository();
    filterSkillRepository = MockFilterSkillRepository();
  }
}

///
/// Mock classes
///

class MockChatChannelRepository extends Mock implements IChatChannelRepository {
}

class MockUsersRepository extends Mock implements IUsersRepository {}

class MockFilterSkillRepository extends Mock implements IFilterSkillRepository {
}
