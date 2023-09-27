import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/help_models/user_reward.dart';
import 'package:data/models/db_models/study_group.dart';

class Lesson extends ManagedObject<_Lesson> implements _Lesson {
  //late DateTime date;
  // @override
  // void willInsert() {
  //   date = new DateTime.now().toUtc();
  // }
}

class _Lesson {
  @primaryKey
  int? id;
  String? title;
  DateTime? date;
  String? description;
  @Relate(#lessonList)
  StudyGroup? studyGroup;
  ManagedSet<UserReward>? rewardList;
}
