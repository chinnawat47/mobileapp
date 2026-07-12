import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_app/models/Activity.dart';


class ActivityDBHelper {

  static final FirebaseFirestore getdb =
      FirebaseFirestore.instance;



  // =========================
  // READ : ดึงข้อมูล Activity
  // =========================
  static Stream<List<Activity>> getActivitiesStream() {

    return getdb
        .collection('activity')
        .snapshots()
        .map((snapshot) {

      return snapshot.docs
          .map((doc) => Activity.fromFirestore(doc))
          .toList();

    });

  }




  // =========================
  // CREATE : เพิ่ม Activity
  // =========================
  static Future<void> addActivity({

    required String title,

    required String desc,

    required List<dynamic> stdList,

    DateTime? dateFrom,

  }) async {


    await getdb
        .collection('activity')
        .add({


      'title': title,


      'desc': desc,


      'stdlist': stdList,


      'datefrom': dateFrom == null
          ? null
          : Timestamp.fromDate(dateFrom),


    });


  }






  // =========================
  // UPDATE : แก้ไข Activity
  // =========================
  static Future<void> updateActivity(

      String docId,

      {

      required String title,

      required String desc,

      required List<dynamic> stdList,

      DateTime? dateFrom,

      }

      ) async {



    await getdb

        .collection('activity')

        .doc(docId)

        .update({


      'title': title,


      'desc': desc,


      'stdlist': stdList,


      'datefrom': dateFrom == null
          ? null
          : Timestamp.fromDate(dateFrom),


    });



  }







  // =========================
  // DELETE : ลบ Activity
  // =========================
  static Future<void> deleteActivity(

      String docId

      ) async {


    await getdb

        .collection('activity')

        .doc(docId)

        .delete();


  }



}