import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_app/models/Activity.dart';

class ActivityDBHelper {
  static final FirebaseFirestore getdb = FirebaseFirestore.instance;

  /// Returns a stream of Activity lists. Any FirebaseException thrown by
  /// Firestore will be forwarded through the stream as an error (no JS
  /// interop conversions here). We wrap errors to ensure they're Dart
  /// exceptions and avoid accidental JSObject propagation on web.
  static Stream<List<Activity>> getActivitiesStream() {
    return FirebaseFirestore.instance
        .collection('activity')
        .snapshots()
        .handleError((error) {
      // If a FirebaseException reaches here, rethrow as itself so callers
      // get a predictable Dart type. For web, some errors might be JS
      // objects; convert to FirebaseException where possible.
      if (error is FirebaseException) {
        throw error;
      }

      // Try to convert generic errors to FirebaseException-like message
      throw FirebaseException(plugin: 'cloud_firestore', message: error.toString());
    }).map((snapshot) {
      return snapshot.docs.map((doc) => Activity.fromFirestore(doc)).toList();
    });
  } //func

  static Future<void> deleteActivity(String docId) async {
    try {
      await FirebaseFirestore.instance.collection("activity").doc(docId).delete();
    } catch (e) {
      // Normalize web JS errors to Dart FirebaseException for callers
      if (e is FirebaseException) rethrow;
      throw FirebaseException(plugin: 'cloud_firestore', message: e.toString());
    }
  }
} //class

