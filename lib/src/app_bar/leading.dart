import 'dart:ui';

import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'app_bar.dart';
import 'state.dart';

class AnimatedLeading extends AnimatedAppBarPart {
  const AnimatedLeading(MorphingState state) : super(state);

  @override
  Widget build(BuildContext context) {
    final canUpdate = Widget.canUpdate(parent.leading, child.leading);

    return Stack(
      children: <Widget>[
        if (parent.leading != null)
          Positioned.fill(
            child: Transform.translate(
              offset: canUpdate
                  ? Offset.zero
                  : Offset(lerpDouble(0, -kToolbarHeight, t), 0),
              child: Opacity(
                opacity: canUpdate ? 1 - t : kHalfInterval.transform(1 - t),
                child: IconTheme.merge(
                  data: parent.appBar.iconTheme,
                  child: parent.leading,
                ),
              ),
            ),
          ),
        if (child.leading != null)
          Positioned.fill(
            child: Transform.translate(
              offset: canUpdate
                  ? Offset.zero
                  : Offset(lerpDouble(kToolbarHeight, 0, t), 0),
              child: Opacity(
                opacity: canUpdate ? t : kHalfInterval.transform(t),
                child: IconTheme.merge(
                  data: child.appBar.iconTheme,
                  child: child.leading,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Widget resolveLeading(BuildContext context, AppBar appBar) {
    if (appBar.leading != null || !appBar.automaticallyImplyLeading) {
      return appBar.leading;
    }

    if (context.scaffoldOrNull?.hasDrawer ?? false) {
      return _DrawerButton();
    } else {
      final parentRoute = context.modalRoute;
      if (parentRoute?.canPop ?? false) {
        return parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog
            ? CloseButton()
            : BackButton();
      }
    }
    return null;
  }
}

class _DrawerButton extends StatelessWidget {
  const _DrawerButton();

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return IconButton(
      icon: Icon(Icons.menu),
      onPressed: context.scaffold.openDrawer,
      tooltip: context.materialLocalizations.openAppDrawerTooltip,
    );
  }
}