import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/help_models/user_role.dart';

class Role extends ManagedObject<_Role> implements _Role {}

class _Role {
  @primaryKey
  int? id;
  String? title;
}
