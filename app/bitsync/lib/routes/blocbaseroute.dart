import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocBaseRoute<BlocType extends Bloc<dynamic, StateType>,
    StateType> extends MaterialPageRoute {
  BlocBaseRoute({
    @required final BlocType bloc,
    final RouteSettings settings,
    @required final WidgetBuilder builder,
  }) : super(
          builder: (context) => MyBlocProvider<BlocType, StateType>(
            create: (_) => bloc,
            builder: builder,
          ),
          settings: settings,
        );
}
