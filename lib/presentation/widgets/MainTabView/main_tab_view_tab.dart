import 'package:allin1/core/constants/dimensions.dart';
import 'package:flutter/material.dart';

class MainTabViewTablet extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool leading;
  final bool showTrailing;
  final Widget? trailing;
  final Widget? topChild;
  final double? topMargin;
  final bool removeSpacer;

  const MainTabViewTablet({
    Key? key,
    this.title,
    required this.child,
    this.leading = false,
    this.showTrailing = false,
    this.trailing,
    this.topChild,
    this.topMargin,
    this.removeSpacer = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 26,
          ),
        ),
        titleSpacing: 0,
        centerTitle: false,
        title: title != null
            ? Text(
                title!,
                style: Theme.of(context).textTheme.headline6,
              )
            : null,
        actions: [
          if (trailing != null) trailing!,
          const SizedBox(width: hMediumPaddingTab),
        ],
      ),
      body: child,
    );
  }
}
