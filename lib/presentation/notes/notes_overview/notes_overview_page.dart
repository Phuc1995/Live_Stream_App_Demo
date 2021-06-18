import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ddd/application/auth/auth_bloc.dart';
import 'package:flutter_ddd/application/notes/note_actor/note_actor_bloc.dart';
import 'package:flutter_ddd/application/notes/note_watcher/note_watcher_bloc.dart';
import 'package:flutter_ddd/application/stream/stream_cubit.dart';
import 'package:flutter_ddd/domain/admin/request_objects.dart';
import 'package:flutter_ddd/injection.dart';
import 'package:flutter_ddd/presentation/notes/notes_overview/widgets/uncompleted_switch.dart';
import 'package:flutter_ddd/presentation/routes/router.gr.dart';

class NotesOverviewPage extends StatefulWidget {
  const NotesOverviewPage({Key key}) : super(key: key);

  @override
  _NotesOverviewPageState createState() => _NotesOverviewPageState();
}

class _NotesOverviewPageState extends State<NotesOverviewPage> {
  StreamCubit streamCubit;

  @override
  void initState() {
    streamCubit = BlocProvider.of<StreamCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NoteWatcherBloc>(
          create: (context) => getIt<NoteWatcherBloc>()
            ..add(const NoteWatcherEvent.watchAllStarted()),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
        BlocProvider<NoteActorBloc>(
          create: (context) => getIt<NoteActorBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              state.maybeMap(
                unauthenticated: (_) =>
                    ExtendedNavigator.of(context).replace(Routes.signInPage),
                orElse: () {},
              );
            },
          ),
          BlocListener<NoteActorBloc, NoteActorState>(
            listener: (context, state) {
              state.maybeMap(
                deleteFailure: (state) {
                  FlushbarHelper.createError(
                    duration: const Duration(seconds: 5),
                    message: state.noteFailure.map(
                      unexpected: (_) =>
                          'Unexpected error occured while deleting, please contact support.',
                      insufficientPermission: (_) =>
                          'Insufficient permissions ❌',
                      unableToUpdate: (_) => 'Impossible error',
                    ),
                  ).show(context);
                },
                orElse: () {},
              );
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Request List'),
            leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                context.bloc<AuthBloc>().add(const AuthEvent.signedOut());
              },
            ),
            actions: <Widget>[
              UncompletedSwitch(),
            ],
          ),
          body: _buildBody(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ExtendedNavigator.of(context).pushRequestLiveStreamPage();
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: StreamBuilder<QuerySnapshot>(
          stream: streamCubit.getRequest(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            streamCubit.requestList.clear();
            List<QueryDocumentSnapshot> docsList = [];
            docsList.addAll(snapshot.data.docs);
            streamCubit.requestList.addAll(
              docsList.map((e) => RequestStream.fromFireStore(e)).toList(),
            );
            return _buildListView(streamCubit.requestList);
          }),
    );
  }

  ListView _buildListView(List<RequestStream> list) {
    return ListView.builder(
      itemCount: list?.length,
      itemBuilder: (_, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
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
                      list[index].add,
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${list[index].status}',
                        overflow: TextOverflow.ellipsis,
                      ),
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
        );
      },
    );
  }
}
