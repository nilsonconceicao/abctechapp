import 'package:abc_tech_app/controller/assists_controller.dart';
import 'package:abc_tech_app/model/assist.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomePage extends GetView<AssistsController> {
  const HomePage({Key? key}) : super(key: key);

  Widget _renderList(List<Assist>? assists) {
    if (assists == null) {
      return Container();
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: assists.length,
        itemBuilder: (context, index) => ListTile(
            selectedColor: Colors.orange,
            selected: controller.isSelected(index),
            onTap: () => controller.selectAssist(index),
            title: Text(assists[index].name)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Teste")),
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(children: const [
                Expanded(
                    child: Text("Os serviços disponíveis são:",
                        textAlign: TextAlign.center)),
              ]),
              Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: controller.getAssistList,
                        child: const Text("Recarregar"))),
              ]),
              controller.obx((state) => _renderList(state),
                  onLoading: const Text("Sem assistências"),
                  onError: (error) => Text(error.toString()))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: controller.finishSelectAssist,
          child: const Icon(Icons.done)),
    );
  }
}
