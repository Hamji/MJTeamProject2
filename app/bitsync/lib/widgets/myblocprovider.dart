import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Create<BlocType extends Bloc<dynamic, dynamic>> = BlocType Function(
    BuildContext context);
typedef WidgetBuilderWithBloc<T extends Bloc<dynamic, dynamic>> = Widget
    Function(BuildContext, T);

class MyBlocProvider<BlocType extends Bloc<dynamic, StateType>, StateType>
    extends StatelessWidget {
  final Create<BlocType> create;
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

  MyBlocProvider.withBuilder({
    Key key,
    @required Create<BlocType> create,
    @required BlocWidgetBuilder<StateType> builder,
    BlocBuilderCondition condition,
    bool lazy,
  }) : this(
          key: key,
          create: create,
          builder: (context) => BlocBuilder(
            key: key,
            bloc: context.bloc<BlocType>(),
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
