import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dcomic/generated/l10n.dart';
import 'package:dcomic/model/systemSettingModel.dart';
import 'package:dcomic/view/settings/about_setting_page.dart';
import 'package:dcomic/view/settings/debug_setting_page.dart';
import 'package:dcomic/view/settings/download_setting_page.dart';
import 'package:dcomic/view/settings/ipfs_setting_page.dart';
import 'package:dcomic/view/settings/lab_setting_page.dart';
import 'package:dcomic/view/settings/reader_setting_page.dart';
import 'package:dcomic/view/settings/source_setting_page.dart';
import 'package:dcomic/view/settings/user_setting_page.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SettingPage();
  }
}

class _SettingPage extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> list = [
      ListTile(
        leading: Icon(Icons.book),
        title: Text(S.of(context).SettingPageMainReadingTitle),
        subtitle: Text(S.of(context).SettingPageMainReadingSubtitle),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ReaderSettingPage(),settings: RouteSettings(name: 'read_setting_page')));
        },
      ),
      ListTile(
        leading: Icon(Icons.cloud),
        title: Text(S.of(context).SettingPageMainSourceTitle),
        subtitle: Text(S.of(context).SettingPageMainSourceSubtitle),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SourceSettingPage(),settings: RouteSettings(name: 'source_setting_page')));
        },
      ),
      ListTile(
        leading: Icon(Icons.file_download),
        title: Text(S.of(context).SettingPageMainDownloadTitle),
        subtitle: Text(S.of(context).SettingPageMainDownloadSubtitle),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DownloadSettingPage(),settings: RouteSettings(name: 'download_setting_page')));
        },
      ),
      ListTile(
        leading: Icon(Icons.network_check),
        title: Text(S.of(context).SettingPageIPFSTitle),
        subtitle: Text(S.of(context).SettingPageIPFSSubtitle),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => IPFSSettingPage(),settings: RouteSettings(name: 'ipfs_setting_page')));
        },
      ),
      ListTile(
        leading: Icon(Icons.account_box),
        title: Text(S.of(context).SettingPageMainUserTitle),
        subtitle: Text(S.of(context).SettingPageMainUserSubtitle),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => UserSettingPage(),settings: RouteSettings(name: 'user_setting_page')));
        },
      ),
      ListTile(
        leading: Icon(Icons.developer_mode),
        title: Text(S.of(context).SettingPageMainDebugTitle),
        subtitle: Text(S.of(context).SettingPageMainDebugSubtitle),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DebugSettingPage(),settings: RouteSettings(name: 'debug_setting_page')));
        },
      ),
      ListTile(
        leading: Icon(Icons.apps),
        title: Text(S.of(context).SettingPageMainAboutTitle),
        subtitle: Text(S.of(context).SettingPageMainAboutSubtitle),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AboutSettingPage(),settings: RouteSettings(name: 'about_setting_page')));
        },
      ),
    ];
    if (Provider.of<SystemSettingModel>(context, listen: false).labState) {
      list.add(ListTile(
        leading: Icon(FontAwesome5.flask),
        title: Text(S.of(context).SettingPageMainLabTitle),
        subtitle: Text(S.of(context).SettingPageMainLabSubtitle),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LabSettingPage(),settings: RouteSettings(name: 'lab_setting_page')));
        },
      ));
    }
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Setting),
      ),
      body: ListView(
        children: list,
      ),
    );
  }
}
