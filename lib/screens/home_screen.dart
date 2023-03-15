import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    if (isLoading) return;
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
      isLoading = false;
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
        title: Center(child: Text("Infinite Scroll")),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: GridView.builder(
          padding: EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          controller: controller,
          itemCount: items.length+1,
          itemBuilder: (context, index){
        if (index < items.length) {
          final item = items[index];
          return GestureDetector(
            onTap: () {
              print(item);
            },
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.orange,
              child: GridTile(
                header: Text("Header"+index.toString(), textAlign: TextAlign.center,),
                child: Center(child: Text(item, style: TextStyle(fontWeight: FontWeight.bold),)),
                footer: Text("Footer ${item}", textAlign: TextAlign.center,),
              ),
            ),
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
        // child: ListView.builder(
        //   controller: controller,
        //   itemCount: items.length + 1,
        //   itemBuilder: (context, index) {
        //     if (index < items.length) {
        //       final item = items[index];
        //       return ListTile(
        //         title: Text(items[index]),
        //       );
        //     } else {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 32),
        //         child: Center(
        //           child: hasMore
        //               ? const CircularProgressIndicator()
        //               : const Text("No More data to Load!"),
        //         ),
        //       );
        //     }
        //   },
        // ),
      ),
    );
  }
}
