import 'package:allin1/core/languages/language_ar.dart';
import 'package:allin1/core/languages/languages.dart';
import 'package:allin1/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconly/iconly.dart';

class ProductRatingBar extends StatelessWidget {
  const ProductRatingBar({
    Key? key,
    this.readOnly = true,
    this.onRating,
    this.size,
    required this.initialRating,
  }) : super(key: key);

  final bool readOnly;
  final void Function(double rating)? onRating;
  final double initialRating;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final isArabic = Languages.of(context) is LanguageAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RatingBar(
      itemSize: size ?? (readOnly ? 22 : 30),
      initialRating: initialRating,
      allowHalfRating: readOnly,
      ignoreGestures: readOnly,
      glow: false,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      ratingWidget: RatingWidget(
        full: Icon(
          IconlyBold.star,
          color: Colors.amber.shade900,
        ),
        half: Icon(
          Icons.star_half_rounded,
          color: Colors.amber.shade900,
        ),
        empty: Icon(
          IconlyLight.star,
          color: isDark
              ? darkTextColor.withOpacity(0.6)
              : Theme.of(context).colorScheme.primary.withOpacity(0.25),
        ),
      ),
      onRatingUpdate: onRating ?? (_) {},
    );
  }
}
