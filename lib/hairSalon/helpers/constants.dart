import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_webservice/places.dart';

final Future<FirebaseApp> initialization = Firebase.initializeApp();

FirebaseFirestore firebaseFiretore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

// app constants
const COUNTRY = "country";
const GOOGLE_MAPS_API_KEY = "ADD KEY";
GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: GOOGLE_MAPS_API_KEY);
