import 'package:demandium/data/provider/client_api.dart';
import 'package:demandium/feature/notification/repository/notification_repo.dart';
import 'package:demandium/utils/app_constants.dart';

class WebLandingRepo {
  final ApiClient apiClient;

  WebLandingRepo({required this.apiClient});

  Future<Response> getWebLandingContents() async {
    Map<String, String> mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.ZONE_ID: 'configuration',
    };
    return await apiClient.getData('${AppConstants.WEB_LANDING_CONTENTS}',headers:mainHeaders );
  }

}