import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationData? notificationModel;
  NotificationDialog({@required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Get.isDarkMode?Theme.of(context).primaryColorDark:null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child:  SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Container(
                height: 150, width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor.withOpacity(0.20)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.content!.imageBaseUrl}''/push-notification/${notificationModel!.coverImage}',
                    height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Text(
                  notificationModel!.title!,
                  textAlign: TextAlign.center,
                  style: ubuntuMedium.copyWith(
                    color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(.6),
                    fontSize: Dimensions.fontSizeExtraLarge,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Text(
                  notificationModel!.description!,
                  textAlign: TextAlign.justify,
                  style: ubuntuRegular.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
