import 'package:demandium/components/footer_base_view.dart';
import 'package:demandium/components/menu_drawer.dart';
import 'package:get/get.dart';
import 'package:demandium/feature/review/controller/submit_review_controller.dart';
import 'package:demandium/feature/review/widgets/select_rating.dart';
import 'package:demandium/core/core_export.dart';

class RateReviewScreen extends GetView<SubmitReviewController> {
  final String serviceID;
  final String bookingIDForReview;
  final BookingDetailsContent bookingDetailsContent;
  final int index;
  final String variantKey;
  RateReviewScreen({
    Key? key,
    required this.serviceID,
    required this.bookingIDForReview,
    required this.bookingDetailsContent,
    required this.index,
    required this.variantKey,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    TextEditingController reviewController = TextEditingController();

    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? MenuDrawer():null,
      appBar: CustomAppBar(title: 'review'.tr,),
      body: FooterBaseView(
        child: SizedBox(
          width: Dimensions.WEB_MAX_WIDTH,
          child: SingleChildScrollView(
            child: Form(
              key: controller.submitReviewKey,
              child: Column(
                children: [
                 Stack(children: [
                   Container(
                     height:ResponsiveHelper.isDesktop(context)? 280: 120.0,
                     width: Get.width,
                     decoration: BoxDecoration(
                         image: DecorationImage(fit: BoxFit.fill, image: AssetImage(Images.reviewTopBanner))
                     ),),
                   Container(
                     height:ResponsiveHelper.isDesktop(context)? 280: 120.0,
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         ResponsiveHelper.isDesktop(context)?Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: ReviewBookingDetailsCard(bookingDetailsContent: bookingDetailsContent, index: index, variantKey: variantKey),
                         ):SizedBox(),
                       ],
                     ),
                   )
                 ],),
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context)?0:Dimensions.PADDING_SIZE_DEFAULT),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      !ResponsiveHelper.isDesktop(context)?ReviewBookingDetailsCard(bookingDetailsContent: bookingDetailsContent, index: index, variantKey: variantKey):SizedBox(),
                      SelectRating(),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            color: Theme.of(context).hoverColor),
                        child: Center(
                          child: TextFormField(maxLines: 8,
                            controller: reviewController,
                            decoration: InputDecoration(
                              hintText: 'write_your_review'.tr,
                              border: InputBorder.none,
                              hintStyle: ubuntuRegular,
                            ),
                            validator: (v) => v?.isEmpty == true ? 'required'.tr : null,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                      controller.isLoading?CircularProgressIndicator() : CustomButton(
                        buttonText: 'submit'.tr,
                        onPressed: (){
                          final isValid = controller.submitReviewKey.currentState!.validate();
                          if(isRedundentClick(DateTime.now())){
                            print('hold on, processing');
                            return;
                          }
                          if(isValid){
                            String review = reviewController.value.text;
                            ReviewBody  reviewBody = ReviewBody(bookingID: bookingIDForReview, serviceID: serviceID, rating: controller.selectedRating.toString(), comment: review);
                            controller.submitReview(reviewBody);
                          }
                        },
                      ),
                    ],
                  ),
                )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReviewBookingDetailsCard extends StatelessWidget {
  const ReviewBookingDetailsCard({
    Key? key,
    required this.bookingDetailsContent,
    required this.index,
    required this.variantKey,
  }) : super(key: key);

  final BookingDetailsContent bookingDetailsContent;
  final int index;
  final String variantKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Get.isDarkMode ? Theme.of(context).primaryColorDark:Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${'booking_no'.tr} # ${bookingDetailsContent.readableId}",
                  style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.primary),),
                Text("${PriceConverter.convertPrice(bookingDetailsContent.totalBookingAmount!.toDouble())}"),
              ],
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${DateConverter.formatDate(DateConverter.isoUtcStringToLocalDate(bookingDetailsContent.createdAt!))}'),
                Text("${bookingDetailsContent.bookingStatus}".tr, style: ubuntuMedium.copyWith(color: Colors.green),),
              ],
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
            if(bookingDetailsContent.detail![index].service != null)
              Text("${bookingDetailsContent.detail![index].service!.name!}",style: ubuntuMedium,),
            Text(variantKey),
            Divider(),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
          ],
        ),
      ),
    );
  }
}
