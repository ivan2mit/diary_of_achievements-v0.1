import 'dart:io';

abstract class AppEnv {
  AppEnv._();

  static final String secretKey =
      Platform.environment["SECRET_KEY"] ?? "SECRET_KEY";
  static final String port = Platform.environment["PORT"] ?? "6200";
  static final String dbUsername =
      Platform.environment["DB_USERNAME"] ?? "db_test";
  static final String dbPassword =
      Platform.environment["DB_PASSWORD"] ?? "root";
  static final String dbHost = Platform.environment["DB_HOST"] ?? "localhost";
  static final String dbPort = Platform.environment["DB_PORT"] ?? "5432";
  static final String dbDatabaseName =
      Platform.environment["DB_NAME"] ?? "postgres";

  static final Map<String, int> rolesID = {
    "admin": 1,
    "teacher": 2,
    "student": 3
  };

  static final Map<int, String> roles = {
    1 : "admin",
    2 : "teacher",
    3 : "student"
  };
}
