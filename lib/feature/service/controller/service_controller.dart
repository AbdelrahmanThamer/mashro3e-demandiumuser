import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';
import 'package:demandium/feature/campaign/model/service_types.dart';

class ServiceController extends GetxController implements GetxService {
  final ServiceRepo serviceRepo;
  ServiceController({required this.serviceRepo});


  ServiceContent? _serviceContent;
  ServiceContent? _offerBasedServiceContent;
  ServiceContent? _popularBasedServiceContent;
  List<Service>? _popularServiceList;
  ServiceContent? _recommendedServiceContent;
  List<Service>? _recommendedServiceList;
  List<Service>? _subCategoryBasedServiceList;
  List<Service>? _campaignBasedServiceList;
  List<Service>? _offerBasedServiceList;
  List<Service>? _allService;
  List<Service>? get allService => _allService ;


  bool _isLoading = false;
  List<int>? _variationIndex;
  int? _quantity = 1;
  List<bool>? _addOnActiveList = [];
  List<int>? _addOnQtyList = [];
  int _cartIndex = -1;

  ServiceContent? get serviceContent => _serviceContent;
  ServiceContent? get offerBasedServiceContent => _offerBasedServiceContent;
  ServiceContent? get popularBasedServiceContent => _popularBasedServiceContent;
  List<Service>? get popularServiceList => _popularServiceList;
  List<Service>? get recommendedServiceList => _recommendedServiceList;
  ServiceContent? get recommendedBasedServiceContent => _recommendedServiceContent;
  List<Service>? get subCategoryBasedServiceList => _subCategoryBasedServiceList;
  List<Service>? get campaignBasedServiceList => _campaignBasedServiceList;
  List<Service>? get offerBasedServiceList => _offerBasedServiceList;

  bool get isLoading => _isLoading;
  List<int>? get variationIndex => _variationIndex;
  int? get quantity => _quantity;
  List<bool>? get addOnActiveList => _addOnActiveList;
  List<int>? get addOnQtyList => _addOnQtyList;
  int get cartIndex => _cartIndex;

  double? _serviceDiscount = 0.0;
  double get serviceDiscount => _serviceDiscount!;

  String? _discountType;
  String get discountType => _discountType!;

  String? _fromPage;
  String? get fromPage => _fromPage!;

  List<double> _lowestPriceList = [];
  List<double> get lowestPriceList => _lowestPriceList;


  @override
  Future<void> onInit() async {
    super.onInit();
    if(Get.find<AuthController>().isLoggedIn()) {
     await Get.find<UserController>().getUserInfo();
     await Get.find<CartController>().getCartData();
     // await Get.find<CartController>().addMultipleCartToServer();
     await Get.find<CartController>().getCartListFromServer();
    }
  }



  Future<void> getAllServiceList(int offset, bool reload) async {
    if(reload){
      _allService = null;
    }
    Response response = await serviceRepo.getAllServiceList(offset);
    if (response.statusCode == 200) {
      if(reload){
        _allService = [];
      }
        _serviceContent = ServiceModel.fromJson(response.body).content;
        if(_allService != null && offset != 1){
          _allService!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }else{
          _allService = [];
          _allService!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }
        update();
    } else {
      ApiChecker.checkApi(response);
    }
  }


