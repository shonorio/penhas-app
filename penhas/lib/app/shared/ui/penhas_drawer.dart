import 'package:flutter/material.dart';
import 'package:penhas/app/shared/design_system/colors.dart';
import 'package:penhas/app/shared/design_system/text_styles.dart';

class PenhasDrawer extends StatelessWidget {
  final String userName = 'Luíza';
  final Widget userAvatar = Icon(Icons.person_outline, color: Colors.black);
  final Color drawerGrey = Color.fromRGBO(239, 239, 239, 1.0);
  final double listHeight = 80;

  final void Function() _onLogout;

  final _kLogoutLabelStyle = TextStyle(
      color: DesignSystemColors.ligthPurple,
      fontFamily: 'Lato',
      fontSize: 16.0,
      letterSpacing: 0.5,
      fontWeight: FontWeight.bold);

  PenhasDrawer({
    Key key,
    @required void Function() onLogout,
  })  : this._onLogout = onLogout,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          constraints: BoxConstraints.expand(
              width: MediaQuery.of(context).size.width - 60),
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _builderHeader(),
              _buildSwitch(),
              _buildItemList(
                  title: 'Informações pessoais',
                  icon: Icon(Icons.person_pin, size: 26)),
              _buildItemList(
                  title: 'Preferência da conta',
                  icon: Icon(Icons.settings_input_svideo, size: 26)),
              _buildItemList(
                  title: 'Exclusão da conta',
                  icon: Icon(Icons.delete_outline, size: 26)),
              Container(
                constraints: BoxConstraints(minHeight: 126.0),
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                    onPressed: () => _onLogout(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.power_settings_new,
                          size: 40,
                          color: DesignSystemColors.ligthPurple,
                        ),
                        SizedBox(width: 12),
                        Text('Sair', style: _kLogoutLabelStyle),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildItemList({@required String title, Widget icon}) {
    return Container(
      padding: EdgeInsets.only(left: 16.0),
      height: listHeight,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          border: Border(
              bottom: BorderSide(color: DesignSystemColors.pinkishGrey))),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(width: 9.0),
          Text(
            title,
            style: kTextStyleDrawerListItem,
          ),
        ],
      ),
    );
  }

  Container _buildSwitch() {
    return Container(
      padding: EdgeInsets.only(left: 16.0),
      height: listHeight,
      color: drawerGrey,
      child: Center(
        child: SwitchListTile(
          contentPadding: EdgeInsets.only(left: 0.0, right: 16.0),
          value: true,
          onChanged: (_) {},
          title: Text(
            'Estou em situação de violência',
            style: kTextStyleDrawerListItem,
          ),
        ),
      ),
    );
  }

  Container _builderHeader() {
    return Container(
        padding: EdgeInsets.only(left: 16.0),
        height: 100,
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: drawerGrey,
              radius: 25,
              child: userAvatar,
            ),
            SizedBox(width: 9.0),
            Text(
              userName,
              style: kTextStyleDrawerUsername,
            ),
            SizedBox(width: 9.0),
            Container(
              padding: EdgeInsets.fromLTRB(6.0, 4.0, 6.0, 4.0),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(234, 234, 234, 1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6.0),
                    bottomLeft: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0),
                  )),
              child: Text('Você', style: kTextStyleDrawerUserNameTag),
            ),
          ],
        ));
  }
}
