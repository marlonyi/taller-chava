import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import '../../theme/palette.dart';

charts.Color cColor(int i) =>
    charts.ColorUtil.fromDartColor(palette[i % palette.length]);
