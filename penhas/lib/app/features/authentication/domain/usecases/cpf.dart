import 'package:cpfcnpj/cpfcnpj.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:penhas/app/core/error/failures.dart';

@immutable
class Cpf extends Equatable {
  final Either<Failure, String> value;

  String get rawValue => value.getOrElse(() => null);
  bool get isValid => value.isRight();

  factory Cpf(String input) {
    return Cpf._(_validate(input));
  }

  const Cpf._(this.value);

  @override
  List<Object> get props => [value];

  static Either<Failure, String> _validate(String input) {
    if (!CPF.isValid(input)) {
      return left(CpfInvalidFailure());
    }

    final cleared = input.replaceAll('.', '').replaceAll('-', '');

    return right(cleared);
  }
}
