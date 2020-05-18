import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  final String firstName;
  final String lastName;
  final String stateName;
  final String address1;
  final String address2;
  final String city;
  final String mobile;
  final String pincode;
  final String id;

  User({
    @required this.id,
    @required this.firstName,
    @required this.address1,
    @required this.address2,
    @required this.city,
    @required this.lastName,
    @required this.mobile,
    @required this.pincode,
    @required this.stateName,
  });
}

class UserProfile with ChangeNotifier {
  final String authToken;
  User _currentUser;
  String userId;

  UserProfile(this.authToken, this._currentUser, this.userId);

  User get getUserd{
    return _currentUser;
  }

  Future<void> updateUser(User user) async {
    final url =
        'https://shoapapp-8a869.firebaseio.com/user/$userId.json?auth=$authToken';
    try {
      await http.put(
        url,
        body: json.encode({
          'firstName': user.firstName,
          'address1': user.address1,
          'address2': user.address2,
          'city': user.city,
          'lastName': user.lastName,
          'mobile': user.mobile,
          'pincode': user.pincode,
          'stateName': user.stateName
        }),
      );
      notifyListeners();
    } catch (error) {
      //print(error);
      throw error;
    }
  }

  User get getEmptyUser {
    return User(
        id: null,
        firstName: '',
        address1: '',
        address2: '',
        city: '',
        lastName: '',
        mobile: '',
        pincode: '',
        stateName: '');
  }

  Future<void> fetchAndSetUser() async {
    final url =
        'https://shoapapp-8a869.firebaseio.com/user/$userId.json?auth=$authToken';
        print(url);
    try {
      var response = await http.get(url);
if(null == response){
  _currentUser = getEmptyUser;
}else{
      //print('Type is ${response.body.runtimeType}');
      //print('response' + response.body);
        final extractData = jsonDecode(response.body) as Map<String, dynamic>;
        _currentUser = User(
          id: userId,
          firstName: extractData['firstName'],
          address1: extractData['address1'],
          address2: extractData['address2'],
          city: extractData['city'],
          lastName: extractData['lastName'],
          mobile: extractData['mobile'],
          pincode: extractData['pincode'],
          stateName: extractData['stateName'],
        );
    }
      notifyListeners();
      //return _currentUser;
    } catch (error) {
      throw error;
    }
  }
}
