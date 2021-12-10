// ignore_for_file: camel_case_types, file_names,   prefer_typing_uninitialized_variables,, unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:doctor_app/models/client.dart';
import 'package:doctor_app/providers/clients_provider.dart';
import 'package:doctor_app/widget/image_grideview.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Add_Widget extends StatefulWidget {
  @override
  _Add_WidgetState createState() => _Add_WidgetState();
}

class _Add_WidgetState extends State<Add_Widget> {
  late List<dynamic> clientPhotos = editedClient.id != null
      ? jsonDecode(editedClient.images)
      : []; //client photos
  final _form = GlobalKey<FormState>();
  bool isloading = false;
  var pickedImage;

  String gender = '';
  // final _nameController = TextEditingController();
  // final _numController = TextEditingController();
  // final _visitController = TextEditingController();
  // final ageController = TextEditingController();
  late Map<String, dynamic> visitsData =
      editedClient.id != null ? jsonDecode(editedClient.visits) : {};
  List<TextFormField> visits = [];
  late int counter =
      editedClient.id != null ? jsonDecode(editedClient.visits).length : 0;

  //visits textforms

  void addVisit() {
    counter++;
    print(counter);
    visits.add(TextFormField(
        maxLines: null,
        decoration: InputDecoration(
          icon: const Icon(Icons.add),
          label: Text("visit : $counter"),
          hintText: "Enter last visit date and details",
        ),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        onChanged: (val) {
          //print(jsonDecode(editedClient.visits).length);
          visitsData.addAll({
            "$counter": val,
          });
        }));
  }

  Client editedClient = Client(null, '', null, null, '', '', null, '');

  void submit() {
    bool isvalid = _form.currentState!.validate();
    if (!isvalid) {
      return;
    } else if (editedClient.image == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please Enter a photo")));
      return;
    }
    _form.currentState!.save();
    setState(() {
      isloading = true;
    });
    print(clientPhotos);

    final String clientphotosJson = jsonEncode(clientPhotos);
    final String visitsJson = jsonEncode(visitsData);

    editedClient = Client(
        editedClient.id,
        editedClient.name,
        editedClient.number,
        editedClient.image,
        clientphotosJson,
        editedClient.gender,
        editedClient.age,
        visitsJson);
    editedClient.id != null
        ? Provider.of<Clients_Provider>(context, listen: false)
            .update(editedClient.id!, editedClient)
            .then((value) {
            isloading = false;
            Navigator.of(context).pop();
          })
        : Provider.of<Clients_Provider>(context, listen: false)
            .addData(
                DateTime.now().toString(),
                editedClient.name,
                editedClient.number,
                editedClient.image!,
                editedClient.images,
                editedClient.gender,
                editedClient.age!,
                editedClient.visits)
            .catchError((e) {
            print(e);
          }).then((value) {
            setState(() {
              isloading = false;
            });
            print(visitsData['2']);
            Navigator.of(context).pop();
          });
  }

