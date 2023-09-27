import 'package:conduit_core/conduit_core.dart';
import 'package:data/models/db_models/lesson.dart';
import 'package:data/models/db_models/help_models/user_study_group.dart';

class StudyGroup extends ManagedObject<_StudyGroup> implements _StudyGroup {}

class _StudyGroup {
  @primaryKey
  int? id;

  @Column(nullable: false, indexed: true)
  String? title;

  @Column(nullable: false, indexed: true)
  int? numberOfStudents;

  String? description;
  
  ManagedSet<Lesson>? lessonList;
  ManagedSet<UserStudyGroup>? userList;
}
