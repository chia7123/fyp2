import 'dart:io';
import 'package:age_calculator/age_calculator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyp2/data/terms_condition.dart';
import 'package:fyp2/service/database.dart';
import 'package:fyp2/service/media_picker/files_picker.dart';
import 'package:fyp2/service/location.dart';
import 'package:fyp2/service/google_api.dart';
import 'package:fyp2/service/media_picker/signup_image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class PersonalInfo extends StatefulWidget {
  static const routeName = '/initialProfile';
  final String email;

  PersonalInfo(this.email);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final List<String> _users = ['Buyer', 'Confinement Lady'];
  final List<String> _vegans = ['Yes', 'No'];
  final List<String> _races = ['Chinese', 'Malay', 'India', 'Others...'];
  final List<String> _religions = [
    'Buddha',
    'Muslim',
    'Hindu',
    'Christian',
    'Others...'
  ];
  String _selectedUser;
  File _userImageFile;
  List<PlatformFile> _userFiles;
  String _selectedVegan;
  String _selectedRace;
  String _selectedReligion;
  bool _isVegan;
  DateTime dateOfBirth;
  bool check = false;

  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController detailedAddress = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController stateArea = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController bankBenefit = TextEditingController();
  TextEditingController bankAcc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _getLocation();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile Detail'),
          actions: [
            TextButton.icon(
              label: const Text(
                'Done',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _updateProfile();
              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 22, top: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Please fill in the following information.',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SignUpImagePicker(
                        _pickedImage,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: DropdownButtonFormField(
                          key: const ValueKey('user'),
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your role';
                            }
                            return null;
                          },
                          hint: const Text(
                            'Choose Your Roles',
                            textAlign: TextAlign.center,
                          ),
                          value: _selectedUser,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedUser = newValue as String;
                            });
                          },
                          items: _users.map((user) {
                            return DropdownMenuItem(
                              child: Text(user),
                              value: user,
                            );
                          }).toList(),
                        ),
                      ),
                      TextFormField(
                        key: const ValueKey('name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Name',
                        ),
                        controller: name,
                      ),
                      TextFormField(
                        key: const ValueKey('phone'),
                        validator: (value) {
                          if (value.isEmpty ||
                              value.length > 11 ||
                              value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(hintText: 'Phone Number'),
                        controller: phone,
                        keyboardType: const TextInputType.numberWithOptions(),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Race : '),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select race';
                                      }
                                      return null;
                                    },
                                    key: const ValueKey('race'),
                                    value: _selectedRace,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedRace = newValue as String;
                                      });
                                    },
                                    items: _races.map((race) {
                                      return DropdownMenuItem(
                                        child: Text(race),
                                        value: race,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Religion : '),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Select religion';
                                      }
                                      return null;
                                    },
                                    key: const ValueKey('religion'),
                                    value: _selectedReligion,
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedReligion = newValue as String;
                                      });
                                    },
                                    items: _religions.map((religion) {
                                      return DropdownMenuItem(
                                        child: Text(religion),
                                        value: religion,
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Nationality : '),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter nationality';
                                      }
                                      return null;
                                    },
                                    key: const ValueKey('nationality'),
                                    controller: nationality,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Vegetarian : '),
                                Expanded(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    child: DropdownButtonFormField(
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Select Vegetarianality';
                                        }
                                        return null;
                                      },
                                      key: const ValueKey('vegan'),
                                      value: _selectedVegan,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedVegan = value as String;
                                        });
                                        if (_selectedVegan == 'Yes') {
                                          _isVegan = true;
                                        } else {
                                          _isVegan = false;
                                        }
                                      },
                                      items: _vegans.map((vegan) {
                                        return DropdownMenuItem(
                                          child: Text(vegan),
                                          value: vegan,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Date of Birth: '),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please select your birth date';
                                }
                                return null;
                              },
                              readOnly: true,
                              key: const ValueKey('dob'),
                              controller: dob,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime.now(),
                              );
                              if (date == null) {
                                return;
                              } else {
                                setState(() {
                                  dateOfBirth = date;
                                  dob.text = DateFormat('yyyy-MM-dd')
                                      .format(dateOfBirth);
                                });
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: TextFormField(
                              validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                              key: const ValueKey('detailAddress'),
                              minLines: 1,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                  hintText: 'Detail Address'),
                              controller: detailedAddress,
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () => getAddress(),
                              icon: const Icon(
                                Icons.gps_fixed,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your postcode';
                            }
                            return null;
                          },
                        key: const ValueKey('postalCode'),
                        decoration: const InputDecoration(
                          hintText: 'Postal Code',
                        ),
                        controller: postalCode,
                      ),
                      TextFormField(
                        validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enetr your area state';
                            }
                            return null;
                          },
                        key: const ValueKey('stateArea'),
                        decoration: const InputDecoration(
                          hintText: 'State, Area',
                        ),
                        controller: stateArea,
                      ),
                      TextFormField(
                        key: const ValueKey('Email'),
                        readOnly: true,
                        decoration:
                            InputDecoration(hintText: 'Email: ${email.text}'),
                      ),
                      TextFormField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintMaxLines: 2,
                          hintText: 'ID : ${user.uid}',
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Banking Information',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your banking information';
                            }
                            return null;
                          },
                        key: const ValueKey('benefit bank'),
                        decoration: const InputDecoration(
                          hintText:
                              'Beneficiary Bank (Maybank, Public Bank, etc.)',
                        ),
                        controller: bankBenefit,
                      ),
                      TextFormField(
                        validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your bank acocount';
                            }
                            return null;
                          },
                        key: const ValueKey('bankAcc'),
                        decoration: const InputDecoration(
                          hintText: 'Bank Account No.',
                        ),
                        controller: bankAcc,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _selectedUser == 'Confinement Lady'
                          ? TextFormField(
                              key: const ValueKey('desc'),
                              minLines: 5,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Describe yourself',
                              ),
                              controller: desc,
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      _selectedUser == 'Confinement Lady'
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Certificates : ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  FilesPicker(
                                    fileSelectFn: _selectFile,
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getLocation() async {
    Position position = await LocationService().getCurrentLocation();
    Database().updateUserData(user.uid, {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }

  @override
  void initState() {
    super.initState();
    email.value = TextEditingValue(text: widget.email);
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _selectFile(List<PlatformFile> files) {
    _userFiles = files;
  }

  Future _updateProfile() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    List<String> certUrl = [];
    var age = AgeCalculator.age(dateOfBirth).years;

    if (_userImageFile == null) {
      Fluttertoast.showToast(msg: 'Please upload an profile photo');
      return;
    }

    final imageStorage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image')
        .child(user.uid + '.jpg');
    await imageStorage.putFile(_userImageFile);

    final url = await imageStorage.getDownloadURL();

    if (_selectedUser == null) {
      Fluttertoast.showToast(msg: 'Please select a user type');
      return;
    }

    if (_selectedUser == 'Confinement Lady' && _userFiles == null) {
      Fluttertoast.showToast(msg: 'Please upload the professional certificate');
      return;
    }

    if (_userFiles != null) {
      for (var file in _userFiles) {
        final fileStorage = FirebaseStorage.instance
            .ref()
            .child('CLCertificate')
            .child(user.uid)
            .child(file.name);

        await fileStorage.putFile(File(file.path));
        var url = await fileStorage.getDownloadURL();
        certUrl.add(url);
      }
    }
    Map<String, dynamic> data = {
      'name': name.text,
      'phone': phone.text,
      'detailAddress': detailedAddress.text,
      'postalCode': postalCode.text,
      'stateArea': stateArea.text,
      'userType': _selectedUser,
      'imageUrl': url,
      'email': email.text,
      'description': desc.text,
      'id': user.uid,
      'rating': 0,
      'orderSuccess': 0,
      'certUrl': certUrl,
      'vegan': _isVegan,
      'dob': dateOfBirth,
      'age': age,
      'race': _selectedRace,
      'religion': _selectedReligion,
      'nationality': nationality.text,
      'beneficiaryBank': bankBenefit.text,
      'bankAccNo': bankAcc.text,
    };

    if (isValid) {
      termsCondition(data);
    }else {
      Fluttertoast.showToast(msg: 'Please agree to the T&C first.');
    }
  }

  Future getAddress() async {
    try {
      Position position = await LocationService().getCurrentLocation();

      Map<String, dynamic> map = await GoogleAPI().getAddress(position);
      List<dynamic> address = map["address_components"];
      setState(() {
        detailedAddress.text = address[0]['long_name'] +
            ' ' +
            address[1]['long_name'] +
            ', ' +
            address[2]['long_name'] +
            ',';
        postalCode.text = address[6]['long_name'];
        stateArea.text =
            address[3]['long_name'] + ', ' + address[4]['long_name'] + '.';
      });
      Database().updateUserData(user.uid, {
        'latitude': position.latitude,
        'longitude': position.longitude,
      });
    } catch (e) {
      print(e);
    }
  }

  void termsCondition(Map<String, dynamic> data) {
    showBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Terms & Conditions'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.black,
                        )),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                instruction,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                generalTerm,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nI. PRODUCTS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                product,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nII. APPLICATION',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                application,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nIII. DISCLAIMER OF WARRANTIES',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                disclaimer,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nIV. LIMITATION OF LIABILITY',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                limitation,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nV. INDEMNIFICATION',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                indemnification,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nVI. PRIVACY',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                privacy,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nVII. AGREEMENT TO BE BOUND',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                agreement,
                                textAlign: TextAlign.justify,
                              ),
                              const Text(
                                '\nVIII. GENERAL',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 23),
                              ),
                              Text(
                                general,
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                primary: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg:
                                        'Please agree the Terms & Conditions to procced to the next step.');
                              },
                              child: const Text('DECLINE')),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                primary: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {
                                check = true;
                                Navigator.pop(context);
                                if (check) {
                                  Database()
                                      .updateUserData(user.uid, data)
                                      .whenComplete(() => {
                                            Fluttertoast.showToast(
                                                msg: 'Sign up successful'),
                                          });
                                }
                              },
                              child: const Text('AGREE')),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
