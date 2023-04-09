import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';
import 'package:demandium/feature/review/controller/submit_review_controller.dart';

class SelectRating extends StatelessWidget {
  const SelectRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubmitReviewController>(
        builder: (submitReviewController) {
      return Container(
        height: 50.0,
        child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return starWidget(submitReviewController,index);
            }),
      );
    });
  }

  Widget starWidget(SubmitReviewController submitReviewController,int index) {
    return IconButton(
      onPressed: () {
        submitReviewController.selectReview(index+1);
      },
      icon: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image.asset(
          index < submitReviewController.selectedRating ? Images.starFill:Images.starBorder,
          width: 24.0,
          height: 24.0,
        ),
      ),
    );
  }
}
