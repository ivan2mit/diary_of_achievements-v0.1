import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/help_models/user_reward.dart';
import 'package:data/models/db_models/help_models/user_role.dart';
import 'package:data/models/db_models/help_models/user_study_group.dart';

class Admin extends ManagedObject<_Admin> implements _Admin {}

class _Admin {
  @primaryKey
  int? id;

  @Column(nullable: false)
  String? firstName;

  @Column(nullable: false)
  String? surName;

  String? patronymic;

  @Column(unique: true)
  String? email;

  @Column(nullable: false)
  String? hashPassword;
  
  @Column(nullable: false)
  DateTime? birthDate;

  String? phoneNumber;

  ManagedSet<UserRole>? roleList;
  ManagedSet<UserStudyGroup>? studyGroupList;
}
