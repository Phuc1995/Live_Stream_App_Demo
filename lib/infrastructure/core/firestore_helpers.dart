import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:flutter_ddd/domain/core/errors.dart';
import 'package:flutter_ddd/injection.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

extension FirestoreX on FirebaseFirestore {
  Future<DocumentReference> userDocument() async {
    final userOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = userOption.getOrElse(() => throw NotAuthenticatedError());
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}

// ignore: avoid_classes_with_only_static_members
class FBStore {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static Future<void> requestLiveStream(
      {@required String firstName,
      @required String lastName,
      @required String birthDay,
      @required String add,
      @required File img}) async {
    try {
      final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': img.path},
      );

      final String fileName = basename(img.path);
      final Reference reference = _storage.ref().child('uploads/$fileName');
      final UploadTask uploadTask = reference.putFile(img, metadata);
      final snapHost = await Future.value(uploadTask);
      final String imgURL = await snapHost.ref.getDownloadURL();

      _fireStore.collection("request_live_streams").doc().set({
        'uid': _auth.currentUser.uid,
        'first_name': firstName,
        'last_name': lastName,
        'birth_day': birthDay,
        'add': add,
        'img': imgURL,
        'status': 'awaiting',
        'created_at': DateTime.now(),
      });
    } catch (e) {
      print('-------------------------------------> SendError: $e');
    }
  }

  static Stream<QuerySnapshot> streamStatus() {
    return _fireStore
        .collection('request_live_streams')
        .where('uid', isEqualTo: _auth.currentUser.uid)
        .orderBy('created_at', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> deleteRequest() async {
    _fireStore
        .collection("request_live_streams")
        .doc(_auth.currentUser.uid)
        .delete();
  }

  static Stream<QuerySnapshot> getListRequest() {
    return _fireStore
        .collection("request_live_streams")
        .where('status', isEqualTo: 'awaiting')
        .snapshots();
  }

  static Stream<QuerySnapshot> getListRequestMe() {
    return _fireStore
        .collection("request_live_streams")
        .where('uid', isEqualTo: _auth.currentUser.uid)
        .snapshots();
  }

  static Future<void> updateStatus(String uid, String status) async {
    var docs = await _fireStore
        .collection("request_live_streams")
        .where('uid', isEqualTo: uid)
        .where('status', isEqualTo: 'awaiting')
        .get();
    await docs.docs.first.reference.update({'status': status});
  }
}
