import 'package:http/http.dart' as http;
import 'package:penhas/app/core/managers/app_configuration.dart';
import 'package:penhas/app/core/managers/audio_play_services.dart';
import 'package:penhas/app/core/managers/audio_record_services.dart';
import 'package:penhas/app/core/managers/audio_sync_manager.dart';
import 'package:penhas/app/core/managers/location_services.dart';
import 'package:penhas/app/core/managers/modules_sevices.dart';
import 'package:penhas/app/core/managers/user_profile_store.dart';
import 'package:penhas/app/core/network/api_client.dart';
import 'package:penhas/app/core/network/api_server_configure.dart';
import 'package:penhas/app/core/network/network_info.dart';
import 'package:penhas/app/core/states/mainboard_store.dart';
import 'package:penhas/app/features/appstate/data/datasources/app_state_data_source.dart';
import 'package:penhas/app/features/appstate/data/repositories/app_state_repository.dart';
import 'package:penhas/app/features/appstate/domain/repositories/i_app_state_repository.dart';
import 'package:penhas/app/features/appstate/domain/usecases/app_state_usecase.dart';
import 'package:penhas/app/features/feed/data/datasources/tweet_data_source.dart';
import 'package:penhas/app/features/feed/data/datasources/tweet_filter_preference_data_source.dart';
import 'package:penhas/app/features/feed/data/repositories/tweet_filter_preference_repository.dart';
import 'package:penhas/app/features/feed/data/repositories/tweet_repository.dart';
import 'package:penhas/app/features/feed/domain/repositories/i_tweet_repositories.dart';
import 'package:penhas/app/features/feed/domain/usecases/feed_use_cases.dart';
import 'package:penhas/app/features/feed/domain/usecases/tweet_filter_preference.dart';
import 'package:penhas/app/features/feed/presentation/category_tweet/category_tweet_controller.dart';
import 'package:penhas/app/features/feed/presentation/category_tweet/category_tweet_page.dart';
import 'package:penhas/app/features/feed/presentation/compose_tweet/compose_tweet_controller.dart';
import 'package:penhas/app/features/feed/presentation/detail_tweet/detail_tweet_controller.dart';
import 'package:penhas/app/features/feed/presentation/detail_tweet/detail_tweet_page.dart';
import 'package:penhas/app/features/feed/presentation/filter_tweet/filter_tweet_controller.dart';
import 'package:penhas/app/features/feed/presentation/filter_tweet/filter_tweet_page.dart';
import 'package:penhas/app/features/feed/presentation/reply_tweet/reply_tweet_controller.dart';
import 'package:penhas/app/features/feed/presentation/reply_tweet/reply_tweet_page.dart';
import 'package:penhas/app/features/feed/presentation/stores/tweet_controller.dart';
import 'package:penhas/app/features/help_center/data/datasources/guardian_data_source.dart';
import 'package:penhas/app/features/help_center/data/repositories/audios_repository.dart';
import 'package:penhas/app/features/help_center/data/repositories/guardian_repository.dart';
import 'package:penhas/app/features/help_center/presentation/audios/audios_controller.dart';
import 'package:penhas/app/features/help_center/presentation/audios/audios_page.dart';
import 'package:penhas/app/features/help_center/presentation/guardians/guardians_controller.dart';
import 'package:penhas/app/features/help_center/presentation/guardians/guardians_page.dart';
import 'package:penhas/app/features/help_center/presentation/new_guardian/new_guardian_controller.dart';
import 'package:penhas/app/features/help_center/presentation/new_guardian/new_guardian_page.dart';
import 'package:penhas/app/features/help_center/presentation/pages/audio/audio_record_page.dart';
import 'package:penhas/app/features/main_menu/domain/repositories/user_profile_repository.dart';
import 'package:penhas/app/features/main_menu/domain/usecases/user_profile.dart';
import 'package:penhas/app/features/mainboard/presentation/mainboard/mainboard_controller.dart';
import 'package:penhas/app/features/main_menu/presentation/penhas_drawer_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:penhas/app/features/mainboard/presentation/mainboard/mainboard_page.dart';

