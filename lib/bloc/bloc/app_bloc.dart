import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_application/bloc/bloc/app_event.dart';
import 'package:worker_application/bloc/bloc/app_state.dart';

class splashBloc extends Bloc<SplashEvent, splashState> {
  splashBloc() : super(splashInitial()){
    on<StartSplash>(_onstartSplash);
  }

  Future<void> _onstartSplash(StartSplash event,Emitter<splashState> emit) async {
    emit(splashLoading());
    await Future.delayed(Duration(seconds: 3));
    emit(splashLoaded());
  }
}