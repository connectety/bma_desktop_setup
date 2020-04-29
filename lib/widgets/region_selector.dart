import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/region_model.dart';

class RegionSelector extends StatelessWidget {
  const RegionSelector({Key key}) : super(key: key);

  static String getRegion(BuildContext context) {
    return RegionModel.of(context).region;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RegionModel>(
      builder: (BuildContext context, Widget child, RegionModel model) {
        return DropdownButton<String>(
          value: model.region,
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: model.setRegion,
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem<String>(
              value: 'US',
              child: Text('Default'),
            ),
            DropdownMenuItem<String>(
              value: 'CN',
              child: Text('China'),
            ),
          ],
        );
      },
    );
  }
}
