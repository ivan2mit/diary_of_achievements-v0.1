import 'package:conduit_core/conduit_core.dart';
import 'package:conduit_postgresql/conduit_postgresql.dart';
import 'package:data/controllers/app_admin_controller.dart';
import 'package:data/utils/app_env.dart';

class AppService extends ApplicationChannel {
  late final ManagedContext managedContext;

  @override
  Future prepare() {
    final persistentStore = _initDataBase();
    managedContext = ManagedContext(
        ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }

  @override
  // TODO: implement entryPoint
  Controller get entryPoint => Router()
//admin/lesson/studentId?lessonId=..&reward=..&description=..   put createReward поставить оценку ученику
//admin/lesson/studentId?lessonId=..                            get getRewardsStudentByLesson получить все оценки ученика за урок
//admin/lesson/studentId?rewardId=..&reward=..&description=..   post изменить оценку
//admin/lesson?lessonId=..           body=lesson                post изменить описание урока
//admin/lesson?lessonId=..                                      get получить все оценки за урок
//admin/lesson?groupId=..            body=lesson                put создать урок
// создать учебную группу
// Изменить описание группы
// Удалить группу
// Добавить ученика в учебную группу
// добавить учителя в учебную группу
// Удалить ученика из учебной группы
// Удалить учителя из учебной группы
// Получить список учителей в учебной группе
// Получить список учеников в учебной группе
// Получить список уроков в учебной группе


    //admin добавить пользователя
    //admin/group добавить группу
    //фвьшт/group[idgroup]/lesson создать новый урок
    ..route("admin/reward[/:idReward]")
      .link(() => AppAdminRewardController(managedContext))
    ..route("admin/user[/:idUser]")
        .link(() => AppAdminUserController(managedContext))
    // ..route("admin/lesson[/:idLesson]")
    //     .link(() => AppAdminRewardController(managedContext))
    ..route("admin/lesson/:studentId")
        .link(() => AppAdminLessonController(managedContext))
    ..route("admin/lesson")
        .link(() => AppAdminLessonController(managedContext))
    ..route("admin/group[/:idGroup]")
        .link(() => AppAdminGroupController(managedContext));

  PostgreSQLPersistentStore _initDataBase() {
    return PostgreSQLPersistentStore(
      AppEnv.dbUsername,
      AppEnv.dbPassword,
      AppEnv.dbHost,
      int.parse(AppEnv.dbPort),
      AppEnv.dbDatabaseName,
    );
  }
}
