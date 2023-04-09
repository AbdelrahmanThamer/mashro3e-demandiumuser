import 'package:demandium/components/menu_drawer.dart';
import 'package:get/get.dart';
import 'package:demandium/components/footer_base_view.dart';
import 'package:demandium/core/core_export.dart';
import 'package:demandium/feature/service_booking/widget/booking_item_card.dart';
import 'package:demandium/feature/service_booking/widget/booking_screen_shimmer.dart';
import 'package:demandium/feature/service_booking/widget/booking_status_tabs.dart';

class BookingScreen extends StatefulWidget {
  final bool isFromMenu;
  const BookingScreen({Key? key, this.isFromMenu = false}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  void initState() {
    Get.find<ServiceBookingController>().getAllBookingService(offset: 1,bookingStatus: "all",isFromPagination:false);
    Get.find<ServiceBookingController>().updateBookingStatusTabs(BookingStatusTabs.all, firstTimeCall: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer:ResponsiveHelper.isDesktop(context) ? MenuDrawer():null,
        appBar: CustomAppBar(
            isBackButtonExist: widget.isFromMenu? true : false,
            onBackPressed: () => Get.back(),
            title: "my_bookings".tr),
        body: GetBuilder<ServiceBookingController>(
          builder: (serviceBookingController){
              List<BookingModel>? _bookingList = serviceBookingController.bookingList;
              return _buildBody(
                sliversItems:serviceBookingController.bookingList != null? [
                  if(ResponsiveHelper.isDesktop(context))
                    SliverToBoxAdapter(child: SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),),
                  SliverPersistentHeader(
                    delegate: ServiceRequestSectionMenu(),
                    pinned: true,
                    floating: false,
                  ),
                  if(ResponsiveHelper.isDesktop(context))
                  SliverToBoxAdapter(child: SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),),
                  if(ResponsiveHelper.isMobile(context))
                  SliverToBoxAdapter(child: SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),),
                  if(_bookingList!.length > 0)
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing:ResponsiveHelper.isDesktop(context) || ResponsiveHelper.isTab(context) ? Dimensions.PADDING_SIZE_EXTRA_LARGE: 2.0,
                      mainAxisExtent: Get.find<LocalizationController>().isLtr  ? 130 : 135,
                    ),

                      delegate: SliverChildBuilderDelegate((context,index){
                          return BookingItemCard(bookingModel: _bookingList.elementAt(index),);},
                          childCount: _bookingList.length,
                        ),
                      ),
                  if(_bookingList.length > 0)
                    SliverToBoxAdapter(child: SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_MORE_LARGE,),),
                  if(_bookingList.length == 0)
                    SliverToBoxAdapter(
                      child: Center(
                        child: SizedBox(height: Get.height * 0.7,
                          child: NoDataScreen(
                              text: 'no_booking_request_available'.tr,
                              type: NoDataType.BOOKING
                          ),
                        ),
                      )
                  )
                ] : [
                  SliverPersistentHeader(
                    delegate: ServiceRequestSectionMenu(),
                    pinned: true,
                    floating: false,
                  ),
                  SliverToBoxAdapter(child: BookingScreenShimmer())],
                controller: serviceBookingController.bookingScreenScrollController,
              );
          },
        ));
  }
  Widget _buildBody({required List<Widget> sliversItems, required ScrollController controller}){
    if(ResponsiveHelper.isWeb()){
      return FooterBaseView(
        // isCenter: true,
        child: SizedBox(
          width: Dimensions.WEB_MAX_WIDTH,
          child: CustomScrollView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            controller: controller,
            slivers: sliversItems,
          ),
        ),
      );
    }else{
     return CustomScrollView(
        controller: controller,
        slivers: sliversItems,
      );
    }
  }
}
