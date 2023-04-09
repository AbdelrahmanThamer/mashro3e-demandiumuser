import 'package:get/get.dart';
import '../../../core/core_export.dart';

enum BookingStatusTabs {all, pending, accepted, ongoing,completed,canceled }

class ServiceBookingController extends GetxController implements GetxService {
  final ServiceBookingRepo serviceBookingRepo;
  ServiceBookingController({required this.serviceBookingRepo});

  bool _isPlacedOrdersuccessfully = false;
  bool get isPlacedOrdersuccessfully => _isPlacedOrdersuccessfully;
  List<BookingModel>? _bookingList;
  List<BookingModel>? get bookingList => _bookingList;
  int _offset = 1;
  int? get offset => _offset;

  int _bookingListPageSize = 0;
  int get bookingListPageSize=> _bookingListPageSize;
  BookingStatusTabs _selectedBookingStatus = BookingStatusTabs.all;
  BookingStatusTabs get selectedBookingStatus =>_selectedBookingStatus;

  final ScrollController bookingScreenScrollController = ScrollController();


  @override
  void onInit() {
    super.onInit();
    bookingScreenScrollController.addListener(() {
      if(bookingScreenScrollController.position.pixels == bookingScreenScrollController.position.maxScrollExtent) {
       if(offset! < bookingListPageSize){
          getAllBookingService(bookingStatus: selectedBookingStatus.name.toLowerCase(),offset: offset! + 1,isFromPagination:true);
        }
      }
    });
  }

  void updateBookingStatusTabs(BookingStatusTabs bookingStatusTabs, {bool firstTimeCall = true, bool fromMenu= false}){
    _selectedBookingStatus = bookingStatusTabs;
    if(firstTimeCall){
      getAllBookingService(offset: 1, bookingStatus: _selectedBookingStatus.name.toLowerCase(),isFromPagination:false);
    }
  }

  Future<void> placeBookingRequest({required String paymentMethod,required String userID,required String serviceAddressId, required String schedule})async{
    String zoneId = Get.find<LocationController>().getUserAddress()!.zoneId.toString();
    Response response = await serviceBookingRepo.placeBookingRequest(
        paymentMethod:paymentMethod,
        userId: userID,
        schedule: schedule,
        serviceAddressID: serviceAddressId,
        zoneId:zoneId,
    );

    if(response.statusCode == 200){
      _isPlacedOrdersuccessfully = true;
      Get.find<CheckOutController>().updateState(PageState.complete);
      ///navigate replace
      Get.toNamed(RouteHelper.getCheckoutRoute('cart',Get.find<CheckOutController>().currentPage.name,"null"));
      customSnackBar('service_booking_successfully'.tr,isError: false);
      Get.find<CartController>().getCartListFromServer();
      update();
    }
  }

  Future<void> getAllBookingService({required int offset, required String bookingStatus, required bool isFromPagination, bool fromMenu= false})async{
    _offset = offset;
    if(!isFromPagination){
      _bookingList = null;
    }
    Response response = await serviceBookingRepo.getBookingList(offset: offset, bookingStatus: bookingStatus);
    if(response.statusCode == 200){
      ServiceBookingList _serviceBookingModel = ServiceBookingList.fromJson(response.body);
      if(!isFromPagination){
        _bookingList = [];
      }
      _serviceBookingModel.content!.bookingModel!.forEach((element) {
        _bookingList!.add(element);
      });
      _bookingListPageSize = response.body['content']['last_page'];
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
}
