import 'package:get/get.dart';
import 'package:demandium/core/core_export.dart';
import 'package:demandium/feature/review/repo/submit_review_repo.dart';

class SubmitReviewController extends GetxController {
  final SubmitReviewRepo submitReviewRepo ;
  SubmitReviewController({required this.submitReviewRepo});
  final GlobalKey<FormState> submitReviewKey = GlobalKey<FormState>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  int _selectedRating = 5;
  get selectedRating => _selectedRating;

   selectReview(int rating){
    _selectedRating = rating;
    update();
  }

  Future<void> submitReview(ReviewBody reviewBody)async{
    _isLoading = true;
    update();
    Response response =await submitReviewRepo.submitReview(reviewBody: reviewBody);
    if(response.statusCode == 200){
      _isLoading = false;
      Get.back();
      customSnackBar('review_submitted_successfully'.tr,isError: false);

    }
    update();
  }
}