import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:penhas/app/features/quiz/presentation/quiz/quiz_message_widget.dart';
import 'package:penhas/app/features/quiz/presentation/quiz/quiz_user_replay_widget.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'quiz_controller.dart';

class QuizPage extends StatefulWidget {
  final String title;
  const QuizPage({Key key, this.title = "Quiz"}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends ModularState<QuizPage, QuizController> {
  List<ReactionDisposer> _disposers;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _disposers ??= [
      reaction((_) => controller.errorMessage, (String message) {
        if (message.isEmpty) {
          return;
        }

        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: DesignSystemColors.white,
                child: Observer(
                  builder: (_) {
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.only(top: 8.0),
                      itemCount: controller.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return QuizMessageWidget(
                          message: controller.messages[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Observer(
              builder: (_) {
                return QuizUserReplayWidget(
                    message: controller.userReplyMessage,
                    onActionReplay: controller.onActionReply);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposers.forEach((d) => d());
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: DesignSystemColors.ligthPurple,
      title: Center(
        child: SizedBox(
          width: 39.0,
          height: 18.0,
          child: Image(
            image: AssetImage('assets/images/penhas_symbol/penhas_symbol.png'),
          ),
        ),
      ),
    );
  }
}