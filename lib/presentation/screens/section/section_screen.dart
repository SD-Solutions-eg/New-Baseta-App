import 'package:allin1/data/models/section_model.dart';
import 'package:allin1/presentation/routers/import_helper.dart';
import 'package:allin1/presentation/screens/section/section_mobile.dart';

class SectionScreen extends StatelessWidget {
  final SectionModel section;
  const SectionScreen({
    Key? key,
    required this.section,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SectionMobile(section: section);
  }
}
