import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore;

  TransactionService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<TransactionModel>> getTransactionsStream() {
    return _firestore.collection('transactions').snapshots().map((snapshot) {
      return snapshot.docs
          .map(TransactionModel.fromFirestore)
          .toList();
    });
  }
}
