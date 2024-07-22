import 'package:flutter/material.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter HR System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AMapFlutterLocation _locationPlugin = AMapFlutterLocation();
  String _location = '未知';
  String _checkInTime = '';

  @override
  void initState() {
    super.initState();
    AMapFlutterLocation.setApiKey(
      'cdd201c7d454f2feb0110eda8d9f89fd',
      'e15dd99222862d7e04063c7dae351a3e',
    );
    _locationPlugin.setLocationOption(AMapLocationOption());
    _requestPermission();
  }

  void _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // 权限已获得
    } else {
      // 权限被拒绝
    }
  }

  void _startLocation() {
    _locationPlugin.startLocation();
    _locationPlugin.onLocationChanged().listen((result) {
      setState(() {
        _location = '${result['latitude']}, ${result['longitude']}';
        _checkInTime = DateTime.now().toString();
      });
      _locationPlugin.stopLocation();
    });
  }

  @override
  void dispose() {
    _locationPlugin.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HR System'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('当前定位: $_location'),
            Text('打卡时间: $_checkInTime'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startLocation,
              child: Text('打卡'),
            ),
          ],
        ),
      ),
    );
  }
}
