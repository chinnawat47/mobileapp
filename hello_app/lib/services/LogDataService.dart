import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LogDataService {

  // =====================================
  // 1. Pie Chart : Count Log Levels
  // ใช้กับ collection: server_logs
  // field: level
  // =====================================
  static Map<String, int> aggregateLogLevels(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    List<String>? allowedLevels,
  }) {
    Map<String, int> counts = {};

    for (var doc in docs) {
      final dynamic levelData = doc.data()['level'];

      if (levelData != null) {
        String level = levelData.toString().toUpperCase();

        if (allowedLevels == null || allowedLevels.contains(level)) {
          counts[level] = (counts[level] ?? 0) + 1;
        }
      }
    }

    return counts;
  }

  // =====================================
  // 1. Pie Chart : Count Activity Title
  // ใช้กับ collection: activity
  // field: title
  // =====================================
  static Map<String, int> aggregateLogData(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {

    Map<String, int> counts = {};

    for (var doc in docs) {

      final dynamic titleData = doc.data()['title'];

      if (titleData != null) {

        String title = titleData.toString();

        counts[title] = (counts[title] ?? 0) + 1;

      }

    }

    return counts;
  }



  // =====================================
  // 2. Bar Chart :
  // Find average Duration group by Service
  // (เก็บไว้สำหรับใช้ในอนาคต)
  // =====================================
  static Map<String, double> calculateAverageDuration(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {

    Map<String, List<int>> serviceDurations = {};


    for (var doc in docs) {

      final data = doc.data();


      final String? service = data['service'];


      final dynamic durationData = data['duration'];



      if (service != null && durationData != null) {


        final int duration =
            (durationData as num).toInt();


        serviceDurations
            .putIfAbsent(service, () => [])
            .add(duration);

      }

    }



    Map<String, double> averages = {};


    serviceDurations.forEach((service, durations) {


      double avg =
          durations.reduce((a, b) => a + b)
          /
          durations.length;


      averages[service] = avg;


    });


    return averages;

  }




  // =====================================
  // 3. Line Chart :
  // Find average Duration group by DateTime
  // =====================================
  static Map<String, double> calculateDurationOverTime(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {


    Map<String, List<int>> timeDurations = {};



    List<QueryDocumentSnapshot<Map<String, dynamic>>> sortedDocs =
        List.from(docs);



    sortedDocs.sort((a, b) {


      String timeA =
          a.data()['timestamp']?.toString() ?? '';


      String timeB =
          b.data()['timestamp']?.toString() ?? '';



      return timeA.compareTo(timeB);


    });




    for (var doc in sortedDocs) {


      final data = doc.data();



      final String? timestampStr =
          data['timestamp'];



      final dynamic durationData =
          data['duration'];



      if (timestampStr != null &&
          durationData != null) {



        final int duration =
            (durationData as num).toInt();



        try {


          DateTime dt =
              DateTime.parse(timestampStr)
              .toLocal();



          String formattedDate =
              DateFormat('MM-dd')
              .format(dt);



          timeDurations
              .putIfAbsent(
                formattedDate,
                () => [],
              )
              .add(duration);



        } catch (e) {

          // ignore invalid timestamp

        }


      }


    }




    Map<String, double> timelineAverages = {};



    timeDurations.forEach((date, durations) {


      double avg =
          durations.reduce((a, b) => a + b)
          /
          durations.length;



      timelineAverages[date] = avg;


    });



    return timelineAverages;

  }

}