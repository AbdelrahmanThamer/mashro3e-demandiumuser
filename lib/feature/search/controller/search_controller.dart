import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';


class SearchController extends GetxController implements GetxService {
  final SearchRepo searchRepo;
  SearchController({required this.searchRepo});

  List<Service>? _searchServiceList;
  String? _searchText = '';
  List<String>? _historyList = [];
  List<String>? _sortList = ['ascending'.tr, 'descending'.tr];
  bool? _isAvailableFoods = false;
  bool? _isDiscountedFoods = false;
  bool? _isLoading = false;
  bool _isSearchComplete = false;
  bool _isActiveSuffixIcon = false;

  List<Service>? get searchServiceList => _searchServiceList;
  String? get searchText => _searchText;
  List<String>? get historyList => _historyList;
  List<String>? get sortList => _sortList;
  bool? get isAvailableFoods => _isAvailableFoods;
  bool? get isDiscountedFoods => _isDiscountedFoods;
  bool? get isLoading => _isLoading;
  bool get isSearchComplete => _isSearchComplete;
  bool get isActiveSuffixIcon => _isActiveSuffixIcon;


  bool? _isLoggedIn;
  var searchController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();
    if(_isLoggedIn!) {
      // getSuggestedFoods();
    }
    getHistoryList();
    searchController.text = '';
  }

  void toggleAvailableFoods() {
    _isAvailableFoods = !_isAvailableFoods!;
    update();
  }

  void toggleDiscountedFoods() {
    _isDiscountedFoods = !_isDiscountedFoods!;
    update();
  }

  void setSearchText(String text) {
    _searchText = text;
    update();
  }

  Future<void> navigateToSearchResultScreen()async{
    if(searchController.value.text.trim().isNotEmpty){
      if(Get.currentRoute.contains('/search?query=')){
        Get.offNamed(RouteHelper.getSearchResultRoute(queryText: searchController.value.text.trim()));
      }else{
        Get.toNamed(RouteHelper.getSearchResultRoute(queryText: searchController.value.text.trim()));
      }
    }
  }

  Future<void> clearSearchController()async{
    if(searchController.value.text.trim().isNotEmpty){
      searchController.clear();
      _isActiveSuffixIcon = false;
      update();
    }
  }

  Future<void> populatedSearchController(String historyText)async{
    searchController.clear();
    searchController = TextEditingController(text: historyText);
    _isActiveSuffixIcon = true;
    update();

  }




  Future<void> searchData(String query, {bool shouldUpdate = true}) async {
    if(query.isNotEmpty ) {
      _searchText = query;
      _searchServiceList = null;
      if (!_historyList!.contains(query)) {
        _historyList!.insert(0, query);
      }
      searchRepo.saveSearchHistory(_historyList!);
      if(shouldUpdate) {
        update();
      }
      Response response = await searchRepo.getSearchData(query);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          _searchServiceList = [];
        } else {
          _searchServiceList = [];
          _searchServiceList!.addAll(ServiceModel.fromJson(response.body).content!.serviceList!);
        }
      } else {
        ApiChecker.checkApi(response);
      }
      _isSearchComplete = true;
      update();
    }
  }

  void showSuffixIcon(context,String text){
    if(text.length > 0){
      _isActiveSuffixIcon = true;
    }else if(text.length == 0){
      _isActiveSuffixIcon = false;
    }
    update();
  }


  void getHistoryList() {
    _searchText = '';
    _historyList = [];
    if(searchRepo.getSearchAddress().isNotEmpty){
      _historyList!.addAll(searchRepo.getSearchAddress());
    }
  }

  void removeHistory(String index) {
    _historyList!.remove(index);
    searchRepo.saveSearchHistory(_historyList!);
    update();
  }

  List<String>? filterHistory(String pattern, List<String>? value){
    List<String>? _list = [];

    value?.forEach((history) {
      if(history.contains(pattern.toLowerCase())) {
        _list.add(history);
      }
    });

    return _list;
  }


  void clearSearchAddress() async {
    searchRepo.clearSearchHistory();
    _historyList = [];
    update();
  }

  void removeService() async {
   _searchServiceList = [];
   _isSearchComplete = false;
   // searchController.clear();
  }


}
