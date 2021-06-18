import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ddd/domain/admin/request_objects.dart';
import 'package:flutter_ddd/infrastructure/core/firestore_helpers.dart';
import 'package:meta/meta.dart';

part 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(AdminInitial());

  List<RequestStream> requestList = [];

  Stream<QuerySnapshot> getRequest() {
    return FBStore.getListRequest();
  }

  Future<void> onReject(String uid) async {
    await FBStore.updateStatus(uid, 'rejected');
  }

  Future<void> onApprove(String uid) async {
    await FBStore.updateStatus(uid, 'approved');
  }

}
