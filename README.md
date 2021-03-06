## The steps build project on local:
- [**Environment**]: 
	+ Flutter: 1.0< version <2.0
	+ Dart: version < 2.12 
- [**Build**]: run cmd: flutter pub get
- [**Account**]: 
 	+ User: register via Account Google or google mail.
 	+ Admin: admin@gmail.com pass: admin123
 - If have any issue with the build local, you can use the link (https://drive.google.com/drive/u/0/folders/1_brVPricc7e5eq4_UjfNCGNWKS_ttLZu) to download the app(Android). I hope that will not happen.

## Estimation for task:
- **Read and analyze requirement**: 1h
- **Coding**: 6h
- **Writting Readme file**: 2h

## Some task can't do:
- [**Notification**]:
	+ Root cause: I don't have more time to build a server to complete this task.
	+ Solution: I can use libary ANGEL(https://angel-dart.dev/) of Dart(I have built a server to handle HTTP, upload data and parser file as XML, Json on my old project), Spring Boot(Java)
- [**Function Live Stream**]: 
	+ Solution: User can create a Live Stream their channel Youtube. On the app, I will use the plugin youtube_player_flutter(https://pub.dev/packages/youtube_player_flutter), webview_flutter(https://pub.dev/packages/webview_flutter). It will solve the problem of too large database from users and the problem of not having a server

## There are some screens:
- [**Screen login and register**]: You can register new User via Account Google(symbol Google) or new mail(button Register, input value on 2 text file login). All authentication was managed by Firebase Auth.
 
<img src="https://github.com/Phuc1995/Live_Stream_App_Demo/blob/master/assets/login_page.jpeg" width="300" height="600"> <img src="https://github.com/Phuc1995/Live_Stream_App_Demo/blob/master/assets/google.jpeg" width="300" height="600"> 

- [**Screen user request form**]
<img src="https://github.com/Phuc1995/Live_Stream_App_Demo/blob/master/assets/request_page.jpeg" width="300" height="500">

- [**Screen Admin**]

<img src="https://github.com/Phuc1995/Live_Stream_App_Demo/blob/master/assets/admin_page.jpeg" width="300" height="500">
														   
														   

#### Dependencies

 - [**BLoC**](https://pub.dev/packages/flutter_bloc), Widgets that make it easy to integrate blocs and cubits into Flutter
 - [**Dartz**](https://pub.dev/packages/dartz), Functional programming in Dart
 - [**Get It**](https://pub.dev/packages/get_it), This is a simple Service Locator for Dart and Flutter projects
 - [**Auto Route**](https://pub.dev/packages/auto_route), It uses code generation to simplify routes setup
 - [**Firebase Auth**](https://pub.dev/packages?q=Firebase+Auth), Flutter plugin for Firebase Auth, enabling Android and iOS authentication using passwords, phone numbers and identity providers like Google, Facebook and Twitter.
 - [**Firebase Core**](https://pub.dev/packages/firebase_core), Flutter plugin for Firebase Core, enabling connecting to multiple Firebase apps
 - [**Cloud Firestore**](https://pub.dev/packages?q=cloud_firestore), Flutter plugin for Cloud Firestore, a cloud-hosted, noSQL database with live synchronization and offline support on Android and iOS
 - [**Freezed Annotation**](https://pub.dev/packages?q=freezed_annotation), Annotations for the freezed code-generator. This package does nothing without freezed too.
 - [**Google Sign_in**](https://pub.dev/packages?q=google_sign_in), Flutter plugin for Google Sign-In, a secure authentication system for signing in with a Google account on Android and iOS.
 - [**Injectable**](https://pub.dev/packages?q=injectable), Injectable is a convenient code generator for get_it. Inspired by Angular DI, Guice DI and inject.dart
 - [**Kt Dart**](https://pub.dev/packages/kt_dart), This project is a port of kotlin-stdlib for Dart/Flutter projects. It includes collections (KtList, KtMap, KtSet) with 150+ methods as well as other useful packages.

### Clean Architecture Proposal
![CleanArchitecture](https://github.com/Phuc1995/Flutter_DDD_Architecture/blob/main/image/Architecture_Proposal.PNG)

### Flowchart
![Clean-Architecture-Flutter-Diagram](https://github.com/Phuc1995/Flutter_DDD_Architecture/blob/main/image/Flow_chart.PNG)

