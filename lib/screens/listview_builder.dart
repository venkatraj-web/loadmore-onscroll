import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListviewBuilderScreen extends StatefulWidget {
  const ListviewBuilderScreen({Key? key}) : super(key: key);

  @override
  State<ListviewBuilderScreen> createState() => _ListviewBuilderScreenState();
}

class _ListviewBuilderScreenState extends State<ListviewBuilderScreen> {
  // List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  List<String> items = [];
  final controller = ScrollController();
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();

    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
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
    if(isLoading) return;
    isLoading = true;

    const limit = 24;
    final url = Uri.parse(
        "https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page");
    final response = await http.get(url);
    print(page);

    if (response.statusCode == 200) {
      final List newItems = json.decode(response.body);
      setState(() {
        // items.addAll(['Item A', 'Item B', 'Item C', 'Item D']);
        page++;
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        }

        items.addAll(newItems.map<String>((item) {
          final number = item['id'];
          return "Item - ${number}";
        }).toList());
      });
    }
  }

  Future refresh() async {
    setState(() {
      isLoading =false;
      hasMore = true;
      page = 1;
      items.clear();
    });

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("ListviewBuilderScreen")),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: controller,
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index < items.length) {
              final item = items[index];
              return ListTile(
                title: Text(items[index]),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: hasMore
                      ? const CircularProgressIndicator()
                      : const Text("No More data to Load!"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
