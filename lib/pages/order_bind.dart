import 'package:abc_tech_app/controller/order_controller.dart';
import 'package:abc_tech_app/provider/order_provider.dart';
import 'package:abc_tech_app/service/geolocation_service.dart';
import 'package:abc_tech_app/service/order_service.dart';
import 'package:get/instance_manager.dart';

class OrderBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() =>
        OrderController(GeolocaionService(), OrderService(OrderProvider())));
  }
}
