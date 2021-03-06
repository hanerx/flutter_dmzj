import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:dcomic/component/EmptyView.dart';
import 'package:dcomic/component/LoadingCube.dart';
import 'package:dcomic/model/download.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DownloadPage();
  }
}

class _DownloadPage extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_) => DownloadModel(),
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              title: Text('下载管理'),
            ),
            body: EasyRefresh(
              firstRefresh: true,
              firstRefreshWidget: LoadingCube(),
              onRefresh: () async {
                await Provider.of<DownloadModel>(context, listen: false)
                    .getComic();
                return true;
              },
              emptyWidget: Provider.of<DownloadModel>(context).length == 0
                  ? EmptyView()
                  : null,
              child: ListView.builder(
                itemBuilder:
                    Provider.of<DownloadModel>(context).buildComicListTile,
                itemCount: Provider.of<DownloadModel>(context).length,
              ),
            ));
      },
    );
  }
}
