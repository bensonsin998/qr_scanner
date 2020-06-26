import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

void main() => runApp(new QRScanner());

class QRScanner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: QRScannerHomePage(),
    );
  }
}

class QRScannerHomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _QRScannerHomePage();
}

class _QRScannerHomePage extends State<QRScannerHomePage> {

  final title = 'QR 簽到系統';

  List users = [];
  String time;

  void _getCurrentTime() {
    setState(() {
      String _hour;
      String _minute;
      String _second;

      _hour = '${DateTime.now().hour}';
      _minute = '${DateTime.now().minute}'.length > 1 ? '${DateTime.now().minute}' : '0${DateTime.now().minute}';
      _second = '${DateTime.now().second}'.length > 1 ? '${DateTime.now().second}' : '0${DateTime.now().second}';

      time = _hour + ' : ' + _minute + ' : ' + _second;
    });
  }

  @override
  void initState() {
    time = '${DateTime.now().hour} : ${DateTime.now().minute} : ${DateTime.now().second}';
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  Future scanQRCode() async {
    try {
      String _qrResult = await BarcodeScanner.scan();
      String _userName = _qrResult.substring(0, _qrResult.indexOf('\$'));
      String _userGroup = _qrResult.substring(_qrResult.indexOf('\$'));
      String _signInTime = time;

      Fluttertoast.showToast(
        msg: '歡迎, ' + _userName + ' !!!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );

      users.add(User(_userName, _userGroup, _signInTime));

      setState(() {});
    }
    on Exception catch(e) {
      String _error = '$e';

      Fluttertoast.showToast(
        msg: _error,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );
    }
  }

  void uploadUser() {
    Fluttertoast.showToast(
      msg: '上載中 ...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
    );

    // TODO: Upload List<User> users to file(csv)

    Fluttertoast.showToast(
      msg: '成功 !!!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              time,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          new Expanded(
            child: new ListView.builder(
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                User _user = users[index];

                return Card(
                  child: ListTile(
                    title: Text(_user.userName),
                    subtitle: Text(
                        'Group: ' + _user.userGroup + '\n' +
                            'Time:' + _user.signInTime
                    ),
                    trailing: Icon(Icons.more_vert),
                    onTap: (){
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
            child: FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.file_upload),
              label: Text('上載'),
              onPressed: () {
                uploadUser();
              },
            ),
            alignment: Alignment.bottomRight,
          ),
          SizedBox(
            width: 10.0,
          ),
          Align(
            child: FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.camera_alt),
              label: Text('掃描'),
              onPressed: () {
                scanQRCode();
              },
            ),
            alignment: Alignment.bottomRight,
          ),
        ],
      ),
    );
  }
}

class User {
  String userName;
  String userGroup;
  String signInTime;

  User(this.userName, this.userGroup, this.signInTime);

  @override
  String toString() {
    return '{ ${this.userName}, ${this.userGroup}, ${this.signInTime}}';
  }
}