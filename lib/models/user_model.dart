
class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

// for sending data to firebase/firestore
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
    };
  }

// for recieving the data from firebase/firestore
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uid: json["uid"],
      email: json["email"],
      firstName: json["firstName"],
      lastName: json["lastName"],
    );
  }
}