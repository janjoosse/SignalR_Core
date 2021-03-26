import 'package:get_it/get_it.dart';
import 'package:signalrcore_bug/signalr_connection_service.dart';

GetIt locator = GetIt.instance;

void locatorSetup() {
  locator.registerLazySingleton<SignalrConnectionService>(() => SignalrConnectionService());
}