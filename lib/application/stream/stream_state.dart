part of 'stream_cubit.dart';

@immutable
abstract class StreamState {}

class StreamInitial extends StreamState {}

class Loading extends StreamState {}

class GetSuccess extends StreamState {}

class ImgIsNull extends StreamState {}

class Requested extends StreamState {}
