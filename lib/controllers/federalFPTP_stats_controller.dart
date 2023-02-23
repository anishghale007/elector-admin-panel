import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/models/federal_election.dart';
import 'package:get/get.dart';

class FederalFPTPStatsController extends GetxController {

  final FederalProvider federal = FederalProvider();

  var stats = Future.value(<FederalFPTPStats>[]).obs;

  @override
  void onInit() {
    stats.value = federal.getFederalFPTPStats();
    super.onInit();
  }
}
