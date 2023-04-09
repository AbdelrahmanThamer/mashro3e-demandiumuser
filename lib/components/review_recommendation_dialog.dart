import 'package:get/get.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:demandium/core/core_export.dart';

class ReviewRecommendationDialog extends StatelessWidget {
  final int index;
  final BookingDetailsContent bookingDetailsContent;
  final String serviceID;
  final String bookingID;
  final String variantKey;
  const ReviewRecommendationDialog({
    Key? key,
    required this.serviceID,
    required this.bookingID,
    required this.bookingDetailsContent,
    required this.index,
    required this.variantKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Container(
          width: Dimensions.WEB_MAX_WIDTH,
          padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_DEFAULT, bottom: Dimensions.PADDING_SIZE_DEFAULT),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: Dimensions.PADDING_SIZE_DEFAULT,
                              right: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Icon(Icons.close,color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6),),
                        )),
                  ),
                  Text('how_was_your_last_service'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.primary),),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                  Text('leave_a_review'.tr, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).colorScheme.primary),),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
                  Image.asset(Images.emptyReview,scale:Dimensions.PADDING_SIZE_SMALL,color:Get.isDarkMode ?  Theme.of(context).primaryColorLight: Theme.of(context).primaryColor,),
                  SizedBox(height: 30.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: [
                      Container(width:(ResponsiveHelper.isWeb() && ResponsiveHelper.isMobile(context)) ? Get.width / 3 : 200, child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).hoverColor)),
                          onPressed: (){
                            Get.back();
                          },
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: 5),
                            child: Text('skip'.tr,style: ubuntuMedium.copyWith(color:Get.isDarkMode ?  Colors.white:Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6),fontSize: Dimensions.fontSizeSmall),),
                          ))),
                      ElevatedButton(
                          onPressed: () {
                            Get.back();
                            // print(serviceID);
                            Get.toNamed(RouteHelper.getRateReviewScreen(
                              serviceID,
                              bookingID,
                              bookingDetailsContent,
                              index,
                              variantKey,
                            ));
                          },
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: 5),
                            child: Text('give_review'.tr,style: ubuntuMedium.copyWith(color: Colors.white,fontSize: Dimensions.fontSizeSmall),),
                          ))
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,)
                ]),
          )),
    );
  }
}
