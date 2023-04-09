import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class SplashScreen extends StatefulWidget {
  final String? bookingID;
  SplashScreen({@required this.bookingID});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    Get.find<CartController>().getCartData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(Duration(seconds: 1), () async {
          double _minimumVersion = 1.0;
          if(GetPlatform.isAndroid && Get.find<SplashController>().configModel.content!.minimumVersion!=null) {
            _minimumVersion = double.parse(Get.find<SplashController>().configModel.content!.minimumVersion!.minVersionForAndroid!.toString());
          }else if(GetPlatform.isIOS && Get.find<SplashController>().configModel.content!.minimumVersion!=null) {
            _minimumVersion = double.parse(Get.find<SplashController>().configModel.content!.minimumVersion!.minVersionForIos!.toString());
          }
          if(AppConstants.APP_VERSION < _minimumVersion) {
            Get.offNamed(RouteHelper.getUpdateRoute(AppConstants.APP_VERSION < _minimumVersion));
          }else {
            if(widget.bookingID != null) {
              Get.offNamed(RouteHelper.getBookingDetailsScreen(widget.bookingID!,'fromNotification'));

            }else {
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                if (Get.find<LocationController>().getUserAddress() != null) {

                  Get.offNamed(RouteHelper.getInitialRoute());
                } else {
                  Get.offNamed(RouteHelper.getAccessLocationRoute('splash'));
                }
              } else {
                if(!Get.find<SplashController>().isSplashSeen()){
                  Get.offNamed(RouteHelper.getLanguageScreen('fromOthers'));
                }else{
                  Get.offNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
                }
              }
            }
          }
        });
      }else{

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        PriceConverter.getCurrency();
        return Center(
          child: splashController.hasConnection ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.logo,
                width: Dimensions.LOGO_SIZE,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            ],
          ) : NoInternetScreen(child: SplashScreen(bookingID: widget.bookingID)),
        );
      }),
    );
  }
}
