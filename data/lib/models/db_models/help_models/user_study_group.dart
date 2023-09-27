import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/study_group.dart';
import 'package:data/models/db_models/admin.dart';
import 'package:data/models/db_models/user.dart';

class UserStudyGroup extends ManagedObject<_UserStudyGroup>
    implements _UserStudyGroup {}

class _UserStudyGroup {
  @primaryKey
  int? id;
  @Relate(#studyGroupList, onDelete: DeleteRule.cascade)
  Admin? teacher;
  @Relate(#studyGroupList, onDelete: DeleteRule.cascade)
  User? student;
  @Relate(#userList, isRequired: true, onDelete: DeleteRule.cascade)
  StudyGroup? studyGroup;
}
