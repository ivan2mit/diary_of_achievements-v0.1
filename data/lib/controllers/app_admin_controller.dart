import 'dart:io';

import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/help_models/user_reward.dart';
import 'package:data/models/db_models/help_models/user_role.dart';
import 'package:data/models/db_models/user.dart';
import 'package:data/models/response_model.dart';

import 'package:data/models/db_models/lesson.dart';
import 'package:data/models/db_models/admin.dart';
import 'package:data/models/db_models/study_group.dart';
import 'package:data/models/db_models/role.dart';
import 'package:data/models/db_models/reward.dart';
import 'package:data/utils/app_env.dart';
import 'package:data/utils/app_response.dart';

class AppAdminGroupController extends ResourceController {
  AppAdminGroupController(this.managedContext);
  final ManagedContext managedContext;

  //Добавление группы
  //admin/group
  @Operation.put()
  Future<Response> createStudyGroup(@Bind.body() StudyGroup sGroup) async {
    //проверка, что пользователь имеет доступ к созданию групп
    //проверка заполнения важных полей
    if (sGroup.title == null) {
      return AppResponse.badRequest(message: "Название группы обязательно");
    }

    late final int groupId;
    try {
      await managedContext.transaction((transaction) async {
        final qCreateGroup = Query<StudyGroup>(transaction)
          ..values.title = sGroup.title
          ..values.description = sGroup.description
          ..values.numberOfStudents = 0;

        final qCreatedGrup = await qCreateGroup.insert();
        groupId = qCreatedGrup.asMap()["id"];
      });
      final dataCreatedGroup =
          await managedContext.fetchObjectWithID<StudyGroup>(groupId);
      Map<String, dynamic> data = dataCreatedGroup!.asMap();
      return AppResponse.ok(message: "Группа успешно добавлена", body: data);
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания группы");
    }
  }
}

class AppAdminLessonController extends ResourceController {
  AppAdminLessonController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.put("studentId")
  Future<Response> createReward(
      @Bind.query("reward") String reward,
      @Bind.query("description") String description,
      @Bind.query("lessonId") int lessonId) async {
    //проверка, что пользователь имеет доступ к созданию групп
    //проверка заполнения важных полей
    //final int lessonId = int.parse(request!.path.variables["idLesson"]!);
    //final int studentId = int.parse(request!.path.variables["idStudent"]!);
    final int studentId = int.parse(request!.path.variables["studentId"]!);
    late final FetchStudent;
    late final FetchLesson;
    late final FetchReward;
    try {
      FetchStudent = await managedContext.fetchObjectWithID<User>(studentId);

      FetchLesson = await managedContext.fetchObjectWithID<Lesson>(lessonId);

      FetchReward = await managedContext.fetchObjectWithID<Reward>(reward);
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Такой урок или ученик не найден");
    }

    late final rewardID;
    try {
      await managedContext.transaction((transaction) async {
        final qCreateReward = Query<UserReward>(transaction)
          ..values.lesson = FetchLesson
          ..values.student = FetchStudent
          ..values.reward = FetchReward;
        final qInsertLesson = await qCreateReward.insert();
        rewardID = qInsertLesson.asMap()["id"];
      });
      final dataCreatedReward =
          await managedContext.fetchObjectWithID<UserReward>(rewardID);
      Map<String, dynamic> data = dataCreatedReward!.asMap();
      return AppResponse.ok(message: "Урок успешно добавлен", body: data);
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания урока");
    }
  }

  @Operation.get("studentId")
  Future<Response> getRewardsStudentByLesson(
      @Bind.query("lessonId") int lessonId,
      @Bind.path("studentId") int studentId) async {
    print(studentId);
    print(lessonId);
    try {
      return AppResponse.ok(message: "Оценки успешно переданы");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка получения оценок");
    }
  }

  @Operation.post("studentId")
  Future<Response> chengeReward(
      @Bind.query("reward") String reward,
      @Bind.query("description") String description,
      @Bind.query("rewardId") int rewardId) async {
    print("Изменяем Оценку");
    print(rewardId);
    try {
      return AppResponse.ok(message: "Оценка успешно изменена");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка изменения оценки");
    }
  }

