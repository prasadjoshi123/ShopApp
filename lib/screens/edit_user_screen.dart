import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user.dart';

class EditUserScreen extends StatefulWidget {
  static const routeName = '/edit-user';

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _form = GlobalKey<FormState>();
  final finalZipCodes = ['411045', '411007', '411021', '411008', '411027'];

  var _editedUser = User(
      id: null,
      firstName: '',
      address1: '',
      address2: '',
      city: '',
      lastName: '',
      mobile: '',
      pincode: '',
      stateName: '');

  var _initValues = {
    'firstName': '',
    'address1': '',
    'address2': '',
    'city': '',
    'lastName': '',
    'mobile': '',
    'pincode': '',
    'stateName': '',
  };

@override
  void initState() {
_editedUser = Provider.of<UserProfile>(context, listen: false).getEmptyUser;    
    super.initState();
  }

    void _saveForm() async {
    final isValid = _form.currentState.validate();

    if (!isValid) {
      return;
    }
    _form.currentState.save();

    try {
      await Provider.of<UserProfile>(context, listen: false)
          .updateUser(_editedUser);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured!'),
          content: Text('Something went wrong.'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('Okay')),
          ],
        ),
      );
    }
    Navigator.of(context).popAndPushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: FutureBuilder(
        future:
            Provider.of<UserProfile>(context, listen: false).fetchAndSetUser(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return  Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildFirstNameField('First Name'),
                        buildLastNameField('Last Name'),
                        buildMobileField('Phone Number'),
                        buildAddressField('Street Address'),
                        buildTownField('Locality'),
                        buildCityField('District'),
                        buildStateField('State'),
                        buildPinCodeField('Pincode'),
                      ],
                    ),
                  ),
                ),
              );
            } else {
             _editedUser =
                 Provider.of<UserProfile>(context).getUserd;
              _initValues = {
                'firstName': _editedUser.firstName,
                'address1': _editedUser.address1,
                'address2': _editedUser.address2,
                'city': _editedUser.city,
                'lastName': _editedUser.lastName,
                'mobile': _editedUser.mobile,
                'pincode': _editedUser.pincode,
                'stateName': _editedUser.stateName,
              };

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildFirstNameField('First Name'),
                        buildLastNameField('Last Name'),
                        buildMobileField('Phone Number'),
                        buildAddressField('Street Address'),
                        buildTownField('Locality'),
                        buildCityField('District'),
                        buildStateField('State'),
                        buildPinCodeField('Pincode'),
                      ],
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget buildFirstNameField(String label) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'First Name is required';
        }
        return null;
      },
      decoration: inputDecoration(label),
      initialValue: _initValues['firstName'],
      textInputAction: TextInputAction.next,
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: value,
            address1: _editedUser.address1,
            address2: _editedUser.address2,
            city: _editedUser.city,
            lastName: _editedUser.lastName,
            mobile: _editedUser.mobile,
            pincode: _editedUser.pincode,
            stateName: _editedUser.stateName);
      },
    );
  }

  Widget buildLastNameField(String label) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last Name is required';
        }
        return null;
      },
      decoration: inputDecoration(label),
      initialValue: _initValues['lastName'],
      textInputAction: TextInputAction.next,
      onSaved: (String value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: _editedUser.address1,
            address2: _editedUser.address2,
            city: _editedUser.city,
            lastName: value,
            mobile: _editedUser.mobile,
            pincode: _editedUser.pincode,
            stateName: _editedUser.stateName);
      },
    );
  }

  Widget buildAddressField(String label) {
    return TextFormField(
      initialValue: _initValues['address1'],
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Address is required';
        }
        return null;
      },
      decoration: inputDecoration(label),
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: value,
            address2: _editedUser.address2,
            city: _editedUser.city,
            lastName: _editedUser.lastName,
            mobile: _editedUser.mobile,
            pincode: _editedUser.pincode,
            stateName: _editedUser.stateName);
      },
    );
  }

  Widget buildTownField(String label) {
    return TextFormField(
      initialValue: _initValues['address2'],
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Locality/Town is required';
        }
        return null;
      },
      decoration: inputDecoration(label),
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: _editedUser.address1,
            address2: value,
            city: _editedUser.city,
            lastName: _editedUser.lastName,
            mobile: _editedUser.mobile,
            pincode: _editedUser.pincode,
            stateName: _editedUser.stateName);
      },
    );
  }

  Widget buildCityField(String label) {
    return TextFormField(
      initialValue: 'Pune',
      enabled: false,
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return 'City is required';
        }
        return null;
      },
      decoration: inputDecoration(label),
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: _editedUser.address1,
            address2: _editedUser.address2,
            city: value,
            lastName: _editedUser.lastName,
            mobile: _editedUser.mobile,
            pincode: _editedUser.pincode,
            stateName: _editedUser.stateName);
      },
    );
  }

  Widget buildMobileField(String label) {
    return TextFormField(
      initialValue: _initValues['mobile'],
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Mobile No. is required!';
        }
        if (!RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Please enter numeric value only';
        }
        if (value.trim().length != 10) {
          return 'Mobile No. should be 10 digits only!';
        }
        return null;
      },
      decoration: inputDecoration(label),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: _editedUser.address1,
            address2: _editedUser.address2,
            city: _editedUser.city,
            lastName: _editedUser.lastName,
            mobile: value,
            pincode: _editedUser.pincode,
            stateName: _editedUser.stateName);
      },
    );
  }

  Widget buildStateField(String label) {
    return TextFormField(
      initialValue: 'Maharashtra',
      enabled: false,
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return 'State is required';
        }
        return null;
      },
      decoration: inputDecoration(label),
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: _editedUser.address1,
            address2: _editedUser.address2,
            city: _editedUser.city,
            lastName: _editedUser.lastName,
            mobile: _editedUser.mobile,
            pincode: _editedUser.pincode,
            stateName: value);
      },
    );
  }

  Widget buildPinCodeField(String label) {
    return TextFormField(
      initialValue: _initValues['pincode'],
      validator: (String value) {
        if (value.isEmpty) {
          return 'Pincode is required!';
        }
        if (!RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Please enter numeric value only';
        }

        if (value.trim().length != 6) {
          return 'Pincode should be 6 digits only!';
        }

        if (!finalZipCodes.any((element) => element.contains(value))) {
          return 'Only 411045,411007,411021,411008,411027 pin code supported';
        }

        return null;
      },
      keyboardType: TextInputType.number,
      decoration: inputDecoration(label),
      onSaved: (value) {
        _editedUser = User(
            id: _editedUser.id,
            firstName: _editedUser.firstName,
            address1: _editedUser.address1,
            address2: _editedUser.address2,
            city: _editedUser.city,
            lastName: _editedUser.lastName,
            mobile: _editedUser.mobile,
            pincode: value,
            stateName: _editedUser.stateName);
      },
      onFieldSubmitted: (_) {
        _saveForm();
      },
    );
  }

  InputDecoration inputDecoration(String labelText) {
    return InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade500),
        contentPadding: EdgeInsets.all(0.0));
  }
}
