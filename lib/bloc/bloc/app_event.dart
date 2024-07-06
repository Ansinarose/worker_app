// lib/bloc/splash_event.dart
// ignore_for_file: unused_import

import 'package:equatable/equatable.dart';
import 'package:worker_application/features/auth/models/user_model.dart';

abstract class AuthEvent{

}

class CheckLoginStatusEvent extends AuthEvent{}

//login evnt

class LoginEvent extends AuthEvent{
 final String email;
 final String password;

 LoginEvent({required this.email,required this.password});

}

//Register event

class RegisterEvent extends AuthEvent{
  final UserModel user;
  RegisterEvent({required this.user});
}

class LogoutEvent extends AuthEvent{}

class GoogleSignInEvent extends AuthEvent {}