import 'package:get/get.dart';
import '../../../core/core_export.dart';


class CouponController extends GetxController implements GetxService{
  final CouponRepo couponRepo;
  CouponController({required this.couponRepo});

  bool _isLoading = false;
  CouponModel? _coupon;

  bool get isLoading => _isLoading;
  CouponModel? get coupon => _coupon;

  List<CouponModel>? _couponList;
  List<CouponModel>? get couponList => _couponList;
  

  TabController? voucherTabController;
  CouponTabState __couponTabCurrentState = CouponTabState.CURRENT_COUPON;
  CouponTabState get couponTabCurrentState => __couponTabCurrentState;

  Future<void> getCouponList() async {
    _isLoading = true;
    Response response = await couponRepo.getCouponList();
    if (response.statusCode == 200) {
      _couponList = [];
      response.body["content"]["data"].forEach((category) {
        if('${category['is_active']}' == '1' ) {
          _couponList!.add(CouponModel.fromJson(category));
        }
      });
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  Future<void> applyCoupon(CouponModel couponModel) async {
    Response response = await couponRepo.applyCoupon(couponModel.couponCode!);
    if(response.statusCode == 200 && response.body['response_code'] == 'default_200'){
      _coupon = couponModel;
      customSnackBar("coupon_applied_successfully".tr, isError: false);
    }else{
      customSnackBar(response.body['message'], isError: true);
    }
    print('coupon response : ${response.body}');
    update();
  }



  void updateTabBar(CouponTabState couponTabState, {bool isUpdate = true}){
    __couponTabCurrentState = couponTabState;
    if(isUpdate){
      update();
    }
  }

  void removeCouponData(bool notify) {
    _coupon = null;
    if(notify) {
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }


}

enum CouponTabState {
  CURRENT_COUPON,
  USED_COUPON
}