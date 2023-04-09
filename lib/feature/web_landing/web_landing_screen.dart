import 'dart:async';
import 'package:demandium/components/custom_image.dart';
import 'package:demandium/components/footer_base_view.dart';
import 'package:demandium/controller/localization_controller.dart';
import 'package:demandium/core/helper/route_helper.dart';
import 'package:demandium/data/model/response/config_model.dart';
import 'package:demandium/feature/location/widget/registration_card.dart';
import 'package:demandium/feature/splash/controller/splash_controller.dart';
import 'package:demandium/feature/web_landing/controller/web_landing_controller.dart';
import 'package:demandium/feature/web_landing/model/web_landing_model.dart';
import 'package:demandium/feature/web_landing/repository/web_landing_repo.dart';
import 'package:demandium/feature/web_landing/widget/web_landing_search_box.dart';
import 'package:demandium/utils/dimensions.dart';
import 'package:demandium/utils/images.dart';
import 'package:demandium/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebLandingPage extends StatefulWidget {
  final bool? fromSignUp;
  final bool? fromHome;
  final String? route;

  const WebLandingPage({Key? key, required this.fromSignUp, required this.fromHome, required this.route}) : super(key: key);

  @override
  State<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends State<WebLandingPage> {
  PageController _pageController = PageController();
  ConfigModel? _config = Get.find<SplashController>().configModel;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    Get.find<WebLandingController>().getWebLandingContent();
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => WebLandingController( WebLandingRepo( apiClient: Get.find())));
    String baseUrl = Get.find<SplashController>().configModel.content!.imageBaseUrl!;
    bool isLtr = Get.find<LocalizationController>().isLtr;
    return GetBuilder<WebLandingController>(
      initState: (state){
        Get.find<WebLandingController>().getWebLandingContent();
      },
      builder: (webLandingController){
        if(webLandingController.webLandingContent != null){
          var textContent = Map.fromIterable(webLandingController.webLandingContent!.textContent!, key: (e) => e.keyName, value: (e) => e.liveValues);
          var imageContent = Map.fromIterable(webLandingController.webLandingContent!.imageContent!, key: (e) => e.keyName, value: (e) => e.liveValues);


          return FooterBaseView(
            bottomPadding: false,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                  WebLandingSearchSection(baseUrl: baseUrl,textContent: textContent,fromSignUp:widget.fromSignUp,route: widget.route,),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_MORE_LARGE),
                  Container(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textContent['web_mid_title'],
                          style: ubuntuBold.copyWith(fontSize: 26,),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(imageContent["feature_section_image"] != null)
                            CustomImage(
                              height: Dimensions.FEATURE_SECTION_IMAGE_SIZE,
                              width: Dimensions.FEATURE_SECTION_IMAGE_SIZE,
                              image:"$baseUrl/landing-page/web/${imageContent['feature_section_image']}",
                              fit: BoxFit.fitHeight,
                            ),
                            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                            Expanded(
                              child: Column(
                                children: [
                                  selectLocationPickServicePlaceBookContent(textContent['mid_sub_title_1'],textContent['mid_sub_description_1']),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                                  selectLocationPickServicePlaceBookContent(textContent['mid_sub_title_2'],textContent['mid_sub_description_2']),
                                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
                                  selectLocationPickServicePlaceBookContent(textContent['mid_sub_title_3'],textContent['mid_sub_description_3']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_MORE_LARGE),
                  Container(
                    color: Theme.of(context).hoverColor,
                    height: Dimensions.WEB_LANDING_TESTIMONIAL_HEIGHT,
                    width: Get.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: Dimensions.WEB_MAX_WIDTH,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                              child: InkWell(
                                onTap: () => _pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                child: Container(

                                  padding: EdgeInsets.symmetric(horizontal: 5),


                                  height: Dimensions.WEB_LANDING_ICON_CONTAINER_HEIGHT, width: Dimensions.WEB_LANDING_ICON_CONTAINER_HEIGHT, alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(0.15),
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.only(
                                      left: isLtr ?  Dimensions.PADDING_SIZE_SMALL : 0.0,
                                      right: !isLtr ?  Dimensions.PADDING_SIZE_SMALL : 0.0,
                                    ),
                                    child: Icon(
                                        Icons.arrow_back_ios,
                                        size: Dimensions.WEB_ARROW_SIZE,
                                        color:webLandingController.currentPage! > 0? Theme.of(context).colorScheme.primary :Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.8)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: webLandingController.webLandingContent!.testimonial!.length,
                                      itemBuilder: (context, index) {
                                        Testimonial testimonial =  webLandingController.webLandingContent!.testimonial!.elementAt(index);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${textContent['testimonial_title']}",
                                                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeOverLarge), textAlign: TextAlign.center,
                                                      ),
                                                      SizedBox(height: 70,),
                                                      Container(
                                                          width: Get.width / 4,
                                                          child: Text("${testimonial.review!}",style: ubuntuMedium.copyWith(
                                                            fontStyle: FontStyle.italic,
                                                              fontSize: Dimensions.fontSizeDefault),)),
                                                      SizedBox(height: 24,),
                                                      Text(
                                                        "- ${testimonial.name!}",
                                                        style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeDefault), textAlign: TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                  CustomImage(
                                                    image: "$baseUrl/landing-page/${testimonial.image}",
                                                    height: 214, width:214,
                                                  ),
                                                ],
                                              ),
                                              Text("${index+1}/${webLandingController.webLandingContent!.testimonial!.length}")
                                            ],
                                          ),
                                        );
                                      },
                                      onPageChanged: (int index){
                                        webLandingController.setPageIndex(index);
                                      },

                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                              child: InkWell(
                                onTap: () => _pageController.nextPage(duration: Duration(seconds: 1), curve: Curves.easeInOut),
                                child: Container(
                                  height: Dimensions.WEB_LANDING_ICON_CONTAINER_HEIGHT, width: Dimensions.WEB_LANDING_ICON_CONTAINER_HEIGHT, alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.withOpacity(0.15),
                                  ),
                                  child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: Dimensions.WEB_ARROW_SIZE,
                                      color:webLandingController.currentPage!+1 < webLandingController.webLandingContent!.testimonial!.length
                                          ? Theme.of(context).colorScheme.primary :Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.8)
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_MORE_LARGE),
                  _config!.content!.providerSelfRegistration == '1'
                      ? RegistrationCard(isStore: true)
                      : SizedBox(),
                  SizedBox(height: _config!.content!.providerSelfRegistration == '1' ? 40 : 0),
                  Container(
                    height: 570.0,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: Dimensions.WEB_MAX_WIDTH,
                        child: Row(
                          mainAxisAlignment: _config!.content!.appUrlAndroid == null && _config!.content!.appUrlIos == null
                              ? MainAxisAlignment.center
                              :MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //download section image
                            CustomImage(
                              height: Dimensions.WEB_LANDING_DOWNLOAD_IMAGE_HEIGHT,
                              width:  Dimensions.WEB_LANDING_DOWNLOAD_IMAGE_HEIGHT,
                              image: "$baseUrl/landing-page/web/${imageContent['download_section_image']}",
                              fit: BoxFit.fitHeight,
                            ),
                            //download app section
                            if(imageContent.isNotEmpty &&( _config!.content!.appUrlAndroid != null || _config!.content!.appUrlIos != null)) Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(width: 50,height: 2,color:Get.isDarkMode ?Colors.white:Colors.black),
                                    SizedBox(width: 8.0,),
                                    Text(textContent['download_section_title'], textAlign: TextAlign.center, style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),
                                  ],
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                Text(
                                 textContent['download_section_description'],
                                  textAlign: TextAlign.center,
                                  style: ubuntuRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                                  Row(
                                  children: [
                                   if( _config!.content!.appUrlAndroid != null)
                                    InkWell(
                                      onTap: () async {
                                        if(await canLaunchUrlString(_config!.content!.appUrlAndroid!)) {launchUrlString(_config!.content!.appUrlAndroid!);
                                        }},
                                      child: Image.asset(Images.playStoreIcon, height: 45),
                                    ) ,

                                    SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),

                                    if(_config!.content!.appUrlIos != null )

                                      InkWell(
                                      onTap: () async {
                                        if(await canLaunchUrlString(_config!.content!.appUrlIos!))
                                          launchUrlString(_config!.content!.appUrlIos!);},
                                      child: Image.asset(Images.appStoreIcon, height: 45),)

                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: Dimensions.WEB_LANDING_CONTACT_US_HEIGHT,
                    decoration: BoxDecoration(
                      color: Get.isDarkMode?Colors.grey.withOpacity(0.1):Theme.of(context).primaryColorLight,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: Dimensions.WEB_MAX_WIDTH,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(textContent['web_bottom_title'],style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                                Container(
                                  child: Row(
                                    children: [
                                      liveChatButton(
                                          context,
                                          'chat'.tr,
                                          Icons.message,
                                          false,
                                      ),
                                      SizedBox(width:Dimensions.PADDING_SIZE_DEFAULT),
                                      liveChatButton(
                                          context,
                                          Get.find<SplashController>().configModel.content!.businessPhone!,
                                          Icons.call,
                                          true,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right:Get.find<LocalizationController>().isLtr ? Get.width/7 : null,
                          left:Get.find<LocalizationController>().isLtr ?null: Get.width / 7,
                          top: - 65.0,
                          child: CustomImage(image: "$baseUrl/landing-page/web/${imageContent['support_section_image']}",
                            fit: BoxFit.cover,
                            width: Dimensions.SUPPORT_LOGO_WIDTH,height:  Dimensions.SUPPORT_LOGO_HEIGHT,),
                        ),
                      ],
                    ),
                  ),
                ],),
            ),
          );
        }else{
          return SizedBox();
        }
      },
    );
  }
  selectLocationPickServicePlaceBookContent(String title,String subTitle){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, textAlign: TextAlign.center,
          style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
        Text(
          subTitle, textAlign: TextAlign.start,
          style: ubuntuRegular.copyWith(
              color: Theme.of(context).disabledColor,
              fontSize: Dimensions.fontSizeSmall
          ),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
      ],
    );
  }
  liveChatButton(context,String title,IconData iconData,bool isBorderActive){
    final Uri launchUri =  Uri(
      scheme: 'tel',
      path: Get.find<SplashController>().configModel.content!.businessPhone.toString(),
    );
    return ElevatedButton(
      onPressed: () async{
        if(!isBorderActive){
          Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
        }else{
          await launchUrl(launchUri,mode: LaunchMode.externalApplication);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:isBorderActive ? Colors.transparent : Theme.of(context).colorScheme.primary,
        side: BorderSide(color:Theme.of(context).colorScheme.primary),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius:const BorderRadius.all(Radius.circular(Dimensions.RADIUS_DEFAULT)
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(iconData,color: isBorderActive ? Theme.of(context).colorScheme.primary : Theme.of(context).primaryColorLight),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
            Text(title,style: ubuntuRegular.copyWith(color:isBorderActive ? Theme.of(context).colorScheme.primary :
            Theme.of(context).primaryColorLight ))
          ],
        ),
      ),
    );
  }
}
class CustomPath extends CustomClipper<Path> {
  final bool? isRtl;
  CustomPath({required this.isRtl});

  @override
  Path getClip(Size size) {
    final path = Path();
    if(isRtl!) {
      path..moveTo(0, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width*0.7, 0)
        ..lineTo(0, 0)
        ..close();
    }else {
      path..moveTo(0, size.height)
        ..lineTo(size.width*0.3, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..close();
    }
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}


