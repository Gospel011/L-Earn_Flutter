// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'dart:convert';

import 'package:l_earn/utils/enums.dart';

class User {
  final String firstName;
  final String lastName;
  final String? email;
  final bool? emailVerified;
  final bool? isVerified;
  final String? profilePicture;
  final String? gender;
  final String? school;
  final String? role;
  final String? token;
  final String? handle;
  final String? id;

  const User(
      {required this.firstName,
      required this.lastName,
      this.email,
      this.emailVerified = false,
      this.isVerified = false,
      this.profilePicture,
      this.gender,
      this.school,
      this.role,
      required this.handle,
      this.id,
      this.token});

  User copyWith(
      {String? firstName,
      String? lastName,
      String? email,
      bool? emailVerified,
      bool? isVerified,
      String? profilePicture,
      String? gender,
      String? school,
      String? role,
      String? token}) {
    return User(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        emailVerified: emailVerified ?? this.emailVerified,
        isVerified: isVerified ?? this.isVerified,
        profilePicture: profilePicture ?? this.profilePicture,
        gender: gender ?? this.gender,
        school: school ?? this.school,
        role: role ?? this.role,
        token: token ?? this.token,
        handle: handle,
        id: id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'emailVerified': emailVerified,
      'isVerified': isVerified,
      'profilePicture': profilePicture,
      'gender': gender,
      'school': school,
      'role': role,
      'token': token,
      'handle': handle,
      '_id': id
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      emailVerified: map['emailVerified'] != null ? map['emailVerified'] as bool : null,
      isVerified: map['isVerified'] != null ? map['isVerified'] as bool : null,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
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
    return 'User(firstName: $firstName, lastName: $lastName, handle: $handle, isVerified: $isVerified, email: $email, emailVerified: $emailVerified, profilePicture: $profilePicture, gender: $gender, school: $school, role: $role, token: $token, id $id)';
  }
}

class EmbeddedUser extends User {
  const EmbeddedUser(
      {required super.firstName,
      required super.lastName,
      required super.email,
      required super.id,
      super.profilePicture,
      super.handle});
}
