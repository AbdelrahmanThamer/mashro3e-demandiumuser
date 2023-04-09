import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';

class ServiceSchedule extends GetView<ScheduleController> {
  ServiceSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleController>(
      init: controller,
      builder: (scheduleController){
        return  Column(
          children: [
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
            Text("service_schedule".tr, style: ubuntuMedium.copyWith(fontSize: Dimensions.fontSizeDefault)),
            SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
            Container(
              height: 70,
              padding:  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              width: Get.width,
              color: Theme.of(context).hoverColor,
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${DateConverter.stringToLocalDateOnly(scheduleController.selectedData.toString())}"),
                            ],
                          ),
                          const SizedBox(
                            width: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            width: Dimensions.PADDING_SIZE_DEFAULT,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateConverter.dateToWeek(scheduleController.selectedData),
                                style: ubuntuBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                              Text(
                                DateConverter.dateToTimeOnly(scheduleController.selectedData),
                                style: ubuntuRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                        onTap: (){
                          scheduleController.selectDate();
                        },
                        child: Image.asset(Images.editButton,width: 20.0,height: 20.0,)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          ],
        );
      },
    );
  }
}
