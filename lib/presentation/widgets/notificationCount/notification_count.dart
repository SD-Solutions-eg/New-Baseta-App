import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/routers/import_helper.dart';

class OvalNotifyCount extends StatelessWidget {
  const OvalNotifyCount({
    Key? key,
    required this.count,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17.w + (4.0.w * count.toString().length),
      height: 21.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(largeRadius),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 14.w + (4.0.w * count.toString().length),
        height: 18.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(largeRadius),
          color: Theme.of(context).colorScheme.primary,
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