  @Operation.get()
  Future<Response> getRewardsByLesson(
      @Bind.query("lessonId") int lessonId) async {
    print("Передаю все оценки за урок");
    print(lessonId);
    try {
      return AppResponse.ok(message: "Оценки успешно переданы");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка получения оценок");
    }
  }

  @Operation.post()
  Future<Response> chengeLesson(
      @Bind.query("lessonId") int lessonId, @Bind.body() Lesson newLesson) async {
    print("Изменяем урок");
    print(lessonId);
    try {
      return AppResponse.ok(message: "Урок успешно изменен");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка получения оценок");
    }
  }

  @Operation.put()
  Future<Response> createLesson(
      @Bind.body() Lesson lesson, 
      @Bind.query("groupId") groupId) async {
    //проверка, что пользователь имеет доступ к созданию групп
    //проверка заполнения важных полей
    //final int groupId = int.parse(request!.path.variables["idGroup"]!);
    if (lesson.title == null) {
      return AppResponse.badRequest(message: "Тема урока обязательна");
    }

    late final fetchStudyGroup;
    try {
      fetchStudyGroup =
          await managedContext.fetchObjectWithID<StudyGroup>(groupId);
    } catch (e) {
      return AppResponse.serverError(e,
          message: "Группа с таким id не найдена");
    }

    late final lessonID;
    try {
      await managedContext.transaction((transaction) async {
        final qCreateLesson = Query<Lesson>(transaction)
          ..values.title = lesson.title
          ..values.description = lesson.description
          ..values.date = lesson.date
          ..values.studyGroup = fetchStudyGroup;
        final createdLesson = await qCreateLesson.insert();
        lessonID = createdLesson.asMap()["id"];
      });
      print(lessonID);
      final dataCreatedLesson =
          await managedContext.fetchObjectWithID<Lesson>(lessonID);
      Map<String, dynamic> data = dataCreatedLesson!.asMap();
      return AppResponse.ok(message: "Урок успешно добавлен", body: data);
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания урока");
    }
  }

}

class AppAdminUserController extends ResourceController {
  AppAdminUserController(this.managedContext);
  final ManagedContext managedContext;

  @Operation.put()
  Future<Response> createUser(@Bind.body() User student) async {
    late final studentId;
    try {
      await managedContext.transaction((transaction) async {
        final qCreateStudent = Query<User>(transaction)
          ..values.firstName = student.firstName
          ..values.surName = student.surName
          ..values.patronymic = student.patronymic
          ..values.email = student.email
          ..values.hashPassword = student.hashPassword
          ..values.birthDate = student.birthDate
          ..values.phoneNumber = student.phoneNumber;

        final qCreatedStudent = await qCreateStudent.insert();
        studentId = qCreatedStudent.asMap()["id"];
      });
      print("ghbyn");
      final createdStudent =
          await managedContext.fetchObjectWithID<User>(studentId);
      Map<String, dynamic> data = createdStudent!.asMap();
      print("ghbyn");
      return AppResponse.ok(
          body: data, message: "Успешная регистрация ученика");
    } catch (e) {
      return AppResponse.serverError(e, message: "Ошибка создания ученика");
    }
  }
}

class AppAdminrewardController extends ResourceController {
  AppAdminrewardController(this.managedContext);
  final ManagedContext managedContext;
}

class AppAdminRewardController extends ResourceController {
  AppAdminRewardController(this.managedContext);
  final ManagedContext managedContext;
}

class AppAdminController extends ResourceController {
  //Конструктор который передаваемое значение кладет в managedContext
  AppAdminController(this.managedContext);
  final ManagedContext managedContext;

  //put
  //Future<Response>? createUser() {}
  //get
  Future<Response>? getUser() {}
  //delite
  Future<Response>? deliteUser() {}
  //role/put
  Future<Response>? addUserRole() {}
  //role/get
  Future<Response>? getUserRoles() {}
  Future<bool>? checkUserRole() {}
  //role/delite
  Future<Response>? deliteUserRole() {}

