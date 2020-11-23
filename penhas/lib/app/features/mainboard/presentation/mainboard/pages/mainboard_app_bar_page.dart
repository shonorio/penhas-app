import 'package:flutter/material.dart';
import 'package:penhas/app/features/mainboard/domain/states/mainboard_state.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/logo.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

import 'mainboard_notification_page.dart';

class MainBoardAppBarPage extends StatelessWidget
    implements PreferredSizeWidget {
  final int counter;
  final MainboardState currentPage;

  const MainBoardAppBarPage({
    Key key,
    @required this.counter,
    @required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return currentPage.maybeWhen(
      helpCenter: () => _helpCenterAppBar(),
      orElse: () => _defaultAppBar(),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;

  Widget _helpCenterAppBar() {
    return AppBar(
      elevation: 0.0,
      centerTitle: false,
      titleSpacing: 0,
      backgroundColor: DesignSystemColors.helpCenterNavigationBar,
      title: Text(
        'Precisa de ajuda?',
        style: kTextStyleHelpCenterTitle,
      ),
    );
  }

  Widget _defaultAppBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: DesignSystemColors.ligthPurple,
      elevation: 0.0,
      centerTitle: false,
      title: Icon(
        DesignSystemLogo.penhasLogo,
        color: Colors.white,
        size: 30,
      ),
      actions: <Widget>[MainboardNotificationPage(counter: counter)],
    );
  }
}