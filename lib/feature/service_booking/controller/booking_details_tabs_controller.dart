import 'package:get/get.dart';
import 'package:demandium/feature/service_booking/model/invoice.dart';
import 'package:demandium/feature/service_booking/repo/booking_details_repo.dart';
import '../../../core/core_export.dart';

enum BookingDetailsTabs {BookingDetails, Status}
class BookingDetailsTabsController extends GetxController with GetSingleTickerProviderStateMixin {
  BookingDetailsRepo bookingDetailsRepo;
  BookingDetailsTabsController({required this.bookingDetailsRepo});



  BookingDetailsTabs _selectedDetailsTabs = BookingDetailsTabs.BookingDetails;
  BookingDetailsTabs get selectedBookingStatus =>_selectedDetailsTabs;
  TabController? detailsTabController;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isCancelling = false;
  bool get isCancelling => _isCancelling;
  BookingDetailsContent? _bookingDetailsContent;
  BookingDetailsContent? get bookingDetailsContent => _bookingDetailsContent;
  List<InvoiceItem> _invoiceItems =[];
  List<InvoiceItem> get invoiceItems => _invoiceItems;
  double _invoiceGrandTotal= 0.0;
  double get invoiceGrandTotal => _invoiceGrandTotal;


  List<double> _unitTotalCost =[];
  double _allTotalCost = 0;
  double _totalDiscount =0;
  double _totalDiscountWithCoupon =0;
  List<double> get unitTotalCost => _unitTotalCost;
  double get allTotalCost => _allTotalCost;
  double get totalDiscount => _totalDiscount;
  double get totalDiscountWithCoupon => _totalDiscountWithCoupon;




  void updateBookingStatusTabs(BookingDetailsTabs bookingDetailsTabs){
    _selectedDetailsTabs = bookingDetailsTabs;
    update();

  }

  @override
   void onInit(){
    super.onInit();
    detailsTabController = TabController(
        length: BookingDetailsTabs.values.length, vsync: this);
  }

  Future<void> bookingCancel({required String bookingId})async{
    _isCancelling = true;
    update();
    Response? response = await bookingDetailsRepo.bookingCancel(bookingID: bookingId);
    if(response.statusCode == 200){
      _isCancelling = false;
      customSnackBar('booking_cancelled_successfully'.tr, isError: false);
      getBookingDetails(bookingId: bookingId);
    }else{
      _isCancelling = false;
      ApiChecker.checkApi(response);
    }
    update();
  }

  Future<void> getBookingDetails({required String bookingId})async{
    _invoiceGrandTotal = 0;
    _invoiceItems = [];
    _bookingDetailsContent = null;
    Response response = await bookingDetailsRepo.getBookingDetails(bookingID: bookingId);
    print(response.statusCode);
    if(response.statusCode == 200){
      _allTotalCost = 0.0;
      _unitTotalCost = [];
      _bookingDetailsContent = BookingDetailsContent.fromJson(response.body['content']);
      if(_bookingDetailsContent!.detail != null ){

        _bookingDetailsContent!.detail!.forEach((element) {
          _unitTotalCost.add(element.serviceCost!.toDouble()*element.quantity!);

        });
        _unitTotalCost.forEach((element) {
          _allTotalCost = _allTotalCost+element;
        });

      }

      double? discount= _bookingDetailsContent!.totalDiscountAmount!.toDouble();
      double? campaignDiscount= _bookingDetailsContent!.totalCampaignDiscountAmount!.toDouble();
      _totalDiscount = (discount+campaignDiscount);
      _totalDiscountWithCoupon = discount+campaignDiscount+(_bookingDetailsContent!.totalCouponDiscountAmount!);
      _bookingDetailsContent!.detail?.forEach((element){

        _invoiceItems.add(
            InvoiceItem(
              discountAmount:(
                  element.discountAmount! +
                      element.campaignDiscountAmount!.toDouble()
                      +element.overallCouponDiscountAmount!.toDouble()),
              tax: element.taxAmount!.toDouble(),
              unitAllTotal: element.totalCost!.toDouble(),
              quantity: element.quantity!,
              serviceName: "${element.service?.name ?? 'service_deleted'.tr } \n ${element.variantKey ?? 'variantKey_not_available'.tr}" ,
              unitPrice: element.serviceCost!.toDouble(),
            )
        );
      });
      update();
    } else {
      ApiChecker.checkApi(response);
    }
  }



  String calculateDiscount(double ? discountAmount,double ? campaignDiscount,int qty){
    return ((discountAmount!+campaignDiscount!)*qty).toStringAsFixed(3);
  }

  String calculateTex(double ? tax,int qty){
    return (tax!*qty).toStringAsFixed(3);
  }

  double calculateTotalCost(BookingContentDetailsItem element){
    double? discount = element.discountAmount!.toDouble();
    double? campaignDiscount = element.campaignDiscountAmount!.toDouble();
    double? totalDiscount =discount+campaignDiscount;
    double? tex = element.taxAmount!.toDouble();
    int? qty = element.quantity!;
    double? total = element.serviceCost!.toDouble();
    double texQ= tex * qty;
    double discountQ=totalDiscount*qty;
    double totalQ= total*qty;
    double? allTotal= (totalQ+texQ)-discountQ;
    printLog("=========>$allTotal");
    _invoiceGrandTotal=_invoiceGrandTotal+allTotal;
    return allTotal;
  }


  @override
  void onClose(){
    detailsTabController!.dispose();
    super.onClose();
  }
}