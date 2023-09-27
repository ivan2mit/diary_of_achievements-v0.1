import 'dart:io';

import 'package:conduit_core/conduit_core.dart';
import 'package:data/data.dart';

Future main() async {
  //Будем брать из переменных окружения, когда запустим в докере
  final int port = int.parse(Platform.environment["PORT"] ?? "8080");
  //Приложение описано в файле test_service
  final app = Application<AppService>()
    ..options.port = port;

  await app.start(numberOfInstances: 3, consoleLogging: true);
}