  var _value = 0; //radio value
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      final clientId = ModalRoute.of(context)!.settings.arguments as String;
      if (clientId != null) {
        editedClient = Provider.of<Clients_Provider>(context, listen: false)
            .find(clientId);
      }
    }
    isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cId = ModalRoute.of(context)?.settings.arguments as String;
    if (cId != null) {
      _value = editedClient.gender == "Male" ? 1 : 2;
    }

    return isloading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                  key: _form,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: editedClient.image != null
                            ? FileImage(editedClient.image!)
                            : null,
                      ),
                      Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              ImagePicker()
                                  .getImage(source: ImageSource.camera)
                                  .then((value) {
                                setState(() {
                                  editedClient = Client(
                                      editedClient.id,
                                      editedClient.name,
                                      editedClient.number,
                                      File(value!.path),
                                      editedClient.images,
                                      editedClient.gender,
                                      editedClient.age,
                                      editedClient.visits);
                                });
                              });
                            },
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text('Pick image using your camera'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ImagePicker()
                                  .getImage(source: ImageSource.gallery)
                                  .then((value) {
                                setState(() {
                                  editedClient = Client(
                                      editedClient.id,
                                      editedClient.name,
                                      editedClient.number,
                                      File(value!.path),
                                      editedClient.images,
                                      editedClient.gender,
                                      editedClient.age,
                                      editedClient.visits);
                                });
                              });
                            },
                            icon: const Icon(Icons.photo),
                            label: const Text('Pick image from your gallery'),
                          ),
                        ],
                      ),
                      TextFormField(
                        initialValue: editedClient.name,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("Name"),
                          hintText: "Enter the client`s name",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.name,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter a name";
                          } else if (val.length > 15) {
                            return "name cannot contain more than 15 characters";
                          }
                        },
                        onSaved: (val) {
                          editedClient = Client(
                              editedClient.id,
                              val!,
                              editedClient.number,
                              editedClient.image,
                              editedClient.images,
                              editedClient.gender,
                              editedClient.age,
                              editedClient.visits);
                        },
                      ),
                      TextFormField(
                        initialValue: editedClient.number == null
                            ? null
                            : (editedClient.number).toString(),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone),
                          label: Text("Phone Number"),
                          hintText: "Enter the client`s phone number",
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          if (val != '') {
                            editedClient = Client(
                                editedClient.id,
                                editedClient.name,
                                int.parse(val!),
                                editedClient.image,
                                editedClient.images,
                                editedClient.gender,
                                editedClient.age,
                                editedClient.visits);
                          } else {
                            editedClient = Client(
                                editedClient.id,
                                editedClient.name,
                                null,
                                editedClient.image,
                                editedClient.images,
                                editedClient.gender,
                                editedClient.age,
                                editedClient.visits);
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: editedClient.age == null
                            ? null
                            : (editedClient.age).toString(),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          label: Text("Age"),
                          hintText: "Enter the client`s Age",
                        ),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "Enter an age";
                          } else if (int.parse(val) > 100) {
                            "Invalid age";
                          }
                        },
                        onSaved: (val) {
                          editedClient = Client(
                              editedClient.id,
                              editedClient.name,
                              editedClient.number,
                              editedClient.image,
                              editedClient.images,
                              editedClient.gender,
                              int.parse(val!),
                              editedClient.visits);
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Radio<int>(
                                  value: 1,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value!;
                                      if (value == 1) {
                                        editedClient = Client(
                                            editedClient.id,
                                            editedClient.name,
                                            editedClient.number,
                                            editedClient.image,
                                            editedClient.images,
                                            "Male",
                                            editedClient.age,
                                            editedClient.visits);
                                      }
                                    });
                                  }),
                              const Text('Male'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<int>(
                                  value: 2,
                                  groupValue: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value!;
                                      if (value == 2) {
                                        editedClient = Client(
                                            editedClient.id,
                                            editedClient.name,
                                            editedClient.number,
                                            editedClient.image,
                                            editedClient.images,
                                            "Female",
                                            editedClient.age,
                                            editedClient.visits);
                                      }
                                    });
                                  }),
                              const Text('Female'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              ImagePicker()
                                  .getImage(source: ImageSource.camera)
                                  .then((value) {
                                setState(() {
                                  clientPhotos.add(value!.path);
                                });
                              });
                            },
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text('Add Photos using your camera'),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ImagePicker()
                                  .getImage(source: ImageSource.gallery)
                                  .then((value) {
                                setState(() {
                                  clientPhotos.add(value!.path);
                                });
                              });
                            },
                            icon: const Icon(Icons.add_a_photo),
                            label: const Text('Add Photos from your gallery'),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                          child: Images_Gridview(clientPhotos)),
                      SizedBox(
                        height: cId != null ? 100 : 0,
                        child: cId != null
                            ? ListView.builder(
                                itemCount: visitsData.length,
                                shrinkWrap: true,
                                itemBuilder: (context, i) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "visit  ${i + 1} :",
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 200,
                                              child: Text(
                                                "${jsonDecode(editedClient.visits)["${i + 1}"]}",
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  );
                                })
                            : null,
                      ),
                      const Align(
                        alignment: Alignment.center,
                        child: Text("Add visits:"),
                      ),
                      SizedBox(
                        height: visits.isEmpty ? 0 : 150,
                        child: ListView.builder(
                            itemCount: visits.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return visits[index];
                            }),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              addVisit();
                            });
                          },
                          icon: const Icon(Icons.add)),
                      TextButton.icon(
                          onPressed: () {
                            setState(() {
                              submit();
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Submit"))
                    ],
                  )),
            ),
          );
  }
}
