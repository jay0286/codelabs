// ignore: file_names

// ignore_for_file: file_names
// new
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

import '/constant/constant.dart';
import '../main.dart';

import './paringScreen.dart';


String deviceName ='null';
bool isBluetoothScanning = false;
StreamController<int>? _event4Scan;

StreamSubscription? subIsScanning;
StreamSubscription? subEventScanning;
StreamSubscription? subScanResult;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  Future<bool> disconnectUnintentionalDevice() async {

    _event4Scan= StreamController<int>();

    subIsScanning = FlutterBlue.instance.isScanning.listen((isscanning)  {
      //logger.shout('_isScanning: ${isscanning}');
      if(isscanning==false&&isBluetoothScanning==true){
        _event4Scan?.add(2); //jay  'isScanning'은 StartScan 이후에 listen 등록해도 false가 먼저 1회 오고 start가 즉시오게됨, 단순히 false만 봐서는 scan이 끝났는지 알수없음(초기값이 오류를 발생)
      }
      isBluetoothScanning =isscanning;
    });

    subEventScanning = _event4Scan!.stream.listen((event4Scan) {
      logger.shout('_event4Scan: ${event4Scan}');
      if(event4Scan==1||event4Scan==2) {
        subIsScanning?.cancel();
        subEventScanning!.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ParingScreen(bTdevice: bTdevice, scanevent:event4Scan),
            ));
      }
    });

    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;

    logger.severe('-- BT init : disconectUnintentionalDevice');
    if(connectedDevices.isNotEmpty) {
      if (connectedDevices[0].name.contains('Smart Helmet')) {
        bTdevice=connectedDevices[0];
        logger.warning('found Smart helmet');
        deviceName = bTdevice!.name;
        await bTdevice!.disconnect();
        logger.warning('bTdevice!.disconnect()');
        //await bTdevice!.connect();
        //await connectMyProtocol(bTdevice);
        //return true;
      }
      //디스커넥트 되고 실제 반영될려면..
    }
    await FlutterBlue.instance.startScan(timeout: const Duration(seconds:8));
    subScanResult = FlutterBlue.instance.scanResults.listen((snapshot) async {
      for (ScanResult r in snapshot) {
        logger.shout('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name.contains('Smart Helmet')) {

          subScanResult!.cancel();

          _event4Scan?.add(1);
          bTdevice=r.device;
          //FlutterBlue.instance.stopScan(); 그냥 scan을 await으로 처리함
          await r.device.connect();

          //await connectMyProtocol(r.device);
          break;
        }
      }
    });


    return false;
  }

  @override
  void initState() {
    super.initState();
    logger.shout('SplashScreen Init');
     disconnectUnintentionalDevice();

  }

  @override
  Widget build(BuildContext context) {
    logger.shout('SplashScreen build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/image/helmet.png',
                 width: 100.0,
                 fit: BoxFit.fitWidth,
              ),
              heightSpace,
              /*Text(
                '스마트안전모',
                style: listItemTitleStyle,
              ),*/
              //heightSpace,
              heightSpace,
              const Text('등록된 스마트안전모를 찾는 중...',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  )
                //listItemTitleStyle,
              ),
              heightSpace,
              heightSpace,
              const SpinKitPulse(
                color: Colors.deepPurple,//primaryColor,
                size: 70.0,
              ),
              /*
              StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data!) {
                    return  Column(
                      children:  [
                        const Text('등록된 안전모를 찾는 중...',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            )
                          //listItemTitleStyle,
                        ),
                        heightSpace,
                        heightSpace,
                        const SpinKitPulse(
                          color: Colors.deepPurple,//primaryColor,
                          size: 50.0,
                        ),
                      ],
                    );
                  } else {
                    return Container();/*MaterialApp(
                        home: ParingScreen(bTdevice: bTdevice),
                    );*/
                  }
                },
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
