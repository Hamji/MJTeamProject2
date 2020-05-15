import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/widgets/myblocprovider.dart';
import 'package:flutter/material.dart';

class BeatDesigner extends MyBlocProvider<BeatDesignerBloc, BeatDesignerState> {
  BeatDesigner()
      : super.withBuilder(
          create: (context) => BeatDesignerBloc(),
          builder: (context, state) {},
        );
}
