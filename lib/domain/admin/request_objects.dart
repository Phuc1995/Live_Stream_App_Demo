import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RequestStream {

  String uID;
  String firstName;
  String lastName;
  String birthDay;
  String status;
  String add;
  String timeRequest;

  RequestStream({
    this.uID,
    this.firstName,
    this.lastName,
    this.birthDay,
    this.status,
    this.add,
    this.timeRequest,
  });

  factory RequestStream.fromFireStore(DocumentSnapshot snapshot) {
    Timestamp stamp = snapshot['created_at'] as Timestamp;
    DateTime date = stamp.toDate();
    final DateFormat dateFormat = DateFormat("yyyy/MM/dd");
    return RequestStream(
      uID : snapshot['uid'] as String,
      firstName : snapshot['first_name'] as String,
      lastName : snapshot['last_name'] as String,
      birthDay : snapshot['birth_day'] as String,
      status : snapshot['status'] as String,
      add : snapshot['add'] as String,
      timeRequest: dateFormat.format(date),
    );
  }


}