import 'package:bitsync/blocs/blocs.dart';
import 'package:bitsync/data/data.dart';
import 'package:bitsync/pages/loadingpage.dart';
import 'package:bitsync/widgets/myblocprovider.dart';
import 'package:bitsync/widgets/patternwidgets.dart';
import 'package:bitsync/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SequenceDesignPage
    extends MyBlocProvider<SequenceDesignerBloc, SequenceDesignerState> {
  SequenceDesignPage({Key key, @required Sequence sequence})
      : super.withBuilder(
          key: key,
          create: (context) => SequenceDesignerBloc(),
          builder: (context, state) {
            if (state is SequenceDesignerStateInitial)
              context.sequenceDesignerBloc
                  .add(SequenceDesignerEventInitialize(sequence));
            else if (state is SequenceDesignerStateLoaded)
              return MyScaffold(
                appBar: AppBar(
                  title: const Text("Edit Sequence"),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.save),
                      onPressed: () => Navigator.pop(context, state.sequence),
                      tooltip: "Save",
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => context.sequenceDesignerBloc
                          .add(SequenceDesignerEventInitialize(sequence)),
                      tooltip: "Discard",
                    ),
                  ],
                ),
                body: Row(
                  children: [
                    Flexible(
                      child: PatternWidget(state.sequence, state),
                      flex: 1,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: PatternEditor(state),
                      flex: 1,
                    ),
                  ],
                ),
              );
            return LoadingPage();
          },
        );
}
