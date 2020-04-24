import 'package:bitsync/data/data.dart';
import 'package:flutter/material.dart';

@immutable
class MyAvata extends CircleAvatar {
  MyAvata(final User user, {final double minRadius, final double maxRadius})
      : super(
            backgroundImage: NetworkImage(user.photoUrl),
            minRadius: minRadius,
            maxRadius: maxRadius);
}
