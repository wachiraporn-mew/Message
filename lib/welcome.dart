import 'dart:convert';

import 'package:FileProcess/add.dart';
import 'package:FileProcess/delete.dart';
import 'package:FileProcess/fileprocess.dart';
import 'package:flutter/material.dart';

import 'delete.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map> dataList = [];

  Future<String> _getFile() async {
    DataFileProcess dataFile = DataFileProcess();
    String dataStr = await dataFile.readData();
    print(dataStr);
    if (dataStr != 'fail' && dataStr != '{}' && dataList.length == 0) {
      var dataJSon;
      if (dataList.length == 0) {
        dataJSon = jsonDecode(dataStr);
        for (var item in dataJSon) {
          Map<String, dynamic> dataMap = {
            'id': item['id'],
            'msg': item['msg'],
          };
          dataList.add(dataMap);
        }
      }
    }

    return 'success';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _getFile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: ListTile(
                      title: Text("${dataList[index]['msg']}"),
                      trailing: Icon(Icons.keyboard_arrow_right),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeleteMessage(
                                    id: dataList[index]['id'],
                                  )));
                    },
                  );
                });
          } else {
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddMessage()));
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
