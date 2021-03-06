import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dcomic/component/SearchDialog.dart';
import 'package:dcomic/database/sourceDatabaseProvider.dart';
import 'package:dcomic/model/baseModel.dart';
import 'package:dcomic/model/comic_source/baseSourceModel.dart';

class SourceSearchProvider extends BaseModel {
  final BaseSourceModel model;
  final String comicId;
  String _keyword;
  List<SearchResult> _list = [];

  SourceSearchProvider(this.model, this._keyword, this.comicId);

  Future<void> refresh() async {
    _list = await model.search(keyword);
    print(_list);
    notifyListeners();
  }

  Widget buildListTile(context, index) {
    if (index >= 0 && index < length) {
      var result=_list[index];
      return SearchListTile(result.cover, result.title, result.tag, result.comicId, result.author);
    }
    return null;
  }

  Future<void> boundComicId(String boundId)async{
    await SourceDatabaseProvider.boundComic(model.type.name, comicId, boundId);
  }

  int get length => _list.length;

  String get keyword => _keyword;

  set keyword(String value) {
    _keyword = value;
    notifyListeners();
  }
}
