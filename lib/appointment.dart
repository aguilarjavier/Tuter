import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String className;
  final String time;
  final String date;
  final String tutorName;
  final double positiveRatings;
  final double totalRatings;
  final Timestamp startTime;
  final Timestamp endTime;

  final DocumentReference reference;

  Appointment(
      {this.positiveRatings,
      this.totalRatings,
      this.className,
      this.time,
      this.startTime,
      this.endTime,
      this.date,
      this.tutorName,
      this.reference});

  Appointment.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['className'] != null),
        //assert(map['time'] != null),
        assert(map['startTime'] != null),
        assert(map['endTime'] != null),
        className = map['className'],
        time = map['time'],
        date = map['date'],
        tutorName = map['tutorName'],
        positiveRatings = map['positiveRatings'],
        totalRatings = map['totalRatings'],

        startTime = map['startTime'],
        endTime = map['endTime'];

  Appointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
    

  @override
  String toString() => "Appointment<$className:$time:$date:$tutorName, $positiveRatings, $totalRatings>";
}
