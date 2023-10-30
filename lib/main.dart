import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool serviceEnabled;
  
  late String longitude = '';
  
  late String latitude = '';

  Future getLocation() async {
    Location location = Location();

    var permissionGranted = await location.hasPermission();
    serviceEnabled = await location.serviceEnabled();

    if (permissionGranted != PermissionStatus.granted || !serviceEnabled) {
      permissionGranted = await location.requestPermission();
      serviceEnabled = await location.requestService();
    } else {
      //print("-----> $serviceEnabled");

      setState(() {
        serviceEnabled = true;
      });
    }

    try {
      final LocationData currentPosition = await location.getLocation();
      setState(() {
        longitude = currentPosition.longitude.toString();
        latitude = currentPosition.latitude.toString();
        //print('latitude=$latitude&longitude=$longitude');
      });
    } on PlatformException catch (_) {
      //print("-----> ${err.code}");
    }
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              longitude,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
             latitude,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
