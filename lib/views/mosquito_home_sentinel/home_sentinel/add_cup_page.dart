

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:desapv3/services/location_map_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class AddCupPage extends StatefulWidget {
  final String localityCaseID;
  const AddCupPage(this.localityCaseID, {super.key});

  @override
  State<AddCupPage> createState() => _AddCupPageState();
}

class _AddCupPageState extends State<AddCupPage> {
  final formKey = GlobalKey<FormState>();
  final logger = Logger();
  LocationServices locationService = LocationServices();

  final _eggCount = TextEditingController();
  final _larvaeCount = TextEditingController();
  // late TextEditingController _gpsX = TextEditingController(text: setCoordX());
  // late TextEditingController _gpsY =
  //     TextEditingController(text: coordY.toString());
  final _status = TextEditingController();

  late String currentLCID;

  Position? currentCupLocation;
  Placemark? currentPreciseCupLocation;

  late double coordX = 0.0;
  late double coordY = 0.0;

  @override
  void initState() {
    super.initState();
    currentLCID = widget.localityCaseID;
  }

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add a Cup'),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.my_location_outlined),
            onPressed: () {
              setCupLocation();
            }),
        body: Form(
          key: formKey,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _eggCount,
                  decoration: const InputDecoration(
                      hintText: "Mosquito Egg Count",
                      labelText: "Mosquito Egg Count"),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                    controller: _larvaeCount,
                    decoration: const InputDecoration(
                        hintText: "Larvae Count", labelText: "Larvae Count"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Flexible(
                    child: TextFormField(
                  controller: _status,
                  readOnly: true,
                  decoration: const InputDecoration(
                      hintText: "Status",
                      labelText: "Status",
                      suffixIcon: Icon(Icons.arrow_drop_down)),
                  onTap: () async {
                    final option = await showMenu<String>(
                        initialValue: '- Select an Option -',
                        context: context,
                        position:
                            const RelativeRect.fromLTRB(100, 100, 100, 100),
                        items: const [
                          PopupMenuItem(
                            value: 'In Use',
                            child: Text('In Use'),
                          ),
                          PopupMenuItem(
                            value: 'Collected',
                            child: Text('Collected'),
                          ),
                          PopupMenuItem(
                            value: 'Broken',
                            child: Text('Broken'),
                          ),
                        ]);

                    if (option != null) {
                      _status.text = option.toString();
                    }
                  },
                )),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                // Flexible(
                //   child: TextFormField(
                //     controller: _gpsX,
                //     decoration: const InputDecoration(
                //         hintText: "Latitude", labelText: "Latitude"),
                //     keyboardType: TextInputType.number,
                //     readOnly: true,
                //   ),
                // ),
                // Flexible(
                //   child: TextFormField(
                //     controller: _gpsY,
                //     decoration: const InputDecoration(
                //         hintText: "Longitude", labelText: "Longitude"),
                //     keyboardType: TextInputType.number,
                //     readOnly: true,
                //   ),
                // ),
                Flexible(child: Text("Coordinate X: ${currentCupLocation?.latitude ?? 'N/A'}\t\t\t\t\t\t"),),
                Flexible(child: Text("Coordinate Y: ${currentCupLocation?.longitude ?? 'N/A'}"),)
              ]),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    dataProvider.addCup(
                        int.parse(_eggCount.text),
                        0,
                        0,
                        int.parse(_larvaeCount.text),
                        _status.text,
                        false,
                        currentLCID);
                    logger.d(const Text("Adding to Firebase"));
                    Navigator.pop(context);
                  },
                  child: const Text("Add Cup"))
            ],
          )),
        ));
  }

  Future<void> setCupLocation() async {
    logger.d("InSetCup");

    Position? newLocation = await locationService.getCurrentLocation();

    setState(() {
      currentCupLocation = newLocation;
      logger.d(currentCupLocation?.latitude);
    });

    await setPreciseCupLocation();
  }

  Future<void> setPreciseCupLocation() async {
    logger.d("InSetCoordinate");

    Placemark? newCoordinates =
        await locationService.getAddress(currentCupLocation!);

    setState(() {
      currentPreciseCupLocation = newCoordinates;
      logger.d(currentPreciseCupLocation?.locality);
    });
  }

  // String setCoordX() {
  //   if (currentCupLocation != null) {
  //     setState(() {
  //       coordX = (currentCupLocation?.latitude)!.toDouble();
  //     });

  //     return coordX.toString();
  //   }

  //   return coordX.toString();
  // }
}
