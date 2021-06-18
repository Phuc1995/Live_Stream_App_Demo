import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/auth/auth_bloc.dart';
import 'package:flutter_ddd/application/stream/stream_cubit.dart';
import 'package:flutter_ddd/domain/auth/i_auth_facade.dart';
import 'package:flutter_ddd/presentation/router/router.gr.dart';
import 'package:intl/intl.dart';


class RequestLiveStreamPage extends StatefulWidget {
  const RequestLiveStreamPage({Key key}) : super(key: key);

  @override
  _RequestLiveStreamPageState createState() => _RequestLiveStreamPageState();
}

class _RequestLiveStreamPageState extends State<RequestLiveStreamPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  StreamCubit streamCubit;

  @override
  void initState() {
    streamCubit = BlocProvider.of<StreamCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Request Live Stream'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => streamCubit.deleteRequest(),
            )
          ],
        ),
        body: BlocConsumer(
          cubit: streamCubit,
          listener: (context, sate) {},
          builder: (context, state) {
            return Container(
              padding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'First name',
                        ),
                        autocorrect: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          streamCubit.firstName = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          labelText: 'Last name',
                        ),
                        autocorrect: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          streamCubit.lastName = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller,
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.date_range),
                          labelText: 'Birthday',
                        ),
                        autocorrect: false,
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          streamCubit.birthDay = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_balance_sharp),
                          labelText: 'Address',
                        ),
                        autocorrect: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "* Required";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          streamCubit.address = value;
                        },
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () {
                          streamCubit.getImage();
                        },
                        child: streamCubit.imageFile != null
                            ? Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: FileImage(streamCubit.imageFile),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )
                            : Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 34,
                          ),
                        ),
                      ),
                      if (state is ImgIsNull) ...[
                        const SizedBox(height: 16),
                        const Text(
                          '* Required',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                      if (state is Loading) ...[
                        const SizedBox(height: 16),
                        const LinearProgressIndicator(value: null),
                      ],
                      const SizedBox(height: 50),
                      StreamBuilder<QuerySnapshot>(
                        stream: streamCubit.streamStatus(),
                        builder: (c, snapshots) {
                          if (!snapshots.hasData) {
                            return _buildBtn();
                          } else {
                            try {
                              if (snapshots.data.docs.first['status'] == "awaiting") {
                                return const Text('Status: awaiting');
                              } else {
                                return Column(
                                  children: [
                                    Text('Most recent request status: ${snapshots.data.docs.first['status']}'),
                                    const SizedBox(height: 8),
                                    _buildBtn(),
                                  ],
                                );
                              }
                            } catch (e) {
                              return _buildBtn();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBtn() {
    return GestureDetector(
      onTap: () {
        streamCubit.validatorImg();
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          streamCubit.sendRequest();
        }
      },
      child: Container(
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text('Request'),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != controller.text) {
      final DateFormat dateFormat = DateFormat("yyyy/MM/dd");
      setState(() {
        controller.text = dateFormat.format(picked);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    streamCubit.imageFile?.deleteSync();
    streamCubit.imageFile = null;
    super.dispose();
  }
}
