import 'package:desapv3/controllers/navigation_link.dart';
import 'package:desapv3/controllers/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class SentinelInfoPage extends StatefulWidget {
  final String localityCaseID;
  const SentinelInfoPage(this.localityCaseID, {super.key});

  @override
  State<SentinelInfoPage> createState() => _SentinelInfoPageState();
}

class _SentinelInfoPageState extends State<SentinelInfoPage> {
  final logger = Logger();
  late String currentLocalityCaseID;

  @override
  initState() {
    super.initState();
    currentLocalityCaseID = widget.localityCaseID;
    logger.d(currentLocalityCaseID);
  }

  String active = "none";

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);
    return Scaffold(
        floatingActionButton: SpeedDial(
          activeIcon: Icons.close,
          iconTheme: const IconThemeData(color: Colors.white),
          buttonSize: const Size(50, 50),
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.add,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Add Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  Navigator.pushNamed(context, addCupRoute,
                      arguments: currentLocalityCaseID);
                }),
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.edit,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Edit Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  setState(() {
                    active = active == "edit" ? "none" : "edit";
                  });
                }),
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Delete Cup"),
                backgroundColor: Colors.white70,
                onTap: () {
                  setState(() {
                    active = active == "delete" ? "none" : "delete";
                  });
                }),
            SpeedDialChild(
                elevation: 0,
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.blue,
                ),
                labelWidget: const Text("Generate Cup QRCode"),
                backgroundColor: Colors.white70,
                onTap: () {
                  setState(() {
                    active = active == "generateQR" ? "none" : "generateQR";
                  });
                }),
          ],
          child: const Icon(Icons.more, color: Colors.white),
        ),
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 25, child: Text("Sentinel Info")),
              Flexible(
                child: FutureBuilder(
                  future: dataProvider.fetchCups(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    final cups = dataProvider.cupList
                        .where((cup) =>
                            cup.localityCaseID == currentLocalityCaseID)
                        .toList();

                    return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cups.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: active != 'none'
                                ? Row(
                                    mainAxisSize: MainAxisSize
                                        .min, // Ensures the row doesn't take excessive space
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (active == 'edit') {
                                            Navigator.pushNamed(
                                              context,
                                              editOvitrapRoute,
                                              arguments: EditCupArguments(
                                                  cups[index]),
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.edit,
                                            color: Colors.blue),
                                        tooltip: "Edit",
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (active == 'delete') {
                                            dataProvider.deleteCup(cups[index]);
                                          }
                                        },
                                        icon: const Icon(Icons.delete,
                                            color: Colors.blue),
                                        tooltip: "Delete",
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          logger.d("In QR");
                                            Navigator.pushNamed(
                                              context,
                                              qrCodeGeneratorRoute,
                                              arguments: QrCodeGenArguments(
                                                  cups[index].cupID, index),
                                            );
                                        },
                                        icon: const Icon(Icons.qr_code,
                                            color: Colors.blue),
                                        tooltip: "Generate QR Code",
                                      ),
                                    ],
                                  )
                                : null,
                            title: Text(cups[index].cupID!),
                            subtitle: Text(
                              "Mosquito Egg Count: ${cups[index].eggCount}\nCoordinate X: ${cups[index].gpsX}\t\t\t\t\tCoordinate Y: ${cups[index].gpsY}\nLarvae Count: ${cups[index].larvaeCount}\nCup Status: ${cups[index].status}",
                            ),
                          );
                        });
                  },
                ),
              )
            ],
          ),
        ));
  }
}