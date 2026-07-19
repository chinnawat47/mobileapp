import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String type;
  final String status;
  final double amount;
  final String currency;
  final double fee;
  final double net;
  final DateTime? createdAt;
  final DateTime? processedAt;
  final String description;
  final String customer;
  final String paymentMethod;
  final Map<String, dynamic>? metadata;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.fee,
    required this.net,
    required this.createdAt,
    required this.processedAt,
    required this.description,
    required this.customer,
    required this.paymentMethod,
    required this.metadata,
  });

  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('Document ${doc.id} has no data');
    }
    return TransactionModel.fromMap(doc.id, data);
  }

  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
    return TransactionModel(
      id: id,
      type: _asString(data['type']) ?? '',
      status: _asString(data['status']) ?? '',
      amount: _asDouble(data['amount']),
      currency: _asString(data['currency']) ?? '',
      fee: _asDouble(data['fee']),
      net: _asDouble(data['net']),
      createdAt: _parseDateTime(data['createdAt']),
      processedAt: _parseDateTime(data['processedAt']),
      description: _asString(data['description']) ?? '',
      customer: _asString(data['customer']) ?? '',
      paymentMethod: _asString(data['paymentMethod']) ?? '',
      metadata: _parseMetadata(data['metadata']),
    );
  }

  static String? _asString(dynamic value) {
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  static double _asDouble(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString()) ?? 0;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static Map<String, dynamic>? _parseMetadata(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }
}
