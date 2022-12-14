import 'package:allin1/core/constants/dimensions.dart';
import 'package:flutter/material.dart';

class MainTabView extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool leading;
  final bool showTrailing;
  final Widget? trailing;
  final Widget? topChild;
  final double? topMargin;
  final bool removeSpacer;

  const MainTabView({
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
        // leading: leading
        //     ? InkWell(
        //         onTap: () => Navigator.pop(context),
        //         child: Icon(
        //           Icons.arrow_back_rounded,
        //           size: 26.w,
        //         ),
        //       )
        //     : null,
        // automaticallyImplyLeading: leading,
        // leadingWidth: !leading ? 0 : null,
        titleSpacing: hMediumPadding,
        centerTitle: false,
        title: title != null
            ? Text(
                title!,
                style: Theme.of(context).textTheme.headline6,
              )
            : null,
        actions: [
          if (trailing != null) trailing!,
          SizedBox(width: hMediumPadding),
        ],
      ),
      body: child,
    );
  }
}
