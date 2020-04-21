import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class RegionModel extends Model {
  String _region = 'US';

  String get region {
    return _region;
  }

  void setRegion(String newRegion) {
    _region = newRegion;
    notifyListeners();
  }

  static RegionModel of(BuildContext context) =>
      ScopedModel.of<RegionModel>(context);
}
