// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class User {
  final String firstName;
  final String lastName;
  final int followers;
  
  final int? level;
  final String? email;
  final String? department;
  final bool? emailVerified;
  final bool? isVerified;
  final String? profilePicture;
  final String? banner;
  final String? gender;
  final String? school;
  final String? role;
  final String? token;
  final String? handle;
  final String? id;

  const User(
      {required this.firstName,
      required this.lastName,
      required this.followers,
      
      this.level,
      this.email,
      this.department,
      this.emailVerified = false,
      this.isVerified = false,
      this.profilePicture,
      this.banner,
      this.gender,
      this.school,
      this.role,
      required this.handle,
      this.id,
      this.token});

  User copyWith(
      {String? firstName,
      String? lastName,
      int? followers,
      
      String? email,
      String? department,
      int? level,
      bool? emailVerified,
      bool? isVerified,
      String? profilePicture,
      String? banner,
      String? gender,
      String? school,
      String? role,
      String? token}) {
    return User(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        department: department ?? this.department,
        level: level ?? this.level,
        emailVerified: emailVerified ?? this.emailVerified,
        isVerified: isVerified ?? this.isVerified,
        profilePicture: profilePicture ?? this.profilePicture,
        banner: banner ?? this.banner,
        gender: gender ?? this.gender,
        school: school ?? this.school,
        role: role ?? this.role,
        token: token ?? this.token,
        handle: handle,
        followers: followers ?? this.followers,
        
        id: id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'department': department,
      'level': level,
      'emailVerified': emailVerified,
      'isVerified': isVerified,
      'profilePicture': profilePicture,
      'banner': banner,
      'gender': gender,
      'school': school,
      'role': role,
      'token': token,
      'handle': handle,
      'followers': followers,
      
      '_id': id
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      level: map['level'],
      
      followers: map['followers'] ?? 0, //TODO: CONFIRM FROM BACKEND
      email: map['email'] != null ? map['email'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      emailVerified:
          map['emailVerified'] != null ? map['emailVerified'] as bool : null,
      isVerified: map['isVerified'] != null ? map['isVerified'] as bool : null,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
      banner: map['banner'] != null ? map['banner'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      school: map['school'] != null ? map['school'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      handle: map['handle'] != null ? map['handle'] as String : null,
      id: map['_id'] != null ? map['_id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, level: $level, department: $department handle: $handle, isVerified: $isVerified, email: $email, emailVerified: $emailVerified, banner: $banner, profilePicture: $profilePicture, gender: $gender, school: $school, role: $role, token: $token, id $id)';
  }
}

class EmbeddedUser extends User {
  const EmbeddedUser(
      {required super.firstName,
      required super.lastName,
      required super.followers,
      required super.email,
      required super.id,
      super.profilePicture,
      super.handle});
}
