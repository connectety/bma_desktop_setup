import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/region_model.dart';

class RegionSelector extends StatelessWidget {
  const RegionSelector({Key? key}) : super(key: key);

  static String getRegion(BuildContext context) {
    return RegionModel.of(context).region;
  }

  @override
  Widget build(BuildContext context) {
    const Color muteColor = Color(0xB0000000);

    final TextStyle normalStyle = Theme.of(context).textTheme.bodyText2!;
    final TextStyle muteStyle = normalStyle.copyWith(color: muteColor);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.language, color: muteColor, size: muteStyle.fontSize! * 1.3),
        const SizedBox(width: 3),
        Text('Region:', style: muteStyle),
        const SizedBox(width: 5),
        ScopedModelDescendant<RegionModel>(
          builder: (BuildContext context, Widget? child, RegionModel model) {
            return DropdownButton<String>(
              value: model.region,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: model.setRegion,
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem<String>(
                  value: 'US',
                  child: Text('Default', style: normalStyle),
                ),
                DropdownMenuItem<String>(
                  value: 'CN',
                  child: Text('China', style: normalStyle),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
