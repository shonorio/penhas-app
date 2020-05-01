import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:penhas/app/core/error/failures.dart';
import 'package:penhas/app/features/authentication/domain/repositories/i_register_repository.dart';
import 'package:penhas/app/features/authentication/domain/usecases/birthday.dart';
import 'package:penhas/app/features/authentication/domain/usecases/cep.dart';
import 'package:penhas/app/features/authentication/domain/usecases/check_register_field.dart';
import 'package:penhas/app/features/authentication/domain/usecases/cpf.dart';
import 'package:penhas/app/features/authentication/domain/usecases/email_address.dart';
import 'package:penhas/app/features/authentication/domain/usecases/full_name.dart';
import 'package:penhas/app/features/authentication/domain/usecases/genre.dart';
import 'package:penhas/app/features/authentication/domain/usecases/human_race.dart';
import 'package:penhas/app/features/authentication/domain/usecases/nickname.dart';
import 'package:penhas/app/features/authentication/domain/usecases/password.dart';

class MockRegisterRepository extends Mock implements IRegisterRepository {}

void main() {
  CheckRegisterField sut;
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

  setUp(() {
    repository = MockRegisterRepository();
    sut = CheckRegisterField(repository);
    emailAddress = EmailAddress("valid@email.com");
    password = Password('_myStr0ngP@ssw0rd');
    cep = Cep('63024-370');
    cpf = Cpf('23693281343');
    fullname = Fullname('Maria da Penha Maia Fernandes');
    nickName = Nickname('penha');
    birthday = Birthday('1994-01-01');
    race = HumanRace.brown;
    genre = Genre.female;
  });

  void mockRegisterFailure(Failure failure) {
    when(repository.checkField(
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

  void assertFailed(Either<Failure, ValidField> result, Failure failure) {
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

  group('CheckRegisterField', () {
    test('should get error for empty CheckRegisterField()', () async {
      // arrange
      mockRegisterFailure(RequiredParameter());
      // act
      final result = await sut();
      // assert
      expect(result, left(RequiredParameter()));
      verifyZeroInteractions(repository);
    });

    // test('should get error for empty CheckRegisterField()', () async {
    //   // arrange
    //   // act
    //   // assert
    // });
  });
}