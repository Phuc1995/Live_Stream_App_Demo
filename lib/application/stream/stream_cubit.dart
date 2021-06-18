import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ddd/domain/admin/request_objects.dart';
import 'package:flutter_ddd/infrastructure/core/firestore_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'stream_state.dart';

class StreamCubit extends Cubit<StreamState> {
  StreamCubit() : super(StreamInitial());

  File imageFile;
  String firstName = "";
  String lastName = "";
  String birthDay = "";
  String address = "";
  List<RequestStream> requestList = [];

  Future<void> getImage() async {
    final pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      emit(Loading());
      imageFile?.delete();
      imageFile = File(pickedFile.path);
      emit(GetSuccess());
    }
  }

  Future<void> sendRequest() async {
    emit(Loading());
    await FBStore.requestLiveStream(
      firstName: firstName,
      lastName: lastName,
      birthDay: birthDay,
      img: imageFile,
      add: address,
    );
    emit(Requested());
  }

  Stream<QuerySnapshot> streamStatus() {
    return FBStore.streamStatus();
  }

  Future<void> deleteRequest() async {
    await FBStore.deleteRequest();
  }

  Stream<QuerySnapshot> getRequest() {
    return FBStore.getListRequestMe();
  }

  void validatorImg() {
    if (imageFile == null) emit(ImgIsNull());
  }
}
