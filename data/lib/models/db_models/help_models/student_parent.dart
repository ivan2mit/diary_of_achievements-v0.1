import 'package:conduit_core/conduit_core.dart';

class StudentParent extends ManagedObject<_StudentParent>
    implements _StudentParent {}

class _StudentParent {
  @primaryKey
  int? id;
}
