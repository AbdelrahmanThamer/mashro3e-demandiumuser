import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';
import 'package:demandium/feature/voucher/controller/coupon_controller.dart';

class Voucher extends StatelessWidget {
  final CouponModel couponModel;
  const Voucher({Key? key,required this.couponModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Theme.of(context).hoverColor,
        boxShadow: Get.isDarkMode ?null: cardShadow,
      ),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT,),
      padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL,),
      width: context.width,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Image.asset(Images.voucherImage,fit: BoxFit.fitWidth,)),
          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
          Expanded(
            flex: 3,
            child: Container(
              //color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    couponModel.couponCode!,
                    style: ubuntuMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    "${'use_code'.tr} ${couponModel.couponCode!} ${'to_save_upto'.tr} ${PriceConverter.convertPrice(couponModel.discount!.discountAmountType == 'amount'?
                    couponModel.discount!.discountAmount!.toDouble() : couponModel.discount!.maxDiscountAmount!.toDouble())} ${'on_your_next_purchase'.tr}",
                    maxLines: 2,
                    style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.5)),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("valid_till".tr,
                            style: ubuntuRegular.copyWith(
                              color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6),
                              fontSize: Dimensions.fontSizeSmall),),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                          Text(couponModel.discount!.endDate.toString(),
                              style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6), fontSize: 12))
                        ],
                      ),
                      Get.find<CouponController>().couponTabCurrentState == CouponTabState.CURRENT_COUPON ?  InkWell(
                        onTap: ()async {
                          if(Get.find<AuthController>().isLoggedIn()){
                            bool _addCoupon = false;
                            Get.find<CartController>().cartList.forEach((_cart) {
                              if(_cart.serviceCost > couponModel.discount!.minPurchase!.toDouble()) {
                                _addCoupon = true;
                              }
                            });

                            if(_addCoupon) {
                              Get.back();

                              Get.find<CouponController>().applyCoupon(couponModel).then((value) {
                                Get.find<CartController>().getCartListFromServer();
                              },
                              );

                            }else{
                              Get.back();
                              customSnackBar('you_need_to_add_more_services'.tr);
                            }
                          }else{
                            onDemandToast("login_required_to_apply_coupon".tr,Colors.red);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))
                          ),
                          child: Center(
                            child: Text(
                              'use'.tr,
                              style: ubuntuRegular.copyWith(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: Dimensions.fontSizeDefault,),
                            ),
                          ),
                          height: 25,
                          width:63.0,
                        ),
                      ) : SizedBox(),
                    ],
                  )
                ],
          ),
              ),
            ),),
        ],
      ),
    );
  }
}
