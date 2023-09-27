import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/admin.dart';

class UserRole extends ManagedObject<_UserRole> implements _UserRole {}

class _UserRole {
  @primaryKey
  int? id;
  @Relate(#roleList, isRequired: true, onDelete: DeleteRule.cascade)
  Admin? user;
  int? role;
}
