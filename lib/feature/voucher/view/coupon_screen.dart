import 'package:demandium/components/menu_drawer.dart';
import 'package:get/get.dart';
import 'package:demandium/components/footer_base_view.dart';
import 'package:demandium/components/web_shadow_wrap.dart';
import 'package:demandium/core/core_export.dart';
import 'package:demandium/feature/voucher/controller/coupon_controller.dart';
import 'package:demandium/feature/voucher/widgets/voucher.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({Key? key}) : super(key: key);

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> with TickerProviderStateMixin{
  TabController? _couponTabController;


  @override
  initState() {
    _couponTabController = TabController(vsync: this, length: 2, initialIndex: 0);
    Get.find<CouponController>().getCouponList();
    _couponTabController?.addListener(() {
      Get.find<CouponController>().updateTabBar(
        _couponTabController?.index == 0 ?  CouponTabState.CURRENT_COUPON : CouponTabState.USED_COUPON,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? MenuDrawer():null,
      appBar: CustomAppBar(
        title: "voucher".tr,
        centerTitle: true,
        isBackButtonExist: true,
      ),
      body: GetBuilder<CouponController>(
        builder: (couponController){
          List<CouponModel>? couponList = couponController.couponList;
          return FooterBaseView(
            isCenter: (couponList == null || couponList.length == 0),
            child: WebShadowWrap(
              child: Container(
                  child: (couponList != null && couponList.length == 0) ?
                  NoDataScreen(text: "no_coupon_found".tr,type: NoDataType.COUPON):
                  (couponList != null) ?
                  Column(children: [
                  if(couponList.length > 0)
                    Stack(
                      children: [
                        Container(
                          width: Get.width,
                          height: 91,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              image: AssetImage(Images.offerBanner),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: 91,
                          color: Colors.black54,
                          width: Get.width,
                        ),
                      ],
                    ),

                  _couponList(
                    context, couponList.where((element) => DateConverter.convertStringTimeToDateOnly(
                      element.discount!.endDate!).isAfter(DateTime.now())).toList(),
                  ),
                ],
              ):
              Center(child: CircularProgressIndicator(),)),
            ),
          );
        }

      ),
    );
  }

  Widget _couponList(BuildContext context, List<CouponModel> couponList) {
    return couponList.length > 0 ? Container(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_DEFAULT),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE,
            mainAxisSpacing: ResponsiveHelper.isDesktop(context) ?
            Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_SMALL,
            childAspectRatio: ResponsiveHelper.isMobile(context) ? 3.2 : 4,
            crossAxisCount: ResponsiveHelper.isMobile(context) ? 1 : 2,
            mainAxisExtent:Get.find<LocalizationController>().isLtr ?  130 : 140,
          ),
          itemBuilder: (context, index) {
            return Voucher(
              couponModel: couponList[index],
            );
          },
          itemCount: couponList.length,
        )) : SizedBox();
  }
}
