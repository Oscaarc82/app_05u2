import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MenuItem {
  final String name;
  final String image;
  final String description;
  final String example;

  MenuItem({
    required this.name,
    required this.image,
    required this.description,
    required this.example
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      image: json['image'],
      description: json['description'],
      example: json['example']
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuItem> menuItems = [];

  @override
  void initState() {
    super.initState();
    loadMenuItems();
  }

  Future<void> loadMenuItems() async {
    String data =
        await DefaultAssetBundle.of(context).loadString('./data.json');
    List<dynamic> jsonList = json.decode(data);
    List<MenuItem> items = [];

    for (var item in jsonList) {
      items.add(MenuItem.fromJson(item));
    }

    setState(() {
      menuItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailScreen(menuItem: menuItems[index]),
                ),
              );
            },
            child: ListTile(
                title: Text(
              menuItems[index].name,
              textAlign: TextAlign.center,
            )),
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final MenuItem menuItem;

  DetailScreen({required this.menuItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(menuItem.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              menuItem.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(
              menuItem.image,
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20),
            Text(
              menuItem.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Container(
              width: 200, // Ancho del recuadro
              height: 50, // Alto del recuadro
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black), // Borde del recuadro
              ),
              child: Center(
                child: Text(
                  menuItem.example,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
