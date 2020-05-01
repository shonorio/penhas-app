import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/features/authentication/domain/entities/session_entity.dart';
import 'package:penhas/app/features/authentication/domain/repositories/i_register_repository.dart';
import 'package:penhas/app/features/authentication/domain/usecases/birthday.dart';
import 'package:penhas/app/features/authentication/domain/usecases/cep.dart';
import 'package:penhas/app/features/authentication/domain/usecases/cpf.dart';
import 'package:penhas/app/features/authentication/domain/usecases/email_address.dart';
import 'package:penhas/app/features/authentication/domain/usecases/full_name.dart';
import 'package:penhas/app/features/authentication/domain/usecases/genre.dart';
import 'package:penhas/app/features/authentication/domain/usecases/human_race.dart';
import 'package:penhas/app/features/authentication/domain/usecases/nickname.dart';
import 'package:penhas/app/features/authentication/domain/usecases/password.dart';
import 'package:penhas/app/features/authentication/domain/usecases/register_user.dart';

class MockRegisterRepository extends Mock implements IRegisterRepository {}

void main() {
  RegisterUser useCase;
  MockRegisterRepository repository;

  Cep cep;
  Cpf cpf;
  EmailAddress emailAddress;
  Password password;
  Fullname fullname;
  Nickname nickName;
  Birthday birthday;
  HumanRace race;
  Genre genre;
  SessionEntity successSession;

  group('SignUp', () {
    setUp(() {
      repository = MockRegisterRepository();
      useCase = RegisterUser(repository);
      emailAddress = EmailAddress("valid@email.com");
      password = Password('_myStr0ngP@ssw0rd');
      cep = Cep('63024-370');
      cpf = Cpf('23693281343');
      fullname = Fullname('Maria da Penha Maia Fernandes');
      nickName = Nickname('penha');
      birthday = Birthday('1994-01-01');
      race = HumanRace.brown;
      genre = Genre.female;
      successSession = SessionEntity(
        fakePassword: false,
        sessionToken: 'my_strong_session_token',
      );
    });
    group('with valid parameters', () {
      Future<Either<Failure, SessionEntity>> runRegister() async {
        return useCase(
            emailAddress: emailAddress,
            password: password,
            cep: cep,
            cpf: cpf,
            fullname: fullname,
            nickName: nickName,
            birthday: birthday,
            race: race,
            genre: genre);
      }

      test('should get success session', () async {
        // arrange
        when(repository.signup(
          emailAddress: anyNamed('emailAddress'),
          password: anyNamed('password'),
          cep: anyNamed('cep'),
          cpf: anyNamed('cpf'),
          fullname: anyNamed('fullname'),
          nickName: anyNamed('nickName'),
          birthday: anyNamed('birthday'),
          genre: anyNamed('genre'),
          race: anyNamed('race'),
        )).thenAnswer((_) async => right(successSession));
        // act
        final result = await runRegister();
        // assert
        expect(result, right(successSession));
        verify(repository.signup(
          emailAddress: emailAddress,
          password: password,
          cep: cep,
          cpf: cpf,
          fullname: fullname,
          nickName: nickName,
          birthday: birthday,
          genre: genre,
          race: race,
        ));
        verifyNoMoreInteractions(repository);
      });

      void mockRegisterFailure(Failure failure) {
        when(repository.signup(
          emailAddress: anyNamed('emailAddress'),
          password: anyNamed('password'),
          cep: anyNamed('cep'),
          cpf: anyNamed('cpf'),
          fullname: anyNamed('fullname'),
          nickName: anyNamed('nickName'),
          birthday: anyNamed('birthday'),
          genre: anyNamed('genre'),
          race: anyNamed('race'),
        )).thenAnswer((_) async => left(failure));
      }

      void assertFailed(
          Either<Failure, SessionEntity> result, Failure failure) {
        expect(result, left(failure));
        verify(repository.signup(
          emailAddress: emailAddress,
          password: password,
          cep: cep,
          cpf: cpf,
          fullname: fullname,
          nickName: nickName,
          birthday: birthday,
          genre: genre,
          race: race,
        ));
        verifyNoMoreInteractions(repository);
      }

      test('could get error for form field validation from server', () async {
        // arrange
        mockRegisterFailure(ServerSideFormFieldValidationFailure());
        // act
        final result = await runRegister();
        // assert
        assertFailed(result, ServerSideFormFieldValidationFailure());
      });
    });
  });
}