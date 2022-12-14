import 'package:allin1/presentation/widgets/textFieldWithLabel/text_field_with_label_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class MyFormBuilderFiledTablet extends StatelessWidget {
  const MyFormBuilderFiledTablet({
    Key? key,
    required this.id,
    this.title,
    this.isRequired = false,
    this.hintText,
    this.validator,
    this.onSaved,
    this.onTap,
    this.onSubmit,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.inputBorder,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.inputAction,
    this.autofocus = false,
    this.capitalization = TextCapitalization.none,
    this.labelColor,
    this.filled,
    this.fillColor,
    this.autoValidateMode = AutovalidateMode.disabled,
    this.maxLines = 1,
    this.initialValue,
    this.maxLength,
    this.counterText,
    this.onChange,
  }) : super(key: key);

  final String id;
  final String? title;
  final bool isRequired;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String? value)? onSaved;
  final void Function()? onTap;
  final void Function(String? value)? onSubmit;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final InputBorder? inputBorder;
  final bool readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputAction? inputAction;
  final bool autofocus;
  final TextCapitalization capitalization;
  final Color? labelColor;
  final bool? filled;
  final Color? fillColor;
  final AutovalidateMode autoValidateMode;
  final int maxLines;
  final String? initialValue;
  final int? maxLength;
  final String? counterText;
  final void Function(String? value)? onChange;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.2,
        color: Colors.grey.shade900.withOpacity(0.6),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.w500),
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: Colors.red),
                      )
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 5),
        ],
        FormBuilderTextField(
          name: id,
          key: key,
          focusNode: focusNode,
          readOnly: readOnly,
          validator: validator,
          onSaved: onSaved,
          onTap: onTap,
          onChanged: onChange,
          onSubmitted: onSubmit,
          textInputAction: inputAction,
          obscureText: obscureText,
          obscuringCharacter: '*',
          keyboardType: keyboardType,
          autovalidateMode: autoValidateMode,
          autofocus: autofocus,
          textCapitalization: capitalization,
          maxLines: maxLines,
          maxLength: maxLength,
          initialValue: initialValue,
          decoration: FilledTextFieldWithLabelTablet.customInputDecoration(
            context: context,
            isDark: isDark,
            maxLines: maxLines,
          ).copyWith(
            border: outlineInputBorder,
            focusedBorder: outlineInputBorder,
            enabledBorder: outlineInputBorder,
            hintText: hintText,
          ),
        ),
      ],
    );
  }
}
