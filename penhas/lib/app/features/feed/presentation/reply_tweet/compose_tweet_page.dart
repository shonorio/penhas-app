import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobx/mobx.dart';
import 'package:penhas/app/features/authentication/presentation/shared/page_progress_indicator.dart';
import 'package:penhas/app/features/authentication/presentation/shared/snack_bar_handler.dart';
import 'package:penhas/app/features/feed/presentation/compose_tweet/compose_tweet_controller.dart';
import 'package:penhas/app/shared/design_system/button_shape.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

class ComposeTweetPage extends StatefulWidget {
  final String title;
  const ComposeTweetPage({Key key, this.title = "ComposeTweet"})
      : super(key: key);

  @override
  _ComposeTweetPageState createState() => _ComposeTweetPageState();
}

class _ComposeTweetPageState
    extends ModularState<ComposeTweetPage, ComposeTweetController>
    with SnackBarHandler {
  final String inputHint =
      'Gostaria de compartilhar alguma experiência ou história sua?';
  final String anonymousHint =
      'Sua publicação é anônima. As usuárias do app podem comentar sua publicação, mas só você pode iniciar uma conversa com elas.';
  List<ReactionDisposer> _disposers;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  PageProgressState _currentState = PageProgressState.initial;

  TextStyle get _kTextStyleNewTweetAnonymousHint => TextStyle(
      fontFamily: 'Lato',
      fontSize: 12.0,
      letterSpacing: 0.38,
      color: DesignSystemColors.warnGrey,
      fontWeight: FontWeight.normal);

  TextStyle get _kTextStyleNewTweetAnonymous => TextStyle(
      fontFamily: 'Lato',
      fontSize: 14.0,
      letterSpacing: 0.44,
      color: DesignSystemColors.darkIndigoThree,
      fontWeight: FontWeight.bold);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposers ??= [
      _showErrorMessage(),
      _showProgress(),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _disposers.forEach((d) => d());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SizedBox.expand(
        child: Container(
          color: Color.fromRGBO(248, 248, 248, 1.0),
          child: PageProgressIndicator(
            progressState: _currentState,
            child: GestureDetector(
              onTap: () => _handleTap(context),
              onPanDown: (_) => _handleTap(context),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: 24.0,
                          left: 2.0,
                          right: 2.0,
                        ),
                        child: Text(
                          'Publique algo para outras mulheres que usam o Penhas.',
                          style: kTextStyleDrawerListItem,
                        ),
                      ),
                      SizedBox(
                        height: 160,
                        child: TextField(
                          controller: controller.editingController,
                          maxLength: 500,
                          maxLines: 15,
                          maxLengthEnforced: true,
                          onChanged: controller.setTweetContent,
                          decoration: InputDecoration(
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                  color: DesignSystemColors.ligthPurple),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              borderSide: BorderSide(
                                  color: DesignSystemColors.ligthPurple,
                                  width: 2.0),
                            ),
                            alignLabelWithHint: true,
                            hintText: inputHint,
                          ),
                          toolbarOptions: ToolbarOptions(
                            copy: true,
                            cut: true,
                            selectAll: true,
                            paste: true,
                          ),
                        ),
                      ),
                      Observer(builder: (context) {
                        return Visibility(
                            visible: controller.isAnonymousMode,
                            replacement: SizedBox(height: 20.0),
                            child: _buildAnonymousWarning());
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: SizedBox(
                          height: 40,
                          width: 220,
                          child: Observer(builder: (_) {
                            return RaisedButton(
                              onPressed: controller.isEnableCreateButton
                                  ? () => controller.createTweetPressed()
                                  : null,
                              elevation: 0.0,
                              shape: kButtonShapeFilled,
                              color: DesignSystemColors.ligthPurple,
                              child: Text(
                                'Publicar',
                                style: kTextStyleDefaultFilledButtonLabel,
                              ),
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildAnonymousWarning() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Container(
          decoration: _buildInputTextBoxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                Text(
                  anonymousHint,
                  style: _kTextStyleNewTweetAnonymousHint,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/images/svg/drawer/user_profile.svg",
                        color: DesignSystemColors.darkIndigoThree,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Anônima',
                          style: _kTextStyleNewTweetAnonymous,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  BoxDecoration _buildInputTextBoxDecoration() {
    return BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(8.0));
  }

  _handleTap(BuildContext context) {
    if (MediaQuery.of(context).viewInsets.bottom > 0)
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }

  ReactionDisposer _showErrorMessage() {
    return reaction((_) => controller.errorMessage, (String message) {
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
