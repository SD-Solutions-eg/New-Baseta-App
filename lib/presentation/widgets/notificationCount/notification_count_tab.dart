import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';

class OvalNotifyCountTablet extends StatelessWidget {
  const OvalNotifyCountTablet({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17 + (4.0 * count.toString().length),
      height: 21,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(largeRadiusTab),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 20 + (4.0 * count.toString().length),
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(largeRadiusTab),
          color: Theme.of(context).colorScheme.secondary,
        ),
        alignment: Alignment.center,
        child: Center(
          child: Text(
            count.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: Colors.white,
                  fontFamily: 'Roboto',
                ),
          ),
        ),
      ),
    );
  }
}