  //Добавление урока для занятия
  //admin/group:idgroup/lesson

  //Регистрация пользователя
  @Operation.put()
  Future<Response> createUser(
      @Bind.body() Admin user, @Bind.query("role") String role) async {
    if (role != "student" &&
        (user.firstName == null ||
            user.surName == null ||
            user.email == null)) {
      return AppResponse.badRequest(
          message: " Поля имя, фамилия, email обязательны");
    }

    try {
      late final int id;
      late int? roleId;
      await managedContext.transaction((transaction) async {
        final qCreateUser = Query<Admin>(transaction)
          ..values.firstName = user.firstName
          ..values.surName = user.surName
          ..values.patronymic = user.patronymic
          ..values.email = user.email;
        final createdUser = await qCreateUser.insert();
        id = createdUser.asMap()["id"];

        final qSetUserRole = Query<UserRole>(transaction)
          ..values.user = createdUser
          ..values.role = AppEnv.rolesID[role];

        final createdRole = await qSetUserRole.insert();
        roleId = createdRole.asMap()["role"];
      });
      final userData = await managedContext.fetchObjectWithID<Admin>(id);
      Map<String, dynamic> data = userData!.asMap();
      data.addEntries(<String, dynamic>{"role": roleId}.entries);

      return AppResponse.ok(body: data, message: "успешная регистрация");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка регистрации");
    }
  }

  // @Operation.post()
  // Future<Response> getNameById(@Bind.body() User student) async {
  //   if (student.id == null) {
  //     return Response.badRequest(
  //         body: MyResponseModel(message: "Поле id обязательно"));
  //   }
  //   try {
  //     final qFindStudent = Query<User>(managedContext)
  //       ..where((table) => table.id).greaterThan(0)
  //       ..returningProperties((table) => [table.firstName, table.surName]);
  //     final findStudent = await qFindStudent.fetch();
  //     if (findStudent.length == 0) {
  //       throw QueryException.input("Пользователь не найден", []);
  //     }
  //     final Map<String, dynamic> students = {};
  //     for (int i = 0; i < findStudent.length; i++) {
  //       students[(findStudent[i].id).toString()] = findStudent[i].surName;
  //     }
  //     return Response.ok(MyResponseModel(
  //         data: students, message: "Пользователи успешно найдены"));
  //   } on QueryException catch (error) {
  //     return Response.serverError(
  //         body: MyResponseModel(message: error.message));
  //   }
  // }

  // @Operation.put()
  // Future<Response> createStudent(@Bind.body() User student) async {
  //   if (student.firstName == null || student.surName == null) {
  //     return Response.badRequest(
  //         body: MyResponseModel(message: "Поля имя и фамилия обязательны"));
  //   }

  //   try {
  //     late final int id;
  //     await managedContext.transaction((transaction) async {
  //       final qCreateStudent = Query<User>(transaction)
  //         ..values.firstName = student.firstName
  //         ..values.surName = student.surName;

  //       final createdStudent = await qCreateStudent.insert();
  //       id = createdStudent.asMap()["id"];
  //     });
  //     final studentData = await managedContext.fetchObjectWithID<User>(id);

  //     return Response.ok(MyResponseModel(
  //       data: studentData?.backing.contents,
  //       message: "Успешное добавление ученика",
  //     ));
  //   } on QueryException catch (error) {
  //     return Response.serverError(
  //         body: MyResponseModel(message: error.message));
  //   }
  //   // return Response.ok(MyResponseModel(data: {
  //   //   "id": "полученное ID",
  //   //   "firstName": student.firstName,
  //   //   "surName": student.surName,
  //   // }, message: "Ученик добавлен"));
  // }

  // @Operation.post("presence")
  // Future<Response> markPresence() async {
  //   return Response.ok(MyResponseModel(data: {
  //     "id": "1",
  //   }).toJson());
  // }
}
