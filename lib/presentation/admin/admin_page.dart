import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/admin/admin_cubit.dart';
import 'package:flutter_ddd/domain/admin/request_objects.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  AdminCubit adminCubit;

  @override
  void initState() {
    adminCubit = AdminCubit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            ExtendedNavigator.of(context).pop();
          },
        ),
        title: const Text("Request List"),
      ),
      body: BlocProvider(
        create: (context) => AdminCubit(),
        child: BlocConsumer<AdminCubit, AdminState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: StreamBuilder<QuerySnapshot>(
                  stream: adminCubit.getRequest(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();

                    adminCubit.requestList.clear();
                    List<QueryDocumentSnapshot> docsList = [];
                    docsList.addAll(snapshot.data.docs);
                    adminCubit.requestList.addAll(
                      docsList.map((e) => RequestStream.fromFireStore(e)).toList(),
                    );
                    return _buildListView(adminCubit.requestList);
                  }),
            );
          },
        ),
      ),
    );
  }

  ListView _buildListView(List<RequestStream> list) {
    return ListView.builder(
      itemCount: list?.length,
      itemBuilder: (_, index) {
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${list[index].firstName} ${list[index].lastName}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "${list[index].add}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Birth day: ${list[index].birthDay}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          Text(
                            "Requested: ${list[index].timeRequest}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () => adminCubit.onReject(list[index].uID),
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => adminCubit.onApprove(list[index].uID),
                    child: const Text(
                      "Approve",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
