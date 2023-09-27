import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/response_model.dart';

import 'package:data/models/db_models/lesson.dart';
import 'package:data/models/db_models/admin.dart';
import 'package:data/models/db_models/study_group.dart';
import 'package:data/models/db_models/role.dart';
import 'package:data/models/db_models/reward.dart';

class AppStudyGroupController extends ResourceController {
  //Конструктор который передаваемое значение кладет в managedContext
  AppStudyGroupController(this.managedContext);
  final ManagedContext managedContext;

  Future<Response>? createStudyGroup() {}
  Future<Response>? getStudyGroupsByTeacher() {}
  Future<Response>? getStudyGroupById() {}
  Future<Response>? deliteStudyGroup() {}

  Future<Response>? addTeacher() {}
  Future<Response>? getTeachers() {}
  Future<Response>? deliteTeacher() {}

  Future<Response>? addStudent() {}
  Future<Response>? getStudents() {}
  Future<Response>? deliteStudent() {}

  Future<Response>? addLesson() {}
  Future<Response>? getLessonsByStudyGroup() {}
  Future<Response>? getLessonsByTeacher() {}
  Future<Response>? getLessonsByStudent() {}
  Future<Response>? deliteLesson() {}

  Future<Response>? createReward() {}
  Future<Response>? chengeReward() {}
  Future<Response>? deliteReward() {}

  @Operation.post()
  Future<Response> getNameById(@Bind.body() Admin student) async {
    if (student.id == null) {
      return Response.badRequest(
          body: MyResponseModel(message: "Поле id обязательно"));
    }
    try {
      final qFindStudent = Query<Admin>(managedContext)
        ..where((table) => table.id).greaterThan(0)
        ..returningProperties((table) => [table.firstName, table.surName]);
      final findStudent = await qFindStudent.fetch();
      if (findStudent.length == 0) {
        throw QueryException.input("Пользователь не найден", []);
      }
      final Map<String, dynamic> students = {};
      for (int i = 0; i < findStudent.length; i++) {
        students[(findStudent[i].id).toString()] = findStudent[i].surName;
      }
      return Response.ok(MyResponseModel(
          data: students, message: "Пользователи успешно найдены"));
    } on QueryException catch (error) {
      return Response.serverError(
          body: MyResponseModel(message: error.message));
    }
  }

  @Operation.put()
  Future<Response> createStudent(@Bind.body() Admin student) async {
    if (student.firstName == null || student.surName == null) {
      return Response.badRequest(
          body: MyResponseModel(message: "Поля имя и фамилия обязательны"));
    }

    try {
      late final int id;
      await managedContext.transaction((transaction) async {
        final qCreateStudent = Query<Admin>(transaction)
          ..values.firstName = student.firstName
          ..values.surName = student.surName;

        final createdStudent = await qCreateStudent.insert();
        id = createdStudent.asMap()["id"];
      });
      final studentData = await managedContext.fetchObjectWithID<Admin>(id);

      return Response.ok(MyResponseModel(
        data: studentData?.backing.contents,
        message: "Успешное добавление ученика",
      ));
    } on QueryException catch (error) {
      return Response.serverError(
          body: MyResponseModel(message: error.message));
    }
    // return Response.ok(MyResponseModel(data: {
    //   "id": "полученное ID",
    //   "firstName": student.firstName,
    //   "surName": student.surName,
    // }, message: "Ученик добавлен"));
  }

  @Operation.post("presence")
  Future<Response> markPresence() async {
    return Response.ok(MyResponseModel(data: {
      "id": "1",
    }).toJson());
  }
}
