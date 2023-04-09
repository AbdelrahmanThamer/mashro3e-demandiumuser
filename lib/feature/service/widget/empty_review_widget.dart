import 'package:demandium/components/web_shadow_wrap.dart';
import 'package:get/get.dart';
import '../../../core/core_export.dart';

class EmptyReviewWidget extends StatelessWidget {
  const EmptyReviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: WebShadowWrap(
        child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          constraints:  ResponsiveHelper.isDesktop(context) ? BoxConstraints(
            minHeight: !ResponsiveHelper.isDesktop(context) && Get.size.height < 600 ? Get.size.height : Get.size.height - 550,
          ) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              Image.asset(Images.emptyReview,scale:Dimensions.PADDING_SIZE_SMALL,color: Get.isDarkMode ?  Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,),
              SizedBox(height: 20.0,),
              Text("no_review_yet".tr,style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6)),),
            ],
          ),
        ),
      ),
    );
  }
}
