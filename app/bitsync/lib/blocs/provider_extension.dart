import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './blocs.dart';

extension BuildContextBloc on BuildContext {
  AuthBloc get authBloc => this.bloc<AuthBloc>();
  RoomBloc get roomBloc => this.bloc<RoomBloc>();
  UserBloc get userBloc => this.bloc<UserBloc>();
  DynamicLinkBloc get dynamicLinkBloc => this.bloc<DynamicLinkBloc>();
  SequenceDesignerBloc get sequenceDesignerBloc =>
      this.bloc<SequenceDesignerBloc>();
  UserRoomsBloc get userRoomsBloc => this.bloc<UserRoomsBloc>();
}
