import 'package:demandium/components/footer_base_view.dart';
import 'package:demandium/components/menu_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class SettingScreen extends StatelessWidget {
   SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer:ResponsiveHelper.isDesktop(context) ? MenuDrawer():null,
      appBar: CustomAppBar(
        isBackButtonExist: true,
        bgColor: Theme.of(context).primaryColor, title: 'settings'.tr,),

      body: FooterBaseView(
        isScrollView:true,
        isCenter:true,
        child: SizedBox(
          width: Dimensions.WEB_MAX_WIDTH,
          child: GridView.builder(
            shrinkWrap: true,
            key: UniqueKey(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: Dimensions.PADDING_SIZE_LARGE ,
              mainAxisSpacing: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_LARGE : Dimensions.PADDING_SIZE_LARGE ,
              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 4 :.99,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : ResponsiveHelper.isTab(context) ? 3 : 2,
            ),
            physics:  NeverScrollableScrollPhysics(),
            itemCount: 2,
            padding: EdgeInsets.only(top:100,right: Dimensions.PADDING_SIZE_DEFAULT,left: Dimensions.PADDING_SIZE_DEFAULT,bottom: Dimensions.PADDING_SIZE_DEFAULT),
            itemBuilder: (context, index) {
              if(index ==  1)
              return InkWell(
                onTap: (){
                  Get.toNamed(RouteHelper.getLanguageScreen('fromSettingsPage'));
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow:Get.isDarkMode ? null: cardShadow,
                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(Images.translate,width: 40,height: 40,),
                            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                            Text('language'.tr,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                          ],
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                      child: Image.asset(Images.editPen,
                        width: Dimensions.EDIT_ICON_SIZE,
                        height: Dimensions.EDIT_ICON_SIZE,
                      ),
                    ),
                  ],
                ),
              );

              return Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow:Get.isDarkMode ? null: cardShadow,
                borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GetBuilder<ThemeController>(builder: (themeController){
                      return CupertinoSwitch(value: themeController.darkTheme, onChanged: (value){
                        themeController.toggleTheme();
                      });
                    }),
                    SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                    Text(Get.isDarkMode ? "light_mode".tr:"dark_mode".tr ,style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                  ],
                ),
              ),);
            },
          ),
        ),
      ),
    );
  }
}
