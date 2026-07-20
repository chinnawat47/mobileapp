import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_app/models/earthquake_model.dart';


class EarthquakeService {


  // ==========================================
  // FIRESTORE COLLECTION
  // ต้องตรงกับ Firebase Console
  //
  // Collection : earthquake
  // ==========================================

  final CollectionReference<Map<String, dynamic>> _dbCollection =
      FirebaseFirestore.instance.collection('earthquake');




  // ==========================================
  // READ : Realtime Earthquake Data
  // ==========================================

  Stream<List<EarthquakeModel>> getEarthquakeStream() {


    return _dbCollection
        .snapshots()
        .map((snapshot) {


      return snapshot.docs.map((doc) {


        return EarthquakeModel.fromFirestore(
          doc.data(),
          doc.id,
        );


      }).toList();


    });


  }





  // ==========================================
  // SEARCH : Search by place
  // ==========================================

  Future<List<EarthquakeModel>> searchEarthquake(
      String keyword,
  ) async {


    final searchText =
        keyword.trim().toLowerCase();



    if(searchText.isEmpty){

      return [];

    }



    final snapshot =
        await _dbCollection.get();



    final result =
        snapshot.docs.map((doc){


          return EarthquakeModel.fromFirestore(
            doc.data(),
            doc.id,
          );


        }).where((earthquake){


          return earthquake.place
              .toLowerCase()
              .contains(searchText);


        }).toList();



    return result;


  }





  // ==========================================
  // CREATE : Add Earthquake
  // ==========================================

  Future<void> addEarthquake(
      EarthquakeModel earthquake,
  ) async {


    await _dbCollection.add({

      'place':
          earthquake.place,

      'latitude':
          earthquake.latitude,

      'longitude':
          earthquake.longitude,

      'mag':
          earthquake.mag,

      'depth':
          earthquake.depth,

      'time':
          earthquake.time,


    });


  }





  // ==========================================
  // DELETE : Delete Earthquake
  // ==========================================

  Future<void> deleteEarthquake(
      String id,
  ) async {


    await _dbCollection
        .doc(id)
        .delete();


  }





  // ==========================================
  // GET BY ID
  // ==========================================

  Future<EarthquakeModel?> getEarthquakeById(
      String id,
  ) async {


    final doc =
        await _dbCollection
            .doc(id)
            .get();



    if(!doc.exists){

      return null;

    }



    return EarthquakeModel.fromFirestore(
      doc.data()!,
      doc.id,
    );


  }



}