  Future<void> getPopularServiceList(int offset, bool reload) async {
    Response response = await serviceRepo.getPopularServiceList(offset);

    if (response.statusCode == 200) {
      if(reload){
        _popularServiceList = [];
      }
      _popularBasedServiceContent = ServiceModel.fromJson(response.body).content;

      if(_popularServiceList != null && offset != 1){
        _popularServiceList!.addAll(_popularBasedServiceContent!.serviceList!);
      }else{
        _popularServiceList = [];
        _popularServiceList!.addAll(_popularBasedServiceContent!.serviceList!);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getRecommendedServiceList(int offset, bool reload ) async {
    Response response = await serviceRepo.getRecommendedServiceList(offset);
    if (response.statusCode == 200) {
      if(reload){
        _recommendedServiceList = [];
      }
      _recommendedServiceContent = ServiceModel.fromJson(response.body).content;
      if(_recommendedServiceList != null && offset != 1){
        _recommendedServiceList!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
      }else{
        _recommendedServiceList = [];
        _recommendedServiceList!.addAll(_recommendedServiceContent!.serviceList!);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

   cleanSubCategory(){
    _subCategoryBasedServiceList = null;
    update();
  }

  Future<void> getSubCategoryBasedServiceList(String subCategoryID, bool isWithPagination, {bool isShouldUpdate = true}) async {
    Response response = await serviceRepo.getServiceListBasedOnSubCategory(subCategoryID: subCategoryID,offset: 1);
    if (response.statusCode == 200) {
      if(!isWithPagination){
        _subCategoryBasedServiceList = [];
      }
      _subCategoryBasedServiceList!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
    } else {
      ApiChecker.checkApi(response);
    }
    if(isShouldUpdate){
      update();
    }
  }

  Future<void> getCampaignBasedServiceList(String campaignID, bool reload) async {
    Response response = await serviceRepo.getItemsBasedOnCampaignId(campaignID: campaignID);
    if (response.body['response_code'] == 'default_200') {
      if(reload){
        _campaignBasedServiceList = [];
      }
      response.body['content']['data'].forEach((serviceTypesModel) {
        if(ServiceTypesModel.fromJson(serviceTypesModel).service != null){
          _campaignBasedServiceList!.add(ServiceTypesModel.fromJson(serviceTypesModel).service);
        }
      });
      Get.toNamed(RouteHelper.allServiceScreenRoute("fromCampaign",campaignID: campaignID));
    } else {
      customSnackBar('campaign_is_not_available_for_this_service'.tr);
      if(response.statusCode != 200){
        ApiChecker.checkApi(response);
      }
    }
    update();
  }

  Future<void> getEmptyCampaignService()async {
    _campaignBasedServiceList = null;
    update();
  }

  Future<void> getMixedCampaignList(String campaignID, bool isWithPagination) async {
    if(!isWithPagination){
      _campaignBasedServiceList = [];
    }
    Response response = await serviceRepo.getItemsBasedOnCampaignId(campaignID: campaignID);
    if (response.body['response_code'] == 'default_200') {
      response.body['content']['data'].forEach((serviceTypesModel) {
        if(ServiceTypesModel.fromJson(serviceTypesModel).service != null){
          _campaignBasedServiceList!.add(ServiceTypesModel.fromJson(serviceTypesModel).service);
        }
      });
      _isLoading = false;
      if(_campaignBasedServiceList!.length == 0){
        Get.find<CategoryController>().getCampaignBasedCategoryList(campaignID,false);
      }else{
        Get.toNamed(RouteHelper.allServiceScreenRoute("fromCampaign",campaignID: campaignID));
      }
    } else {
      if(response.statusCode != 200){
        ApiChecker.checkApi(response);
      }else{
        customSnackBar('campaign_is_not_available_for_this_service'.tr);
      }
    }
    update();
  }

  Future<void> getOffersList(int offset, bool reload) async {
    Response response = await serviceRepo.getOffersList(offset);
    if (response.statusCode == 200) {
      if( reload){
        _offerBasedServiceList = [];
      }
      _offerBasedServiceContent = ServiceModel.fromJson(response.body).content;
      if(_offerBasedServiceList != null && offset != 1){
        _offerBasedServiceList!.addAll(_offerBasedServiceContent!.serviceList!);
      }else{
        _offerBasedServiceList = [];
        _offerBasedServiceList!.addAll(_offerBasedServiceContent!.serviceList!);
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }


  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  int setExistInCart(Service service, {bool notify = true}) {
    List<String> _variationList = [];
    for (int index = 0; index < service.variationsAppFormat!.zoneWiseVariations!.length; index++) {
      _variationList.add(service.variationsAppFormat!.zoneWiseVariations![index].variantName!);
    }
    String variationType = '';
    bool isFirst = true;
    _variationList.forEach((variation) {
      if (isFirst) {
        variationType = '$variationType$variation';
        isFirst = false;
      } else {
        variationType = '$variationType-$variation';
      }
    });
    if(_cartIndex != -1) {
      _quantity = Get.find<CartController>().cartList[_cartIndex].quantity;
      _addOnActiveList = [];
      _addOnQtyList = [];

    }
    return _cartIndex;
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList![index] = _addOnQtyList![index] + 1;
    } else {
      _addOnQtyList![index] = _addOnQtyList![index] - 1;
    }
    update();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity! + 1;
    } else {
      _quantity = _quantity! - 1;
    }
    update();
  }

  void setCartVariationIndex(int index, int i,Service product) {
    _variationIndex![index] = i;
    _quantity = 1;
    setExistInCart(product);
    update();
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList![index] = isAdd;
    update();
  }


  Future<void> getServiceDiscount(Service service) async {
    if(service.campaignDiscount != null){
      _serviceDiscount = service.campaignDiscount!.length > 0 ?  service.campaignDiscount!.elementAt(0).discount!.discountAmount!.toDouble(): 0.0;
      _discountType = service.campaignDiscount!.length > 0 ?  service.campaignDiscount!.elementAt(0).discount!.discountType!:'amount';
    }else if(service.category!.campaignDiscount != null){
      _serviceDiscount = service.category!.campaignDiscount!.length > 0 ?  service.category!.campaignDiscount!.elementAt(0).discount!.discountAmount!.toDouble(): 0.0;
      _discountType = service.category!.campaignDiscount!.length > 0 ?  service.category!.campaignDiscount!.elementAt(0).discount!.discountAmountType! :'amount';
    }else if(service.serviceDiscount != null){
      _serviceDiscount = service.serviceDiscount!.length > 0 ?  service.serviceDiscount!.elementAt(0).discount!.discountAmount!.toDouble(): 0.0;
      _discountType = service.serviceDiscount!.length > 0 ?  service.serviceDiscount!.elementAt(0).discount!.discountType!:'amount';
    } else{
      _serviceDiscount = service.category!.categoryDiscount!.length > 0 ?  service.category!.categoryDiscount!.elementAt(0).discount!.discountAmount!.toDouble(): 0.0;
      _discountType = service.category!.categoryDiscount!.length > 0 ?  service.category!.categoryDiscount!.elementAt(0).discount!.discountAmountType! :'amount';
    }
  }



}
