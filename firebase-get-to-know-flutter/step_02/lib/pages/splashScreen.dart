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

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future<void> connectMyProtocol(BluetoothDevice? device) async {
    //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    //final SharedPreferences prefs = await _prefs;

    if(device == null) { logger.warning('connectMyProtocol null return'); return;}

    logger.warning('connectMyProtocol go on');
    //List<BluetoothService> services = await device.discoverServices();
    // CODE DOES NOT
    notistate?.cancel();
    notistate= device.state.listen((bstate) {
      logger.severe('device.state: {$bstate}');
      if (bstate == BluetoothDeviceState.connected)  {

        //prefs.setString('lasthelmet', device.name);
        //logger.shout(prefs.getInt('lasthelmet'));

        device.discoverServices().then((services) {
          //services = dservice;
          for(BluetoothService service in services) {
            if(service.uuid.toString().contains('6e400001') )
            {
              // Reads all characteristics
              var characteristics = service.characteristics;
              for(BluetoothCharacteristic c in characteristics) {
                if (c.uuid.toString().contains('6e400002'))
                {
                  logger.warning('get characteristic 4 belt status');
                  //writecharacteristic = c;
                }

                if(c.descriptors.isNotEmpty) {
                  c.setNotifyValue(true);
                  noti?.cancel();
                  noti= c.value.listen((value) {
                    String state='이상없음';
                    //_stopSound();
                    String btMessage = ascii.decode(value).toString();
                    logger.warning('------------- Notify Listen -----------------');
                    logger.warning('listenMsg: '+ btMessage.toString());
                    if(btMessage.contains('BAT')){
                      int adcBatt = int.parse(btMessage.substring(btMessage.lastIndexOf(",")+1));

                      if(adcBatt>2100) {
                        //_timer_bat?.cancel();
                        //_timer_bat = Timer.periodic(const Duration(seconds: 60), (timer) {
                          //writecharacteristic.write(utf8.encode('req bat'));
                       // });
                      }

                      if(adcBatt>3006)
                        adcBatt = 3006;
                      else if(adcBatt<2300)
                        adcBatt = 2300;
                      setState(() {
                        //batteryPercent =(((adcBatt-2300)/(3006-2300))*100);
                      });

                    }
                    else if((btMessage.contains('Belt Connected')||btMessage.toString().contains('Belt Alive'))&&beltState==false) {
                      state = '턱끈연결';
                      beltState = true;
                      //_setAsset('assets/audio/conBelt.mp3');
                      //_setLoopMode(LoopMode.off);

                      logger.warning('Notify beltstate T: ${iuserId}, ${attendees}');
                      setMyBeltState(iuserId,3, ++attendees);
                      // setAccidentIncrease(iuserId, attendees); //jay set my bel state 함수 안으로 이동
                    }
                    else if(btMessage.contains('Belt Disconnected')&&beltState==true) {
                      state = '턱끈해제';
                      beltState = false;
                      //_setAsset('assets/audio/belt0.mp3');
                      //_setLoopMode(LoopMode.off);

                      logger.warning('Notify beltstate F: ${iuserId}, ${attendees}');
                      setMyBeltState(iuserId, 1 , 0);
                    }
                    else if(btMessage.contains('EM')) {
                      state = '위급상황';
                      //_setAsset('assets/audio/alram1.mp3');
                     // _setLoopMode(LoopMode.one);
                    }
                    else if(btMessage.contains('IA')) {
                      state = '무활동반응';
                     // _setAsset('assets/audio/alram1.mp3');
                      //_setLoopMode(LoopMode.one);
                    }
                    else if(btMessage.contains('FF')) {
                      state = '추락사고';
                     // _setAsset('assets/audio/alram1.mp3');
                    //  _setLoopMode(LoopMode.one);
                    }
                    else if(btMessage.contains('IM')) {
                      state = '충격사고';
                     // _setAsset('assets/audio/alram1.mp3');
                     // _setLoopMode(LoopMode.one);
                    }


                    if(/*_counter==0&& */state!='이상없음'){
                      //_stopSound();
                     // _playSound();
                      addStateToGuestBook(state);

                      if(state!='턱끈연결'&&state!='턱끈해제') {
                      //  if(_events!=null) {
                     //     _events?.close();
                     //   }
                       // _events = StreamController<int>();
                      //  _events?.add(60);
                        //alertD(context, state);

                        /*  if(state=='위급상황') {
                          alertD(context, state);
                        }
                        else {
                          newAlertD(context, displayName,  geolatitude.toString()+ ', ' +geolongitude.toString(), state);
                        }*/
                      }
                    }
                    logger.warning('------------- End of listenB('+state+') -------------');
                  });
                }
              }
            }
          }
        });
      }
    });
    logger.warning('end');
  }


  Future<bool> disconnectUnintentionalDevice() async {
    List<BluetoothDevice> connectedDevices = await flutterBlue.connectedDevices;

    logger.severe('disconectUnintentionalDevice');
    if(connectedDevices.isNotEmpty) {
      if (connectedDevices[0].name.contains('Smart Helmet')) {
        bTdevice=connectedDevices[0];
        logger.warning('find Smart helmet');
        await connectedDevices[0].connect();
        //await connectMyProtocol(connectedDevices[0]);
        return true;
      }
      //디스커넥트 되고 실제 반영될려면..
    }
    await FlutterBlue.instance.startScan(timeout: const Duration(seconds:2));
    FlutterBlue.instance.scanResults.listen((snapshot) async {
      for (ScanResult r in snapshot) {
        logger.shout('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name.contains('Smart Helmet')) {
          bTdevice=r.device;
          //FlutterBlue.instance.stopScan(); 그냥 scan을 await으로 처리함
          await r.device.connect();
          //connectMyProtocol(r.device);
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

    Timer(const Duration(seconds:4), () => Navigator.push(context,
      MaterialPageRoute(builder: (context) =>
        ChangeNotifierProvider(
            create: (context) => ApplicationState(),
            builder: (context, _) => HomePage(),//App2(), //
          ),
      ),
    ));
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
              Text(
                '스마트안전모',
                style: listItemTitleStyle,
              ),
              heightSpace,
              heightSpace,
              StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data!) {
                    return  Column(
                      children: [
                        Text(
                          '장치 찾는 중...',
                          style: listItemTitleStyle,
                        ),
                        const SpinKitPulse(
                          color: Colors.deepPurple,//primaryColor,
                          size: 50.0,
                        ),
                      ],
                    );
                  } else {
                    return FloatingActionButton(
                        child: Icon(Icons.search),
                        onPressed: () => FlutterBlue.instance
                            .startScan(timeout: Duration(seconds: 4)));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
