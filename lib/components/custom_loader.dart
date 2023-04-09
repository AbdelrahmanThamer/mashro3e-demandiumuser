import 'package:demandium/core/core_export.dart';

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,));
  }
}
