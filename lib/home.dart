import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:flutter/services.dart';
import 'package:mac_address/mac_address.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

var macaddress = '';
var macaddress1 = '';
var mylocation = '';

class HomePage extends StatefulWidget {
  final String? phone;
  const HomePage({Key? key, required this.phone}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getCurrentLocation();
  }

  Future getCurrentLocation() async {
    try {
      Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

      Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      print(position);
      mylocation = position.toString();

      return position;
      // return 'a';
    } catch (err) {
      // print(err.message);
    }
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    macaddress = await GetMac.macAddress;

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      macaddress1 = macaddress;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Platform.isAndroid
              ? 'Android Device ${widget.phone}'
              : Platform.isIOS
                  ? 'iOS Device ${widget.phone}'
                  : '',
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('{$macaddress} $getCurrentLocation(){$macaddress1} '),
            // Expanded(
            //   child: ListView(
            //     children: _deviceData.keys.map(
            //       (String property) {
            //         return Row(
            //           children: <Widget>[
            //             Container(
            //               padding: const EdgeInsets.all(10.0),
            //               child: Text(
            //                 property,
            //                 style: const TextStyle(
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //             ),
            //             Expanded(
            //                 child: Container(
            //               padding:
            //                   const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            //               child: Text(
            //                 '${_deviceData[property]}',
            //                 maxLines: 10,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             )),
            //           ],
            //         );
            //       },
            //     ).toList(),
            //   ),
            // ),

            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    initPlatformState();
                    getCurrentLocation().then((value) {
                      print("aasmom omoas$value");
                      setState(() {
                        mylocation = value;
                      });
                      print('$mylocation');
                    });

                    var alert = AlertDialog(
                      title: Center(child: Text("Confirmation")),
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          children: [
                            Text("My Location is $mylocation"),
                            Text('${_deviceData['device']}'),
                            Text('${_deviceData['brand']}'),
                            Text('${_deviceData['model']}'),
                            Text('${_deviceData['manufacturer']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                ElevatedButton(
                                    onPressed: () {}, child: Text("Confirm")),
                              ],
                            )
                          ],
                        ),
                      ),
                    );

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        });
                  },
                  child: Text('Check IN')),
            ),
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () {
                    initPlatformState();
                    getCurrentLocation().then((value) {
                      print("aasmom omoas$value");
                      setState(() {
                        mylocation = value;
                      });
                      print('$mylocation');
                    });

                    var alert = AlertDialog(
                      title: Center(child: Text("Confirmation")),
                      content: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: Column(
                          children: [
                            Text("My Location is $mylocation"),
                            Text('${_deviceData['device']}'),
                            Text('${_deviceData['brand']}'),
                            Text('${_deviceData['model']}'),
                            Text('${_deviceData['manufacturer']}'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel")),
                                ElevatedButton(
                                    onPressed: () {}, child: Text("Confirm")),
                              ],
                            )
                          ],
                        ),
                      ),
                    );

                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return alert;
                        });
                  },
                  child: Text('Check Out')),
            )
          ],
        ),
      ),
    );
  }
}
