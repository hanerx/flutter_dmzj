import 'package:dcomic/model/comic_source/sourceProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dcomic/component/search/DeepSearchTab.dart';
import 'package:dcomic/component/search/NovelSearchTab.dart';
import 'package:dcomic/component/search/SearchTab.dart';
import 'package:dcomic/generated/l10n.dart';
import 'package:dcomic/model/systemSettingModel.dart';
import 'package:dcomic/view/comic_detail_page.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  FocusNode _node = FocusNode();
  String keyword = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _onSubmit(context) {
    _node.unfocus();
    setState(() {
      keyword = _controller.text;
    });
    Provider.of<SystemSettingModel>(context, listen: false)
        .analytics
        .logSearch(searchTerm: keyword);
    if (keyword == '宝塔镇河妖') {
      Provider.of<SystemSettingModel>(context, listen: false).backupApi = true;
      Provider.of<SystemSettingModel>(context, listen: false)
          .analytics
          .logEvent(name: 'backup_api', parameters: {'status': true});
    } else if (keyword == '天王盖地虎') {
      Provider.of<SystemSettingModel>(context, listen: false).backupApi = false;
      Provider.of<SystemSettingModel>(context, listen: false)
          .analytics
          .logEvent(name: 'backup_api', parameters: {'status': false});
    }
    var comicId = int.tryParse(keyword);
    if (comicId != null) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('看起来你输入了一个漫画ID'),
                content: Text('是否直接跳转至漫画'),
                actions: [
                  TextButton(
                    child: Text(S.of(context).Cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(S.of(context).Confirm),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ComicDetailPage(
                                id: comicId.toString(),
                                title: '',
                              ),
                          settings: RouteSettings(name: 'comic_detail_page')));
                    },
                  )
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    List tabs = Provider.of<SourceProvider>(context, listen: false)
        .activeSources
        .map<Tab>((e) => Tab(
              text: e.type.title,
            ))
        .toList();
    List views = Provider.of<SourceProvider>(context, listen: false)
        .activeSources
        .map<Widget>((e) => SearchTab(
              key: UniqueKey(),
              keyword: keyword,
              model: e,
            ))
        .toList();
    if (Provider.of<SystemSettingModel>(context, listen: false).novel) {
      tabs.add(Tab(
        text: '轻小说搜索',
      ));
      views.add(NovelSearchTab(
        keyword: keyword,
        key: UniqueKey(),
      ));
    }
    if (Provider.of<SystemSettingModel>(context, listen: false).deepSearch) {
      tabs.add(Tab(
        text: '隐藏搜索',
      ));
      views.add(DeepSearchTab(
        key: UniqueKey(),
        keyword: keyword,
      ));
    }

    // TODO: implement build
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            enableInteractiveSelection: true,
            focusNode: _node,
            autofocus: true,
            controller: _controller,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '输入关键词',
              hintStyle: TextStyle(color: Colors.white),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (val) {
              _onSubmit(context);
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                _onSubmit(context);
              },
            )
          ],
        ),
        body: TabBarView(
          children: views,
        ),
      ),
    );
  }
}
