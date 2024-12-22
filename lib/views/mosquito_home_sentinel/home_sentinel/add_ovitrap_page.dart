import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desapv3/controllers/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AddOvitrapPage extends StatefulWidget {
  const AddOvitrapPage({super.key});

  @override
  State<AddOvitrapPage> createState() => _AddOvitrapPageState();
}

class _AddOvitrapPageState extends State<AddOvitrapPage> {
  final formKey = GlobalKey<FormState>();

  final logger = Logger();

  final _location = TextEditingController();
  final _member = TextEditingController();
  final _status = TextEditingController();
  final _epiWeekInstl = TextEditingController();
  final _epiWeekRmv = TextEditingController();

  late DateTime _instlDateTime;
  late DateTime _removeDateTime;

  late final Timestamp _instlTime = Timestamp.fromDate(_instlDateTime);
  late final Timestamp _removeTime = Timestamp.fromDate(_removeDateTime);

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataController>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add An Ovitrap'),
        ),
        body: Form(
          key: formKey,
          child: Center(
              child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(hintText: "Location"),
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Flexible(
                  child: TextFormField(
                    controller: _member,
                    decoration: const InputDecoration(hintText: "Member"),
                  ),
                ),
                Flexible(
                    child: TextFormField(
                      controller: _status,
                      decoration: const InputDecoration(hintText: "Status"),
                    )),
              ]),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Flexible(
                  child: TextFormField(
                      controller: _epiWeekInstl,
                      decoration:
                          const InputDecoration(hintText: "Epi Week Install"),
                      keyboardType: TextInputType.number),
                ),
                Flexible(
                  child: TextFormField(
                      controller: _epiWeekRmv,
                      decoration:
                          const InputDecoration(hintText: "Epi Week Remove"),
                      keyboardType: TextInputType.number),
                ),
              ]),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  timeHintText: 'Install Time',
                  dateHintText: 'Install Date',
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2500),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  onChanged: (val) => (setState(() {
                    _instlDateTime = DateTime.tryParse(val)!;

                    logger.d(_instlDateTime);
                  })),
                  validator: (val) {
                    logger.d(val);
                    return null;
                  },
                  onSaved: (val) => logger.d(val),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimePicker(
                  type: DateTimePickerType.dateTimeSeparate,
                  timeHintText: 'Removal Time',
                  dateHintText: 'Removal Date',
                  dateMask: 'd MMM, yyyy',
                  initialValue: DateTime.now().toString(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2500),
                  dateLabelText: 'Date',
                  timeLabelText: "Hour",
                  onChanged: (val) => (setState(() {
                    _removeDateTime = DateTime.tryParse(val)!;

                    logger.d(_removeDateTime);
                  })),
                  validator: (val) {
                    logger.d(val);
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    dataProvider.addLocalityCase(
                        _location.text,
                        _member.text,
                        _status.text,
                        int.parse(_epiWeekInstl.text),
                        int.parse(_epiWeekRmv.text),
                        _instlTime,
                        _removeTime);
                    logger.d(const Text("Adding to Firebase"));
                    Navigator.pop(context);
                  },
                  child: const Text("Add Ovitrap"))
            ],
          )),
        ));
  }
}
