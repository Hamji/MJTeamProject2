import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Create<T extends Bloc<dynamic, dynamic>> = T Function(
    BuildContext context);
typedef WidgetBuilderWithBloc<T extends Bloc<dynamic, dynamic>> = Widget
    Function(BuildContext, T);

class MyBlocProvider<T extends Bloc<dynamic, S>, S> extends StatelessWidget {
  final Create<T> create;
  final WidgetBuilder builder;
  final bool lazy;

  MyBlocProvider(
      {Key key, @required this.create, @required this.builder, this.lazy});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: create,
        child: Builder(builder: builder),
        lazy: lazy,
      );

  factory MyBlocProvider.withBuilder({
    Key key,
    @required Create<T> create,
    @required BlocWidgetBuilder<S> builder,
    BlocBuilderCondition condition,
    bool lazy,
  }) =>
      MyBlocProvider(
        key: key,
        create: create,
        builder: (context) => BlocBuilder(
          key: key,
          bloc: context.bloc<T>(),
          condition: condition,
          builder: builder,
        ),
        lazy: lazy,
      );
}

// class MyBlocProvider<T extends Bloc<dynamic, S>, S> extends BlocProvider<T> {
//   MyBlocProvider({
//     Key key,
//     @required Create<T> create,
//     @required WidgetBuilder builder,
//     bool lazy,
//   }) : super(
//           key: key,
//           create: create,
//           child: Builder(
//             key: key,
//             builder: builder,
//           ),
//           lazy: lazy,
//         );

//   MyBlocProvider.withBuilder({
//     Key key,
//     @required Create<T> create,
//     @required BlocWidgetBuilder<S> builder,
//     BlocBuilderCondition<S> condition,
//     bool lazy,
//   }) : this(
//           key: key,
//           create: create,
//           builder: (context) => BlocBuilder<T, S>(
//             bloc: context.bloc<T>(),
//             builder: builder,
//             key: key,
//             condition: condition,
//           ),
//           lazy: lazy,
//         );
// }
