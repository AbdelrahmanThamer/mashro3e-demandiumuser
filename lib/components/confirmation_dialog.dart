import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class ConfirmationDialog extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? description;
  final Function()? onYesPressed;
  final bool? isLogOut;
  final Function? onNoPressed;
  final Widget? widget;
  ConfirmationDialog({@required this.icon, this.title, @required this.description, @required this.onYesPressed,
    this.isLogOut = false, this.onNoPressed, this.widget});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(width: 500, child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: widget != null ? widget : Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Image.asset(icon!, width: 50, height: 50),
          ),
          title != null ? Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              title!, textAlign: TextAlign.center,
              style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
            ),
          ):
          SizedBox(),
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: Text(description!, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          GetBuilder<UserController>(builder: (userController){
            return userController.isLoading ? Center(child: CircularProgressIndicator(),): Row(children: [
              Expanded(child: TextButton(
                onPressed: () => isLogOut! ? onYesPressed!() : onNoPressed != null ? onNoPressed!() : Get.back(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize: Size(Dimensions.WEB_MAX_WIDTH, 45), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
                ),
                child: Text(
                  isLogOut! ? 'yes'.tr : 'no'.tr, textAlign: TextAlign.center,
                  style: ubuntuBold.copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
                ),
              )),
              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
              Expanded(child: CustomButton(
                buttonText: isLogOut! ? 'no'.tr : 'yes'.tr,
                fontSize: Dimensions.fontSizeSmall,
                onPressed: () => isLogOut! ? Get.back() : onYesPressed!(),
                radius: Dimensions.RADIUS_SMALL, height: 45,
              )),
            ]);
          },),

        ]),
      )),
    );
  }
}
