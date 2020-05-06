import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:penhas/app/features/authentication/domain/repositories/i_reset_password_repository.dart';
import 'package:penhas/app/features/authentication/domain/usecases/email_address.dart';
import 'package:penhas/app/features/authentication/presentation/sign_up/user_register_form_field_model.dart';

part 'reset_password_controller.g.dart';

const String WARNING_INVALID_EMAIL = 'Endereço de email inválido';
const String ERROR_SERVER_FAILURE =
    "O servidor está com problema neste momento, tente novamente.";
const String ERROR_INTERNET_CONNECTION_FAILURE =
    "O servidor está inacessível, o PenhaS está com acesso à Internet?";

class ResetPasswordController extends _ResetPasswordControllerBase
    with _$ResetPasswordController {
  ResetPasswordController(IResetPasswordRepository repository)
      : super(repository);
}

abstract class _ResetPasswordControllerBase with Store {
  final IResetPasswordRepository repository;
  UserRegisterFormFieldModel _userRegisterModel = UserRegisterFormFieldModel();

  _ResetPasswordControllerBase(this.repository);

  @observable
  String errorMessage = '';

  @observable
  String warningEmail = '';

  @action
  void setEmail(String address) {
    _userRegisterModel.emailAddress = EmailAddress(address);

    warningEmail = _userRegisterModel.emailAddress.value.fold(
      (failure) => address.length == 0 ? '' : WARNING_INVALID_EMAIL,
      (_) => '',
    );
  }

  @action
  void nextStepPressed() {
    _setErrorMessage('');
    if (!_isValidToProceed()) {
      return;
    }

    _forwardToLogged();
  }

  void _setErrorMessage(String s) {}

  bool _isValidToProceed() {
    return true;
  }

  void _forwardToLogged() {
    Modular.to.pushNamed('/authentication/reset_password/step2');
  }
}
