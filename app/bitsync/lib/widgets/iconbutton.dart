import 'package:flutter/material.dart';

class IconButtonWithCaption extends FlatButton {
  IconButtonWithCaption({
    Key key,
    @required VoidCallback onPressed,
    ValueChanged<bool> onHighlightChanged,
    ButtonTextTheme textTheme,
    Color textColor,
    Color disabledTextColor,
    Color color,
    Color disabledColor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    Brightness colorBrightness,
    EdgeInsetsGeometry padding,
    VisualDensity visualDensity,
    ShapeBorder shape,
    Clip clipBehavior = Clip.none,
    FocusNode focusNode,
    bool autofocus = false,
    MaterialTapTargetSize materialTapTargetSize,
    @required Widget icon,
    String caption,
    Widget label,
    double gapHeight = 10.0,
  }) : super(
          key: key,
          onPressed: onPressed,
          onHighlightChanged: onHighlightChanged,
          textTheme: textTheme,
          textColor: textColor,
          disabledTextColor: disabledColor,
          color: color,
          disabledColor: disabledColor,
          focusColor: focusColor,
          hoverColor: hoverColor,
          highlightColor: highlightColor,
          splashColor: splashColor,
          colorBrightness: colorBrightness,
          padding: padding,
          visualDensity: visualDensity,
          shape: shape,
          clipBehavior: clipBehavior,
          focusNode: focusNode,
          autofocus: autofocus,
          materialTapTargetSize: materialTapTargetSize,
          child: null == label
              ? null == caption
                  ? icon
                  : Column(
                      children: <Widget>[
                        icon,
                        SizedBox(height: gapHeight),
                        Text(caption),
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    )
              : Column(
                  children: <Widget>[
                    icon,
                    SizedBox(height: gapHeight),
                    label,
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                ),
        );
}
