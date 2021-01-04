import 'package:booking/hairSalon/helpers/constants.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider with ChangeNotifier {
  Position position;
  LatLng _center;
  LatLng get center => _center;
  LatLng _locationCoordinates;
  LatLng get locationCoordinates => _locationCoordinates;
  String country;
  TextEditingController locationController = TextEditingController();

  AppProvider.init() {
    _getUserLocation();
  }

  _getUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    position = await Geolocator.getCurrentPosition();
    _center = LatLng(position.latitude, position.longitude);
    final coordinates = new Coordinates(_center.latitude, _center.longitude);

    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    String countryCode = addresses[0].countryCode;
    _setPickupCoordinates(coordinates: _center);

    changeAddress(address: addresses[0].addressLine);

    print("======= COUNTRY CODE: ${addresses[0].countryCode} =======");
    if (prefs.getString(COUNTRY) == null) {
      await prefs.setString(COUNTRY, countryCode);
    } else if (prefs.getString(COUNTRY) != countryCode) {
      await prefs.setString(COUNTRY, countryCode);
    }
    country = countryCode;
    notifyListeners();
  }

  _setPickupCoordinates({LatLng coordinates}) {
    _locationCoordinates = coordinates;
    notifyListeners();
  }

  changeAddress({String address}) {
    locationController.text = address;
    notifyListeners();
  }
}
