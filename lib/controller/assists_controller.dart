import 'package:abc_tech_app/model/assist.dart';
import 'package:abc_tech_app/service/assist_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class AssistsController extends GetxController with StateMixin<List<Assist>> {
  late AssistService _assistService;
  List<Assist> allAssists = [];
  List<Assist> selectedAssists = [];

  @override
  void onInit() {
    super.onInit();
    _assistService = Get.find<AssistService>();
    getAssistList();
  }

  @override
  void onReady() {
    super.onReady();
    selectedAssists = Get.arguments;
  }

  void finishSelectAssist() {
    Get.back();
  }

  bool isSelected(index) {
    Assist assist = allAssists[index];
    int indexFound =
        selectedAssists.indexWhere((element) => element.id == assist.id);
    if (indexFound == -1) {
      return false;
    }
    return true;
  }

  void selectAssist(int index) {
    Assist assist = allAssists[index];
    int indexFound =
        selectedAssists.indexWhere((element) => element.id == assist.id);
    if (indexFound == -1) {
      selectedAssists.add(assist);
    } else {
      selectedAssists.removeAt(indexFound);
    }
    change(allAssists, status: RxStatus.success());
  }

  void getAssistList() {
    _assistService.getAssists().then((value) {
      allAssists.addAll(value);
      change(value, status: RxStatus.success());
    }).onError((error, stackTrace) {
      change([], status: RxStatus.error(error.toString()));
    });
  }
}
