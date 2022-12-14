import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;

  InternetCubit(this.connectivity) : super(InternetInitial());
  bool _isInit = false;

  Future<void> monitorInternetConnection() async {
    if (!_isInit) {
      final result = await connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        emit(InternetConnectionFail());
      } else {
        emit(InternetConnectionSuccess());
      }
      _isInit = true;
    }

    subscription = connectivity.onConnectivityChanged.listen((connectionState) {
      if (connectionState == ConnectivityResult.none) {
        emit(InternetConnectionFail());
      } else {
        emit(InternetConnectionSuccess());
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}
