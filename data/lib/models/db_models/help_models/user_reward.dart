import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/lesson.dart';
import 'package:data/models/db_models/reward.dart';
import 'package:data/models/db_models/admin.dart';
import 'package:data/models/db_models/user.dart';

class UserReward extends ManagedObject<_UserReward> implements _UserReward {}

class _UserReward {
  @primaryKey
  int? id;
  @Relate(#rewardList, isRequired: true, onDelete: DeleteRule.cascade)
  User? student;
  @Relate(#rewardList, isRequired: true, onDelete: DeleteRule.cascade)
  Lesson? lesson;
  @Relate(#rewardList)
  Reward? reward;
}