class MainboardModule extends ChildModule {
  @override
  List<Bind> get binds => [
        ...interfaceBinds,
        ...drawerBinds,
        ...tweetBinds,
        ...helpCenterBinds,
        ...audioServicesBinds,
        Bind<MainboardStore>((i) => MainboardStore()),
        Bind(
          (i) => MainboardController(
              mainboardStore: i.get<MainboardStore>(),
              userProfileStore: i.get<IUserProfileStore>()),
        ),
        Bind(
          (i) => FeedUseCases(
            repository: i.get<ITweetRepository>(),
            filterPreference: i.get<TweetFilterPreference>(),
            maxRows: 10,
          ),
          singleton: true,
        ),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, child: (_, args) => MainboardPage()),
        ...tweetRoutes,
        ...helpCenter,
        ...audioRecord,
      ];

  List<Router> get tweetRoutes => [
        Router(
          '/reply',
          child: (_, args) => ReplyTweetPage(),
          transition: TransitionType.rightToLeft,
        ),
        Router(
          '/detail',
          child: (context, args) => DetailTweetPage(
            tweetController: Modular.get<ITweetController>(),
          ),
          transition: TransitionType.rightToLeft,
        ),
        Router(
          '/category',
          child: (context, args) => CategoryTweetPage(),
          transition: TransitionType.rightToLeft,
        ),
        Router(
          '/tags',
          child: (context, args) => FilterTweetPage(),
          transition: TransitionType.rightToLeft,
        )
      ];

  List<Router> get helpCenter => [
        Router(
          '/helpcenter/newGuardian',
          child: (context, args) => NewGuardianPage(),
          transition: TransitionType.rightToLeft,
        ),
        Router(
          '/helpcenter/guardians',
          child: (context, args) => GuardiansPage(),
          transition: TransitionType.rightToLeft,
        ),
        Router(
          '/helpcenter/audios',
          child: (context, args) => AudiosPage(),
          transition: TransitionType.rightToLeft,
        ),
      ];

  List<Router> get audioRecord => [
        Router(
          '/helpcenter/audioRecord',
          child: (context, args) => AudioRecordPage(),
          transition: TransitionType.rightToLeft,
        )
      ];

  List<Bind> get audioServicesBinds => [
        Bind<IAudioRecordServices>(
          (i) => AudioRecordServices(
            audioSyncManager: i.get<IAudioSyncManager>(),
          ),
          singleton: false,
        ),
        Bind<IAudioPlayServices>(
          (i) => AudioPlayServices(
            audioSyncManager: i.get<IAudioSyncManager>(),
          ),
        )
      ];

  List<Bind> get tweetBinds => [
        Bind(
          (i) => ComposeTweetController(
            useCase: i.get<FeedUseCases>(),
            mainboardStore: i.get<MainboardStore>(),
          ),
          singleton: false,
        ),
        Bind(
          (i) => ReplyTweetController(
            useCase: i.get<FeedUseCases>(),
            tweet: i.args.data,
          ),
          singleton: false,
        ),
        Bind(
          (i) => DetailTweetController(
            useCase: i.get<FeedUseCases>(),
            tweet: i.args.data,
          ),
          singleton: false,
        ),
        Bind(
          (i) => CategoryTweetController(
            useCase: i.get<TweetFilterPreference>(),
          ),
        ),
        Bind(
          (i) => FilterTweetController(
            useCase: i.get<TweetFilterPreference>(),
          ),
          singleton: true,
        ),
      ];

  List<Bind> get interfaceBinds => [
        Bind<ITweetController>(
          (i) => TweetController(useCase: i.get<FeedUseCases>()),
        ),
        Bind<ITweetRepository>(
          (i) => TweetRepository(
            networkInfo: i.get<INetworkInfo>(),
            dataSource: i.get<ITweetDataSource>(),
          ),
        ),
        Bind<ITweetDataSource>(
          (i) => TweetDataSource(
            apiClient: i.get<http.Client>(),
            serverConfiguration: i.get<IApiServerConfigure>(),
          ),
        ),
        Bind<ITweetFilterPreferenceDataSource>(
          (i) => TweetFilterPreferenceDataSource(
            apiClient: i.get<http.Client>(),
            serverConfiguration: i.get<IApiServerConfigure>(),
          ),
        ),
        Bind<ITweetFilterPreferenceRepository>(
          (i) => TweetFilterPreferenceRepository(
            networkInfo: i.get<INetworkInfo>(),
            dataSource: i.get<ITweetFilterPreferenceDataSource>(),
          ),
        ),
        Bind<TweetFilterPreference>(
          (i) => TweetFilterPreference(
            repository: i.get<ITweetFilterPreferenceRepository>(),
          ),
        ),
        Bind<ILocationServices>(
          (i) => LocationServices(),
        ),
      ];

  List<Bind> get drawerBinds => [
        Bind(
          (i) => PenhasDrawerController(
            appConfigure: i.get<IAppConfiguration>(),
            userProfile: i.get<UserProfile>(),
            modulesServices: i.get<IAppModulesServices>(),
          ),
        ),
        Bind<UserProfile>(
          (i) => UserProfile(
            repository: i.get<IUserProfileRepository>(),
            userProfileStore: i.get<IUserProfileStore>(),
            appStateUseCase: i.get<AppStateUseCase>(),
          ),
        ),
        Bind<AppStateUseCase>(
          (i) => AppStateUseCase(
              appStateRepository: i.get<IAppStateRepository>(),
              userProfileStore: i.get<IUserProfileStore>(),
              appConfiguration: i.get<IAppConfiguration>(),
              appModulesServices: i.get<IAppModulesServices>()),
        ),
        Bind<IAppStateRepository>(
          (i) => AppStateRepository(
            networkInfo: i.get<INetworkInfo>(),
            dataSource: i.get<IAppStateDataSource>(),
          ),
        ),
        Bind<IAppStateDataSource>(
          (i) => AppStateDataSource(
            apliClient: i.get<http.Client>(),
            serverConfiguration: i.get<IApiServerConfigure>(),
          ),
        ),
        Bind<IUserProfileRepository>(
          (i) => UserProfileRepository(
            apiProvider: i.get<IApiProvider>(),
          ),
        )
      ];

  List<Bind> get helpCenterBinds => [
        Bind(
          (i) => NewGuardianController(
              guardianRepository: i.get<IGuardianRepository>(),
              locationService: i.get<ILocationServices>()),
        ),
        Bind(
          (i) => GuardiansController(
            guardianRepository: i.get<IGuardianRepository>(),
          ),
        ),
        Bind(
          (i) => AudiosController(
              audiosRepository: i.get<IAudiosRepository>(),
              audioPlayServices: i.get<IAudioPlayServices>()),
        ),
        Bind(
          (i) => AudiosRepository(
            apiProvider: i.get<IApiProvider>(),
          ),
        ),
        Bind<IGuardianRepository>(
          (i) => GuardianRepository(
            dataSource: i.get<IGuardianDataSource>(),
            networkInfo: i.get<INetworkInfo>(),
          ),
        ),
        Bind<IGuardianDataSource>(
          (i) => GuardianDataSource(
            apiClient: i.get<http.Client>(),
            serverConfiguration: i.get<IApiServerConfigure>(),
          ),
        ),
      ];

  static Inject get to => Inject<MainboardModule>.of();
}
