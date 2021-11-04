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

import 'package:shared_preferences/shared_preferences.dart';


bool isBluetoothScanning = false;
StreamController<int>? event4Scan ;


StreamSubscription? subIsBtState;
StreamSubscription? subIsScanning;
StreamSubscription? subEventScanning;
StreamSubscription? subScanResult;



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String? myLastHelmet;

  Future<Null> loadDevice() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myLastHelmet = await (prefs.getString('lasthelmet') ?? null);
    logger.warning('Get My Helmet name: ${myLastHelmet}');
  }

  Future<void> disconnectDevice( BluetoothDevice?  device ) async {

    //디스커넥트 되고 실제 반영될려면..
    await device!.disconnect();
    logger.warning('Device  ${device.name} is disconnected');
    //await bTdevice!.connect();
    //await connectMyProtocol(bTdevice);
    //return true;
  }

  bool btStateChange=false;

  Future<bool> disconnectUnintentionalDevice(int stateOffset) async {

    logger.severe('-- BT init : disconectUnintentionalDevice');

    await loadDevice();
    await subEventScanning?.cancel();

    subEventScanning = event4Scan!.stream.listen((event4Scan) async {
      logger.shout('event4Scan: ${event4Scan}');
      if (event4Scan == 1) { //등록된 장치를 찾았을 때
        await subIsScanning?.cancel();
        await subEventScanning?.cancel();
        await subScanResult?.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ChangeNotifierProvider(
                  create: (context) => ApplicationState(),
                  builder: (context, _) => HomePage(bTdevice: bTdevice, scanevent: event4Scan),//App2(), //
                ),
            ));
      }
      else if (event4Scan == 2) { // 등록된 장치가 검색되지 않을때
        await subIsScanning?.cancel();
        await subEventScanning!.cancel();
        await subScanResult!.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ParingScreen(bTdevice: bTdevice, scanevent: event4Scan),
            ));
      }
      else if (event4Scan == 3) { //기 등록된 장치가 없을 때
        await subIsScanning?.cancel();
        await subEventScanning!.cancel();
        //subScanResult!.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ChangeNotifierProvider(
                  create: (context) => ApplicationState(),
                  builder: (context, _) => HomePage(),//App2(), //
                ),
            ));
      }
      else if (event4Scan == 1+10 /*10 is stateOffset */) { //등록된 장치를 찾았을 때
        await subIsScanning?.cancel();
        await subEventScanning!.cancel();
        await subScanResult!.cancel();
        await connectMyProtocol(bTdevice!);
      }
      else if (event4Scan == 2+10 /*10 is stateOffset */) { // 등록된 장치가 검색되지 않을때
        Future.delayed(const Duration(seconds: 8), () {
           FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
        });

      }
      else if (event4Scan == 3+10 /*10 is stateOffset */) { //기 등록된 장치가 없을 때 //없는 상황
        await subIsScanning?.cancel();
        await subEventScanning!.cancel();
      }
    });

    if(myLastHelmet==null/*||logState==false 파이어 스토어 동작 이전이라 사용불가*/) {
      event4Scan?.add(3+stateOffset);
      return true;
    }
    else {
      List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;
      subIsScanning = FlutterBlue.instance.isScanning.listen((isscanning) {
        //logger.shout('_isScanning: ${isscanning}');
        if (isscanning == false && isBluetoothScanning == true) {
          event4Scan?.add(2+stateOffset); //jay  'isScanning'은 StartScan 이후에 listen 등록해도 false가 먼저 1회 오고 start가 즉시오게됨, 단순히 false만 봐서는 scan이 끝났는지 알수없음(초기값이 오류를 발생)
        }
        isBluetoothScanning = isscanning;
      });


      if (connectedDevices.isNotEmpty) {
        if (connectedDevices[0].name.contains(myLastHelmet!)) {
          logger.warning('found Smart helmet');
          myLastHelmet = connectedDevices[0].name;
          bTdevice = connectedDevices[0];
          await disconnectDevice(bTdevice);
        }
      }

      await FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
      subScanResult = FlutterBlue.instance.scanResults.listen((snapshot) async {
        for (ScanResult r in snapshot) {
          logger.shout('${r.device.name} found! rssi: ${r.rssi}');
          if (r.device.name.contains(myLastHelmet!)) {
            await subScanResult!.cancel();

            event4Scan?.add(1+stateOffset);
            bTdevice = r.device;
            //FlutterBlue.instance.stopScan(); 그냥 scan을 await으로 처리함
            await r.device.connect();

            //await connectMyProtocol(r.device);
            break;
          }
        }
      });
      return false;
    }
  }


  @override
  void initState() {
    super.initState();
    logger.shout('SplashScreen Init');

    //subIsBtState?.cancel();
    subIsBtState = FlutterBlue.instance.state.listen((btState) async {
      logger.shout('BtState: ${btState}');
      if(btState==BluetoothState.off&&btStateChange ==false){
        btStateChange =true;
      } else if(btState==BluetoothState.on &&btStateChange ==true) {
        await disconnectUnintentionalDevice(10);
        btStateChange =false;
      }
    });
    //event4Scan = StreamController<int>();
    disconnectUnintentionalDevice(0);
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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              const SizedBox(height: 100,),
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
              const SizedBox(height: 100,),
              TextButton(
                  onPressed:(){
                    subIsScanning?.cancel();
                    subEventScanning?.cancel();
                    subScanResult?.cancel();
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ChangeNotifierProvider(
                              create: (context) => ApplicationState(),
                              builder: (context, _) => HomePage(bTdevice: bTdevice, scanevent: 2),//App2(), //
                            ),
                        ));
                  },
                  child: const Text('바로 로그인하기',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 16.0,
                      ),
                  ),
              ),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
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
