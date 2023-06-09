import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class CartServiceWidget extends StatelessWidget {
  final CartModel cart;
  final int cartIndex;

  CartServiceWidget({
    required this.cart,
    required this.cartIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_DEFAULT,left: Dimensions.PADDING_SIZE_EXTRA_SMALL,right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: Container(
        height: 90.0,
        decoration: BoxDecoration(
            color: Theme.of(context).hoverColor,
            borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
        child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            children: [
              Positioned(
                right: Get.find<LocalizationController>().isLtr ? 22: null,
                left: Get.find<LocalizationController>().isLtr ? null: 22,
                child: Image.asset(Images.cartDelete,width: 22.0,),),
              Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  if (Get.find<AuthController>().isLoggedIn()) {
                    Get.find<CartController>().removeCartFromServer(cart.id);}
                  else {
                    Get.find<CartController>().removeFromCart(cartIndex);
                  }},
                child:
                Container(
                  padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT, horizontal: Dimensions.PADDING_SIZE_SMALL),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border.all(color: Colors.white.withOpacity(.2)),
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    boxShadow:Get.isDarkMode ? null:[
                      BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 800 : 200]!,
                        blurRadius: 5,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Get.toNamed(RouteHelper.getServiceRoute(cart.serviceId));
                            },
                            child: Container(
                              width:ResponsiveHelper.isMobile(context)? Get.width / 1.8 : Get.width / 4,
                              child: Row(
                                children: [
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                                    child: CustomImage(
                                      image: '${Get.find<SplashController>().configModel.content!.imageBaseUrl}/service/${cart.service!.thumbnail}',
                                      height: 65,
                                      width: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            cart.service!.name!,
                                            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                                          SizedBox(
                                            width: Get.width * 0.4,
                                            child: Text(
                                              cart.variantKey,
                                              style: ubuntuMedium.copyWith(color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6), fontSize: Dimensions.fontSizeDefault),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            '${PriceConverter.convertPrice(cart.totalCost.toDouble())}',
                                            style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6)),
                                          ),
                                          SizedBox(height: 5),
                                        ]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(children: [
                            if (cart.quantity > 1)
                              QuantityButton(
                                onTap: () {
                                  if(Get.find<AuthController>().isLoggedIn()){
                                    Get.find<CartController>().updateCartQuantityToApi(cart.id,cart.quantity - 1);
                                  }else{
                                    Get.find<CartController>().setQuantity(false, cart);
                                  }
                                },
                                isIncrement: false,
                              ),
                            if (cart.quantity == 1)
                              InkWell(
                                onTap: () {
                                  if (Get.find<AuthController>().isLoggedIn()) {
                                    Get.find<CartController>().removeCartFromServer(cart.id);
                                  } else {
                                    Get.find<CartController>().removeFromCart(cartIndex);
                                  }
                                },
                                child: Container(
                                    height: 22,
                                    width: 22,
                                    margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                                    child: Image.asset(Images.cartDeleteVariation)),
                              ),
                            Text(cart.quantity.toString(), style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
                            QuantityButton(
                              onTap: () {
                                if(Get.find<AuthController>().isLoggedIn()){
                                  Get.find<CartController>().updateCartQuantityToApi(cart.id,cart.quantity + 1);
                                }else{
                                  Get.find<CartController>().setQuantity(true, cart);
                                }
                              },
                              isIncrement: true,
                            ),
                          ]),
                        ),
                      ]),
                ),
              ),
        ]),
      ),
    );
  }
}
