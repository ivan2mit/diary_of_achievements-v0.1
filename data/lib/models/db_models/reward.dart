import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/help_models/user_reward.dart';

class Reward extends ManagedObject<_Reward> implements _Reward {}

class _Reward {
  @primaryKey
  int? id;
  String? title;
  String? description;
  ManagedSet<UserReward>? rewardList;
}
