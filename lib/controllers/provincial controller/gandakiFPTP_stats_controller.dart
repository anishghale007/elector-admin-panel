import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandaki_provider.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:get/get.dart';

class GandakiFPTPStatsController extends GetxController {

  final GandakiProvider provincial = GandakiProvider();

  var stats = Future.value(<ProvincialFPTPStats>[]).obs;

  @override
  void onInit() {
    stats.value = provincial.getProvincialFPTPStats();
    super.onInit();
  }
}
