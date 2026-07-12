import 'package:cloud_firestore/cloud_firestore.dart';


class Activity {

  final String id;

  final String title;

  final String desc;

  final List<dynamic> stdList;

  final DateTime? dateFrom;



  // Constructor
  Activity({

    required this.id,

    required this.title,

    required this.desc,

    required this.stdList,

    this.dateFrom,

  });





  // Convert Firebase Document -> Activity Object
  factory Activity.fromFirestore(DocumentSnapshot doc) {


    final data = doc.data() as Map<String, dynamic>;



    return Activity(


      id: doc.id,



      title: data['title'] ?? 
          'activity name is not defined',




      desc: data['desc'] ?? '',




      stdList: data['stdlist'] ?? [],




      dateFrom: data['datefrom'] != null

          ? (data['datefrom'] as Timestamp).toDate()

          : null,



    );


  }


}