import 'package:flutter/material.dart';

class LoadmoreTest extends StatefulWidget {
  const LoadmoreTest({Key? key}) : super(key: key);

  @override
  State<LoadmoreTest> createState() => _LoadmoreTestState();
}

class _LoadmoreTestState extends State<LoadmoreTest> {
  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  final controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller.addListener(() {
      if(controller.position.maxScrollExtent == controller.offset){
        fetch();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  Future fetch() async {
    setState(() {
      items.addAll(['Item A','Item B','Item C','Item D']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Infinite Scroll Loadmore Test Working")),
      ),
      body: ListView.builder(
        controller: controller,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index < items.length) {
            final item = items[index];
            return ListTile(
              title: Text(items[index]),
            );
          } else {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
