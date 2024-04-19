import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:l_earn/DataLayer/Models/drafts_model.dart';

class DraftsProvider extends ChangeNotifier {
  DraftsProvider(Box<Drafts> box) : _draftsBox = box;

  final Box<Drafts> _draftsBox;

  // create and update
  void put(Drafts draft) {
    _draftsBox.put(draft.id, draft);

    notifyListeners();
  }

  // read drafts
  void getAll() {
    
  }
}
