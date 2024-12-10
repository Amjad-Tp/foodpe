import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String pin;

  @HiveField(3)
  final String? imagePath;

  @HiveField(4)
  final String phoneNumber;

  User({required this.name, required this.email, required this.pin,required this.phoneNumber ,this.imagePath,});
}
