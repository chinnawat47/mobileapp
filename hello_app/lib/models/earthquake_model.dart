import 'package:cloud_firestore/cloud_firestore.dart';

class EarthquakeModel {
  final String id;
  final String place;
  final double latitude;
  final double longitude;
  final double mag;
  final String depth;
  final String time;

  const EarthquakeModel({
    required this.id,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.mag,
    required this.depth,
    required this.time,
  });


  factory EarthquakeModel.fromFirestore(
    Map<String, dynamic> data,
    String docId,
  ) {

    return EarthquakeModel(
      id: docId,

      place:
          data['place']?.toString() ??
          'Unknown Location',

      latitude:
          _parseDouble(data['latitude']),

      longitude:
          _parseDouble(data['longitude']),

      mag:
          _parseDouble(data['mag']),


      depth:
          data['depth']?.toString() ??
          'Unknown',


      time:
          _parseTime(data['time']),
    );
  }


  // Convert number/string to double safely
  static double _parseDouble(Object? value) {

    if (value == null) {
      return 0.0;
    }


    if (value is num) {
      return value.toDouble();
    }


    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }


    return 0.0;
  }



  // Support Firestore Timestamp and String
  static String _parseTime(Object? value) {

    if (value == null) {
      return 'Unknown Time';
    }


    if (value is Timestamp) {

      return value
          .toDate()
          .toString();

    }


    return value.toString();
  }
}