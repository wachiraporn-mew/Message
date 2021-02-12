import 'dart:convert';

import 'package:FileProcess/fileprocess.dart';
import 'package:FileProcess/welcome.dart';
import 'package:flutter/material.dart';

class AddMessage extends StatefulWidget {
  AddMessage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AddMessageState createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  String messageStr = '';

  Future<void> _addMessage() async {
    DataFileProcess dataFile = DataFileProcess();
    List<Map> dataList = [];
    int lastID = 0;

    //Exist data
    String dataStr = await dataFile.readData();
    if (dataStr != 'fail' && dataStr != '{}') {
      var dataJson = jsonDecode(dataStr);
      for (var item in dataJson) {
        Map<String, dynamic> dataMap = {
          'id': item['id'],
          'msg': item['msg'],
        };
        dataList.add(dataMap);
        lastID = int.parse(item['id']);
      }
    }

    //New data
    lastID +=1;
    Map<String, dynamic> dataMap = {
      'id': lastID.toString(),
      'msg': messageStr,
    };

    dataList.add(dataMap);

    var dataJson_new = jsonEncode(dataList);
    dataFile.writeData(dataJson_new.toString());

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'File Process')));
  }

  @override
  Widget build(BuildContext context) {
    TextField _message = TextField(
      decoration: InputDecoration(hintText: 'Enter message'),
      onChanged: (value) {
        messageStr = value;
      },
    );

    RaisedButton _addButton = RaisedButton(
      onPressed: () {
        _addMessage();
      },
      child: Text("Add Message"),
      color: Colors.pink,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Message"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            _message,
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[_addButton],
            ),
          ],
        ),
      ),
    );
  }
}
