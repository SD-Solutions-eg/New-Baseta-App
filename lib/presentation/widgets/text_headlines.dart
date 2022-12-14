import 'package:allin1/presentation/routers/import_helper.dart';

class SectionHeadline extends StatelessWidget {
  final String sectionTitle;
  final bool trailing;
  final VoidCallback? onPressed;
  final String? trailingTitle;
  final TextStyle? style;
  final bool center;
  const SectionHeadline({
    Key? key,
    required this.sectionTitle,
    this.trailing = false,
    this.onPressed,
    this.trailingTitle,
    this.style,
    this.center = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          sectionTitle,
          style: style ??
              Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
        ),
        if (!center) const Spacer(),
        if (trailing && trailingTitle != null)
          TextButton(
            onPressed: onPressed,
            child: Text(
              trailingTitle!,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: const Color(0xff505050),
                  ),
            ),
          )
      ],
    );
  }
}

class MainHeadline extends StatelessWidget {
  const MainHeadline({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6!.copyWith(
            fontWeight: FontWeight.w500,
            color: color,
          ),
    );
  }
}

class SmallHeadline extends StatelessWidget {
  final String title;
  final Color? color;
  const SmallHeadline({
    Key? key,
    required this.title,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: Theme.of(context).textTheme.bodyText1!.copyWith(
              color: color,
            ));
  }
}
