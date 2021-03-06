import 'package:dcomic/model/baseModel.dart';
import 'package:dcomic/model/comic_source/baseSourceModel.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class SubjectListModel extends BaseModel {
  final BaseSourceModel model;
  int page = 0;
  List<SubjectItem> _data = [];
  String error;

  SubjectListModel(this.model);

  Future<void> getSubjectList(int page) async {
    try {
      _data += await this.model.homePageHandler.getSubjectList(page);
      error = null;
      notifyListeners();
    } on UnimplementedError {
      error = "该源不支持本功能";
      notifyListeners();
    } on LoginRequiredError {
      error = '专题页需要登录，请先登录';
      notifyListeners();
    } catch (e, s) {
      FirebaseCrashlytics.instance
          .recordError(e, s, reason: 'subjectListLoadingFail');
      error = '未知错误：$e';
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _data.clear();
    page = 0;
    await getSubjectList(page);
    notifyListeners();
  }

  Future<void> next() async {
    page++;
    await getSubjectList(page);
    notifyListeners();
  }

  List<SubjectItem> get data => _data;

  int get length => _data.length;
}

class SubjectItem {
  final String cover;
  final String title;
  final String subtitle;
  final String subjectId;
  final BaseSourceModel model;

  SubjectItem(
      {this.cover, this.title, this.subtitle, this.subjectId, this.model});
}
