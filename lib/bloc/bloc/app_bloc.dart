import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn=GoogleSignIn();
  AuthBloc() : super(AuthInitial()) {
    on<CheckLoginStatusEvent>((event, emit) async{
  User? user;
   try{
    
 await Future.delayed(Duration(seconds: 2),(){
    user=_auth.currentUser;
      });
  if(user != null){
    emit(Authenticated(user));
  }else{
    emit(UnAuthenticated());
  }
   }catch(e){
    emit(AuthenticatedError(message: e.toString()));
   }

    });

     on<RegisterEvent>(((event, emit) async {
      emit(AuthLoading());

      try{
        final userCredential = await _auth.createUserWithEmailAndPassword(
          email: event.user.email.toString(), 
          password: event.user.password.toString());

          final user=userCredential.user;

          if(user != null){
            FirebaseFirestore.instance.collection("users").doc(user.uid).set({
              'uid':user.uid,
              'email':user.email,
              'name':event.user.name,
              'phone':event.user.phone,
              'createdAt':DateTime.now()
            });
            emit(Authenticated(user));
          }else{
            emit(UnAuthenticated());
          }
      }catch(e){
        emit(AuthenticatedError(message: e.toString()));
      }
    }));

    on<LoginEvent>(((event, emit)  async{
      
      emit(AuthLoading());
      try{

        final userCredential= await _auth.signInWithEmailAndPassword(email: event.email, password: event.password);

        final user=userCredential.user;
        if(user != null){
          emit(Authenticated(user));
        }else{
          emit(UnAuthenticated());
        }
      }catch(e){
        emit(AuthenticatedError(message: 'Login failes: $e'));
      }

    }));


    on<LogoutEvent>((event, emit) async{
      
      try{
        await _auth.signOut();
        emit(UnAuthenticated());
      }catch(e){
        emit(AuthenticatedError(message: e.toString()));
      }
    });


    on<GoogleSignInEvent>((event, emit) async {
  emit(AuthLoading());
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } else {
      emit(UnAuthenticated());
    }
  } catch (e) {
    // Log the error for debugging purposes
    // print('Google Sign-In Error: $e');
    emit(AuthenticatedError(message: e.toString()));
  }
});

on<SubmitWorkerRegistrationEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Get the current user
        User? user = _auth.currentUser;
        if (user == null) {
          emit(UnAuthenticated());
          return;
        }

        // Store worker data in Firestore
        await FirebaseFirestore.instance
            .collection("worker_request")
            .doc(user.uid)
            .set(event.workerData);
 print("Worker data written successfully");
        // Store files in Firebase Storage
        for (var file in event.files) {
          String fileName = file['name'];
          String filePath = file['path'];
          
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('worker_files/${user.uid}/$fileName');
          
          await ref.putFile(File(filePath));
          String downloadURL = await ref.getDownloadURL();
          
          // Update the Firestore document with the download URL
          await FirebaseFirestore.instance
              .collection("worker_request")
              .doc(user.uid)
              .update({fileName: downloadURL});
        }

        emit(WorkerRegistrationSubmitted());
      } catch (e) {
        emit(WorkerRegistrationError(message: e.toString()));
      }
    });


  }
}