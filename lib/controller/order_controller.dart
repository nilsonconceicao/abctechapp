import 'package:abc_tech_app/model/assist.dart';
import 'package:abc_tech_app/model/order.dart';
import 'package:abc_tech_app/model/order_location.dart';
import 'package:abc_tech_app/service/geolocation_service.dart';
import 'package:abc_tech_app/service/order_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:developer';

enum OrderState { creating, started, finshed }

class OrderController extends GetxController with StateMixin {
  final GeolocatorServiceInterface _geolocaionService;
  final OrderServiceInterface _orderService;
  final formKey = GlobalKey<FormState>();
  final operatorIdController = TextEditingController();
  final selectedAssists = <Assist>[].obs;
  final screenState = OrderState.creating.obs;
  late Order _order;

  OrderController(this._geolocaionService, this._orderService);

  @override
  void onInit() {
    super.onInit();
    _geolocaionService.start();
  }

  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.success());
  }

  getLocation() {
    _geolocaionService
        .getPosition()
        .then((value) => log(value.toJson().toString()));
  }

  List<int> _assistToList() {
    return selectedAssists.map((element) => element.id).toList();
  }

  finishStartOrder() {
    switch (screenState.value) {
      case OrderState.creating:
        if (operatorIdController.text.isEmpty) {
          Get.snackbar("Error", "Por favor informe o id do operador.");
        } else {
          _geolocaionService.getPosition().then((value) {
            OrderLocation start = OrderLocation(
                latitude: value.latitude,
                longitude: value.longitude,
                dateTime: DateTime.now());
            _order = Order(
                operatorId: int.parse(operatorIdController.text),
                assists: _assistToList(),
                start: start,
                end: null);
          });
          screenState.value = OrderState.started;
        }
        break;
      case OrderState.started:
        change(null, status: RxStatus.loading());
        _geolocaionService.getPosition().then((value) {
          _order.end = OrderLocation(
              latitude: value.latitude,
              longitude: value.longitude,
              dateTime: DateTime.now());
          _createOrder();
        });

        break;
      default:
    }
  }

  void _createOrder() {
    screenState.value = OrderState.finshed;
    _orderService.createOrder(_order).then((value) {
      if (value) {
        Get.snackbar("Sucesso", "Ordem de serviço enviada com sucesso");
      }
      _clearForm();
    }).catchError((error) {
      Get.snackbar("Error", error.toString());
      _clearForm();
    });
  }

  void _clearForm() {
    screenState.value = OrderState.creating;
    selectedAssists.clear();
    operatorIdController.text = "";
    change(null, status: RxStatus.success());
  }

  selectAssists() {
    Get.toNamed("/assists", arguments: selectedAssists);
  }
}
