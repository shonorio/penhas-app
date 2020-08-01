import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:penhas/app/core/entities/valid_fiel.dart';
import 'package:penhas/app/core/network/api_server_configure.dart';
import 'package:penhas/app/features/help_center/data/datasources/guardian_data_source.dart';
import 'package:penhas/app/features/help_center/domain/entities/guardian_session_entity.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockApiServerConfigure extends Mock implements IApiServerConfigure {}

void main() {
  MockHttpClient apiClient;
  IGuardianDataSource dataSource;
  MockApiServerConfigure serverConfigure;
  Uri serverEndpoint;
  const String SESSSION_TOKEN = 'my_really.long.JWT';

  setUp(() async {
    apiClient = MockHttpClient();
    serverConfigure = MockApiServerConfigure();
    serverEndpoint = Uri.https('api.anyserver.io', '/');
    dataSource = GuardianDataSource(
      apiClient: apiClient,
      serverConfiguration: serverConfigure,
    );

    // MockApiServerConfigure configuration
    when(serverConfigure.baseUri).thenAnswer((_) => serverEndpoint);
    when(serverConfigure.apiToken)
        .thenAnswer((_) => Future.value(SESSSION_TOKEN));
    when(serverConfigure.userAgent)
        .thenAnswer((_) => Future.value("iOS 11.4/Simulator/1.0.0"));
  });

  Future<Map<String, String>> _setUpHttpHeader() async {
    final userAgent = await serverConfigure.userAgent;
    return {
      'X-Api-Key': SESSSION_TOKEN,
      'User-Agent': userAgent,
      'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
    };
  }

  Uri _setuHttpRequest(String path, Map<String, String> queryParameters) {
    return Uri(
      scheme: serverEndpoint.scheme,
      host: serverEndpoint.host,
      path: path,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
  }

  void _setUpMockPostHttpClientSuccess204() {
    when(
      apiClient.delete(
        any,
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async => http.Response(
        '',
        204,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8'
        },
      ),
    );
  }

  group(
    'GuardianDataSource',
    () {
      GuardianContactEntity guardian;

      setUp(() async {
        guardian = GuardianContactEntity(
          id: 1,
          name: 'Maria',
          mobile: '1191910101',
          status: 'pending',
        );
      });

      group('delete()', () {
        test(
          'should perform a DELETE with X-API-Key',
          () async {
            // arrange
            final endPointPath = '/me/guardioes/${guardian.id}';
            final headers = await _setUpHttpHeader();
            final request = _setuHttpRequest(endPointPath, {});
            _setUpMockPostHttpClientSuccess204();
            // act
            await dataSource.delete(guardian);
            // assert
            verify(apiClient.delete(request, headers: headers));
          },
        );
        test(
          'should get a valid ValidField for a successful delete',
          () async {
            // arrange
            _setUpMockPostHttpClientSuccess204();
            final expected = ValidField();
            // act
            final received = await dataSource.delete(guardian);
            // assert
            expect(expected, received);
          },
        );
      });
    },
  );
}