// ignore_for_file: public_member_api_docs, sort_constructors_first
//   /**
//      * ## FIRST NAME
//      * @param {String} firstName This is the user's first name
//      */

//      * ## LAST NAME
//      * @param {String} lastName This is the user's last name
//      */

//   /**
//      * ## EMAIL
//      * @param {String} email is the user's email adress
//      */

//   /**
//      * ## EMAIL VERIFIED
//      * @param {Boolean} emailVerified This is a tag that shows if the user's email address has been verified or not
//      */

//   /**
//      * ## PROFILE PICTURE
//      * @param {String} profilePicture this is the user's profile picture
//      */
//   profilePicture: {
//     type: String,
//     default: 'default.png',
//   },

//   //* GENDER

//   //* SCHOOL

//   //* ROLE

import 'dart:convert';

import 'package:l_earn/utils/enums.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final bool emailVerified;
  final String? profilePicture;
  final String? gender;
  final String? school;
  final String? role;

  const User({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.emailVerified = false,
    this.profilePicture,
    this.gender,
    this.school,
    this.role
  });

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    bool? emailVerified,
    String? profilePicture,
    String? gender,
    String? school,
    String? role,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      profilePicture: profilePicture ?? this.profilePicture,
      gender: gender ?? this.gender,
      school: school ?? this.school,
      role: role ?? this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'emailVerified': emailVerified,
      'profilePicture': profilePicture,
      'gender': gender,
      'school': school,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      emailVerified: map['emailVerified'] as bool,
      profilePicture: map['profilePicture'] != null ? map['profilePicture'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      school: map['school'] != null ? map['school'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, email: $email, emailVerified: $emailVerified, profilePicture: $profilePicture, gender: $gender, school: $school, role: $role)';
  }

  // @override
  // bool operator ==(covariant User other) {
  //   if (identical(this, other)) return true;
  
  //   return 
  //     other.firstName == firstName &&
  //     other.lastName == lastName &&
  //     other.email == email &&
  //     other.emailVerified == emailVerified &&
  //     other.profilePicture == profilePicture &&
  //     other.gender == gender &&
  //     other.school == school &&
  //     other.role == role;
  // }

  // @override
  // int get hashCode {
  //   return firstName.hashCode ^
  //     lastName.hashCode ^
  //     email.hashCode ^
  //     emailVerified.hashCode ^
  //     profilePicture.hashCode ^
  //     gender.hashCode ^
  //     school.hashCode ^
  //     role.hashCode;
  // }
}
