// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
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
   //  print("User is authenticated with UID: ${user?.uid}");
    emit(Authenticated(user));
  }else{
   // print("User is not authenticated");
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
    print("Starting Google Sign In process");
    
    // Trigger the Google Sign-In flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    
    if (googleUser == null) {
      print("Google Sign In was cancelled by the user");
      emit(UnAuthenticated());
      return;
    }
    
    print("Google Sign In successful for user: ${googleUser.email}");

    // Obtain auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    print("Obtained Google Sign In Authentication");

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print("Created Google Auth Credential");

    // Sign in to Firebase with the Google Auth Credential
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      print("Successfully signed in with Google. User ID: ${user.uid}");
      
      // Check if it's a new user
      if (userCredential.additionalUserInfo?.isNewUser ?? false) {
        print("This is a new user. Creating Firestore record.");
        // Create a new document for the user in Firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': user.displayName,
          'photoUrl': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      emit(Authenticated(user));
    } else {
      print("Failed to sign in with Google: User is null");
      emit(UnAuthenticated());
    }
  } catch (e) {
    print('Detailed Google Sign-In Error: $e');
    if (e is FirebaseAuthException) {
      print('Firebase Auth Error Code: ${e.code}');
      print('Firebase Auth Error Message: ${e.message}');
    } else if (e is PlatformException) {
      print('Platform Error Code: ${e.code}');
      print('Platform Error Message: ${e.message}');
      print('Platform Error Details: ${e.details}');
    }
    emit(AuthenticatedError(message: 'Google Sign-In failed: $e'));
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

        Map<String, dynamic> workerData = {
      ...event.workerData,
      'registrationAccepted': false,
      'uid':user.uid,
    };
 // print("Attempting to create worker document with UID: ${user.uid}");
        // Store worker data in Firestore
        await FirebaseFirestore.instance
            .collection("workers_request")
            .doc(user.uid)
            .set(workerData);
 //print("Worker data written successfully for uid: ${user.uid}");
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
              .collection("workers_request")
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