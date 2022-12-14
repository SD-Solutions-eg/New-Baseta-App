import 'package:allin1/core/constants/dimensions.dart';
import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label_tab.dart';
import 'package:flutter/material.dart';

class DropdownFormFieldWithLabelTablet extends StatelessWidget {
  final String selectedItem;
  final String label;
  final OutlineInputBorder outlineInputBorder;
  final List<String> list;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;

  const DropdownFormFieldWithLabelTablet({
    Key? key,
    required this.selectedItem,
    required this.outlineInputBorder,
    required this.list,
    required this.label,
    this.onChanged,
    this.onSaved,
    this.validator,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: vVerySmallPaddingTab),
        DropdownButtonFormField<String>(
          dropdownColor: Theme.of(context).backgroundColor.withOpacity(0.9),
          items: list.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          focusNode: focusNode,
          onChanged: onChanged,
          onSaved: onSaved,
          validator: validator,
          value: selectedItem,
          decoration: UnderLineTextFieldWithLabelTablet.customInputDecoration(
            context: context,
            inputBorder: outlineInputBorder,
          ),
        ),
      ],
    );
  }
}
