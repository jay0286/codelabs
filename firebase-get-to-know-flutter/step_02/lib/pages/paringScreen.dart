// ignore: file_names

// ignore_for_file: file_names
// new
import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gtk_flutter/main.dart';
import 'package:provider/provider.dart';

import '/constant/constant.dart';
import '../main.dart';

import './splashScreen.dart';


StreamSubscription? subEventConnecting;
class ParingScreen extends StatefulWidget {
  BluetoothDevice? bTdevice;
  int? scanevent;

  ParingScreen({Key? key, @required this.bTdevice, this.scanevent }) : super(key: key);

  @override
  _ParingScreenState createState() => _ParingScreenState();
}


class _ParingScreenState extends State<ParingScreen> {


  @override
  void initState() {
    super.initState();
    event4Connect= StreamController<int>();
    logger.shout('ParingScreen Init');

    subEventConnecting = event4Connect!.stream.listen((eventconnect) {
      logger.shout('_event4event4Connect: ${eventconnect}');
      if(eventconnect==1) {
        subEventConnecting!.cancel();
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ChangeNotifierProvider(
                  create: (context) => ApplicationState(),
                  builder: (context, _) => HomePage(),//App2(), //
                ),
            ));
      }
    });

    /* jay 1031 로그인 전에 BT 이벤트가 먼저 발생해 BT이벤트가 버려지는 문제로 splash에서 home으로 보내서 home에서 구동하도록 수정함
    if(widget.scanevent ==1) { //등록된 장치가 있어 자동 페어링 되도록.(connect는 splash해서 진행된 후)
      connectMyProtocol(widget.bTdevice);
    }
    else*/
    if(widget.scanevent ==2) { //등록된 자치가 없어 10초 단위로 계속 검색함
      subParingRetry =Timer(
          const Duration(seconds: 10), () =>
          Navigator.push(context,
            MaterialPageRoute(builder: (context) =>
                SplashScreen(),
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.shout('ParingScreen build');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(fixPadding),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              (widget.scanevent ==1)?
              Column(
                children: [
                  Image.asset(
                    'assets/image/helmet.png',
                    width: 100.0,
                    fit: BoxFit.fitWidth,
                  ),
                  heightSpace,
                  heightSpace,
                  Text('등록된 ${widget.bTdevice!.name}를 찾았습니다',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      )
                    //listItemTitleStyle,
                  ),
                   const Text('연결을 시도합니다',
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 16.0,
                      )
                    //listItemTitleStyle,
                  ),
                  heightSpace,
                  const SpinKitPulse(
                    color: Colors.deepPurple,//primaryColor,
                    size: 50.0,
                  ),
                ],
              )
              :(widget.scanevent ==2)?Column(
                children: [
                  heightSpace,
                  const Text('등록된 스마트안전모를 찾을 수 없습니다',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                  const Text('안전모의 상태를 확인해 주세요',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  heightSpace,
                  heightSpace,
                  heightSpace,
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "btn1",
                        onPressed: () =>Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                SplashScreen(),
                            )),
                        /*icon: const Icon(Icons.search,
                            //color: Colors.deepPurple,
                        ),*/
                        label: const Text("내안전모 다시찾기",
                            style: TextStyle(
                              //color: Colors.deepPurple,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            )
                        ),
                        backgroundColor: Colors.deepPurple,
                        hoverColor: Colors.black54,
                        splashColor: Colors.black54,

                      ),
                      FloatingActionButton.extended(
                        heroTag: "btn2",
                        onPressed: () {
                          //subEventScanning!.cancel();
                          //subIsScanning!.cancel();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                FindDevicesScreen(),
                            ));},
                        //icon: const Icon(Icons.add_link),
                        label: const Text("새안전모 등록하기"),
                      ),
                    ],
                  ),
                ],
              ):Column(
                children: const [
                  Text('장치찾기 상태오류 발생',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                      )
                    //listItemTitleStyle,
                  ),
                ],
              ),
              /*
              StreamBuilder<bool>(
                stream: FlutterBlue.instance.isScanning,
                initialData: false,
                builder: (c, snapshot) {
                  if (snapshot.data!) {
                    return  Column(
                      children:  [
                        Text(' 등록된 장치를 찾았습니다',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 18.0,
                            )
                          //listItemTitleStyle,

                        ),
                        heightSpace,
                        SpinKitPulse(
                          color: Colors.deepPurple,//primaryColor,
                          size: 50.0,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        (deviceName=='null')?
                        Text(
                          '등록된 장치 없음',
                          style: listItemTitleStyle,
                        ):Text(
                          '장치를 찾았습니다: ${deviceName}\n자동연결을 시작합니다.',
                          style: listItemTitleStyle,
                        ),
                        heightSpace,
                      ],
                    );
                    /*FloatingActionButton(
                        child: Icon(Icons.search),
                        onPressed: () => FlutterBlue.instance
                            .startScan(timeout: Duration(seconds: 4)));*/
                  }
                },
              ),
      */
            ],
          ),
        ),
      ),
    );
  }
}
