import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:l_earn/DataLayer/Models/drafts/drafts_model.dart';

class DraftsProvider extends ChangeNotifier {
  DraftsProvider(Box<Drafts> box) : _draftsBox = box;

  final Box<Drafts> _draftsBox;

  // create and update
  void put(Drafts draft) {
    _draftsBox.put(draft.id, draft);

    notifyListeners();
  }

  // const Drafts({
  //   required this.id,
  //   required this.bookName,
  //   required this.chapter,
  //   this.title = 'untitled',
  //   required this.content,                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  //   required this.dateLastUpdated,
  // });

  List<Drafts> find(String keyword) {
    return drafts.where((draft) {
     if (draft.bookName?.toLowerCase()?.contains(keyword.toLowerCase()) == true) return true;
     if (draft.title?.toLowerCase()?.contains(keyword.toLowerCase()) == true) return true;
     try {
      if (draft.chapter == int.parse(keyword.trim())) return true;
     } catch (e) {
      print("Number parsing error");
     }
     try {
      final res = ("chapter ${draft.chapter}" == "chapter ${int.parse(keyword.trim().split(' ')[1])}");
      print("Checking $res");
      if ("chapter ${draft.chapter}" == "chapter ${int.parse(keyword.trim().split(' ')[1])}") return true;
     } catch (e) {
      print("Number parsing error 2");
     }
     return false; 
    }).toList();
  }

  // read drafts
  List<Drafts> get drafts => _draftsBox.values.toList();

  // delete drafts
  void delete(Drafts draft) {
    _draftsBox.delete(draft.id);
  }
}
