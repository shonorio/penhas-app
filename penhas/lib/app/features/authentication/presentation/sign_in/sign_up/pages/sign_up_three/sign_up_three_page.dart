import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:penhas/app/features/authentication/presentation/shared/input_box_style.dart';
import 'package:penhas/app/features/authentication/presentation/shared/page_progress_indicator.dart';
import 'package:penhas/app/features/authentication/presentation/shared/password_text_input.dart';
import 'package:penhas/app/features/authentication/presentation/shared/single_text_input.dart';
import 'package:penhas/app/features/authentication/presentation/shared/snack_bar_handler.dart';
import 'package:penhas/app/shared/design_system/button_shape.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/linear_gradient_design_system.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';
import 'sign_up_three_controller.dart';

class SignUpThreePage extends StatefulWidget {
  final String title;
  const SignUpThreePage({Key? key, this.title = 'SignUpThree'})
      : super(key: key);

  @override
  _SignUpThreePageState createState() => _SignUpThreePageState();
}

class _SignUpThreePageState
    extends ModularState<SignUpThreePage, SignUpThreeController>
    with SnackBarHandler {
  List<ReactionDisposer>? _disposers;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageProgressState _currentState = PageProgressState.initial;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposers ??= [
      _showProgress(),
      _showErrorMessage(),
    ];
  }

  @override
  void dispose() {
    for (var d in _disposers!) {
      d();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: kLinearGradientDesignSystem,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          body: PageProgressIndicator(
            progressState: _currentState,
            child: GestureDetector(
              onTap: () => _handleTap(context),
              onPanDown: (_) => _handleTap(context),
              child: SafeArea(
                  child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _buildHeader(),
                    const SizedBox(height: 18.0),
                    _buildSubHeader(),
                    const SizedBox(height: 22.0),
                    Observer(builder: (_) => _buildEmailField()),
                    const SizedBox(height: 22.0),
                    Observer(builder: (_) => _buildPasswordField()),
                    const SizedBox(height: 22.0),
                    Observer(builder: (_) => _buildConfirmationPasswordField()),
                    const SizedBox(height: 62.0),
                    SizedBox(height: 40.0, child: _buildNextButton()),
                  ],
                ),
              ),),
            ),
          ),
        ),
      ),
    );
  }

  SingleTextInput _buildEmailField() {
    return SingleTextInput(
      keyboardType: TextInputType.emailAddress,
      onChanged: controller.setEmail,
      boxDecoration: WhiteBoxDecorationStyle(
        labelText: 'E-mail',
        errorText: controller.warningEmail,
      ),
    );
  }

  SizedBox _buildSubHeader() {
    return const SizedBox(
      height: 60.0,
      child: Text(
        'Informe um email e defina uma senha segura. A senha precisa ter no mínimo 8 caracteres, com ao menos 1 letra, 1 número e 1 caractere especial.',
        style: kTextStyleRegisterSubHeaderLabelStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Text _buildHeader() {
    return const Text(
      'Crie sua conta',
      style: kTextStyleRegisterHeaderLabelStyle,
      textAlign: TextAlign.center,
    );
  }

  PassordInputField _buildPasswordField() {
    return PassordInputField(
      labelText: 'Senha',
      hintText: 'Digite sua senha',
      errorText: controller.warningPassword,
      onChanged: controller.setPassword,
    );
  }

  PassordInputField _buildConfirmationPasswordField() {
    return PassordInputField(
      labelText: 'Confirmação de senha',
      hintText: 'Digite sua senha novamente',
      errorText: controller.warningConfirmationPassword,
      onChanged: controller.setConfirmationPassword,
    );
  }

  RaisedButton _buildNextButton() {
    return RaisedButton(
      onPressed: () => controller.registerUserPress(),
      elevation: 0,
      color: DesignSystemColors.ligthPurple,
      shape: kButtonShapeFilled,
      child: Text(
        "Cadastrar",
        style: kTextStyleDefaultFilledButtonLabel,
      ),
    );
  }

  _handleTap(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    WidgetsBinding.instance?.focusManager.primaryFocus?.unfocus();
  }

  ReactionDisposer _showErrorMessage() {
    return reaction((_) => controller.errorMessage, (String? message) {
      showSnackBar(scaffoldKey: _scaffoldKey, message: message);
    });
  }

  ReactionDisposer _showProgress() {
    return reaction((_) => controller.currentState, (PageProgressState status) {
      setState(() {
        _currentState = status;
      });
    });
  }
}
