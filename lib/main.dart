import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'scoped_models/region_model.dart';
import 'screens/method_selection_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<RegionModel>(
      model: RegionModel(),
      child: const MaterialApp(
        title: 'setup4bmatotp',
        home: MethodSelectionPage(),
      ),
    );
  }
}
