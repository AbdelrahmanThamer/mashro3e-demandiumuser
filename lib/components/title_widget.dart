import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class TitleWidget extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  TitleWidget({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title!, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
      (onTap != null && !ResponsiveHelper.isDesktop(context)) ? InkWell(
        onTap: onTap,
        child: Text(
          'see_all'.tr,
          style: ubuntuMedium.copyWith(
              decoration: TextDecoration.underline,
              color:Get.isDarkMode ?Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6) : Theme.of(context).colorScheme.primary,
              fontSize: Dimensions.fontSizeDefault, ),

        ),
      ) : SizedBox(),
    ]);
  }
}
