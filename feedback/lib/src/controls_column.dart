// ignore_for_file: public_member_api_docs

import 'package:feedback/src/feedback_mode.dart';
import 'package:feedback/src/l18n/translation.dart';
import 'package:feedback/src/theme/feedback_theme.dart';
import 'package:flutter/material.dart';

/// This is the Widget on the right side of the app when the feedback view
/// is active.
class ControlsColumn extends StatelessWidget {
  /// Creates a [ControlsColumn].
  ControlsColumn({
    super.key,
    required this.mode,
    required this.activeColor,
    required this.onColorChanged,
    required this.onUndo,
    required this.onControlModeChanged,
    required this.onCloseFeedback,
    required this.onClearDrawing,
    required this.colors,
  })  : assert(
          colors.isNotEmpty,
          'There must be at least one color to draw in colors',
        ),
        assert(colors.contains(activeColor), 'colors must contain activeColor');

  final ValueChanged<Color> onColorChanged;
  final VoidCallback onUndo;
  final ValueChanged<FeedbackMode> onControlModeChanged;
  final VoidCallback onCloseFeedback;
  final VoidCallback onClearDrawing;
  final List<Color> colors;
  final Color activeColor;
  final FeedbackMode mode;

  @override
  Widget build(BuildContext context) {
    final isNavigatingActive = FeedbackMode.navigate == mode;
    final r = FeedbackTheme.of(context).scale;
    return Container(
      decoration: BoxDecoration(
        color: FeedbackTheme.of(context).feedbackSheetColor,
        borderRadius: BorderRadius.all(Radius.circular(24 * r)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: <Widget>[
          IconButton(
            key: const ValueKey<String>('close_controls_column'),
            icon: const Icon(Icons.close),
            onPressed: onCloseFeedback,
            iconSize: 24 * r,
          ),
          _ColumnDivider(),
          RotatedBox(
            quarterTurns: 1,
            child: MaterialButton(
              padding: EdgeInsets.zero,
              key: const ValueKey<String>('navigate_button'),
              onPressed: isNavigatingActive
                  ? null
                  : () => onControlModeChanged(FeedbackMode.navigate),
              disabledTextColor:
                  FeedbackTheme.of(context).activeFeedbackModeColor,
              child: Text(
                FeedbackLocalizations.of(context).navigate,
                style: FeedbackTheme.of(context).navigateButtonStyle,
              ),
            ),
          ),
          _ColumnDivider(),
          // RotatedBox(
          //   quarterTurns: 1,
          //   child: MaterialButton(
          //     key: const ValueKey<String>('draw_button'),
          //     minWidth: 20,
          //     onPressed: isNavigatingActive
          //         ? () => onControlModeChanged(FeedbackMode.draw)
          //         : null,
          //     disabledTextColor:
          //         FeedbackTheme.of(context).activeFeedbackModeColor,
          //     child: Text(FeedbackLocalizations.of(context).draw),
          //   ),
          // ),
          _ColorSelectionIconButton(
            key: const ValueKey<String>('draw_button'),
            color: isNavigatingActive ? Theme.of(context).disabledColor : activeColor,
            onPressed: isNavigatingActive ? (_) => onControlModeChanged(FeedbackMode.draw) : (color) {
              onColorChanged(colors.length == 1 ? color : colors[(colors.indexOf(color) + 1) % colors.length]);
            },
            isActive: !isNavigatingActive,
          ),
          IconButton(
            key: const ValueKey<String>('undo_button'),
            icon: const Icon(Icons.undo),
            onPressed: isNavigatingActive ? null : onUndo,
            iconSize: 24 * r,
          ),
          IconButton(
            key: const ValueKey<String>('clear_button'),
            icon: const Icon(Icons.delete),
            onPressed: isNavigatingActive ? null : onClearDrawing,
            iconSize: 24 * r,
          ),
        ],
      ),
    );
  }
}

class _ColorSelectionIconButton extends StatelessWidget {
  const _ColorSelectionIconButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.isActive,
  });

  final Color color;
  final ValueChanged<Color>? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final r = FeedbackTheme.of(context).scale;
    return IconButton(
      icon: Icon(isActive ? Icons.draw : Icons.draw_outlined),
      color: color,
      onPressed: onPressed == null ? null : () => onPressed!(color),
      iconSize: 24 * r,
    );
  }
}

class _ColumnDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
