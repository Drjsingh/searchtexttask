import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String text = "";
  List fileText = [];
  bool click = false;
  TextEditingController search = new TextEditingController();
  Future<String> loadAsset() async {
    fileText.clear();
    text = await DefaultAssetBundle.of(context).loadString('asset/mytext.txt');
    Iterable<String> list = LineSplitter.split(text);
    list.forEach((e) {
      if (e?.isEmpty ?? true) {
        //Do nothing
      } else {
        print("$e");
        fileText.add(e);
        // db.execute(e);
      }
    });
    return text;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  var response = await loadAsset();
                  setState(() {});
                },
                child: Container(
                  color: Colors.red,
                  height: 30,
                  width: 120,
                  margin: EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      "Get Text",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(text),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: TextField(
                  controller: search,
                  decoration: new InputDecoration(
                    hintText: "Serach Anything from above paragraph",
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (search.text.length > 0) {
                    setState(() {
                      click = true;
                    });
                  }
                },
                child: Container(
                  color: Colors.red,
                  height: 30,
                  width: 120,
                  child: Center(
                    child: Text(
                      "Click for Result",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: click,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  margin: EdgeInsets.all(20),
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10),
                    itemCount: fileText.length > 0 ? fileText.length : 0,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(top: 8),
                        child: (() {
                          if (fileText[index]
                              .toLowerCase()
                              .contains(search.text.toLowerCase())) {
                            return Text(fileText[index]);
                          }
                        }()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
