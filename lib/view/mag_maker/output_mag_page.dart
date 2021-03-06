import 'package:dcomic/component/LoadingCube.dart';
import 'package:dcomic/component/comic/ComicListTile.dart';
import 'package:dcomic/model/mag_model/OutputMangaModel.dart';
import 'package:dcomic/model/mag_model/baseMangaModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

class OutputMangaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OutputMangaPage();
  }
}

class _OutputMangaPage extends State<OutputMangaPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider(
      create: (_) => OutputMangaModel(),
      builder: (context, child) => Scaffold(
          appBar: AppBar(
            title: Text('导出漫画'),
          ),
          body: EasyRefresh(
            onRefresh: () async {
              await Provider.of<OutputMangaModel>(context, listen: false)
                  .init();
            },
            firstRefreshWidget: LoadingCube(),
            firstRefresh: true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: Provider.of<OutputMangaModel>(context).data.length,
                itemBuilder: (context, index) {
                  var item = Provider.of<OutputMangaModel>(context).data[index];
                  return ComicListTile(
                    cover: item.cover,
                    title: item.title,
                    authors: item.authors
                        .map<String>((e) => e.name)
                        .toList()
                        .join('/'),
                    tag:
                        item.tags.map<String>((e) => e.name).toList().join('/'),
                    date: item.lastUpdateTimeStamp,
                    onPressed: () async {
                      var outputPath =
                          await FilePicker.platform.getDirectoryPath();
                      if (outputPath != null) {
                        try {
                          await BaseMangaModel()
                              .encodeFromDirectory(item.basePath, outputPath);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("导出成功")));
                        } catch (e) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("输出错误：$e")));
                        }
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("请选择有效目录")));
                      }
                    },
                    pageType: item.coverPageType,
                  );
                }),
          )),
    );
  }
}
