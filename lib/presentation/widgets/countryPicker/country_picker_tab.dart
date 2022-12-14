import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class MyCountryPickerTablet extends StatelessWidget {
  const MyCountryPickerTablet({
    required this.initialSelection,
    required this.onSelected,
  });

  final String? initialSelection;
  final void Function(CountryCode countryCode)? onSelected;

  @override
  Widget build(BuildContext context) {
    return CountryCodePicker(
      dialogTextStyle: Theme.of(context).textTheme.subtitle1,
      onChanged: onSelected,
      initialSelection: initialSelection != null && initialSelection!.isNotEmpty
          ? initialSelection
          : 'EG',
      favorite: const ['+20', 'EG'],
      alignLeft: true,
      showFlag: false,
      barrierColor: Theme.of(context).colorScheme.secondary.withOpacity(0.05),
      backgroundColor: Theme.of(context).backgroundColor.withOpacity(0.5),
      dialogBackgroundColor:
          Theme.of(context).backgroundColor.withOpacity(0.98),
      dialogSize: Size(MediaQuery.of(context).size.width - 50, 500),
      padding: const EdgeInsets.symmetric(vertical: 1),
      textStyle: Theme.of(context).textTheme.headline4,
    );
  }
}
