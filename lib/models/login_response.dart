/// user : {"id":"fd3c52fd-dc4f-499c-95b9-6294b3cb46d6","firstName":"John","lastName":"Doe","email":"user@mail.com","createdAt":"2023-11-11T08:56:00.398Z","updatedAt":"2023-11-11T08:56:00.398Z","role":"USER"}
/// token : {"accessToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImZkM2M1MmZkLWRjNGYtNDk5Yy05NWI5LTYyOTRiM2NiNDZkNiIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzA1MTQ1MzI3LCJleHAiOjE3MDUxNDg5Mjd9.mLo4xWpX7RK9nSflDkaJSAO0MAIjl0mqgfbknUSqjuY"}

class LoginResponse {
  LoginResponse({
    User? user,
    Token? token,
  }) {
    _user = user;
    _token = token;
  }

  LoginResponse.fromJson(dynamic json) {
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _token = json['token'] != null ? Token.fromJson(json['token']) : null;
  }

  User? _user;
  Token? _token;
  LoginResponse copyWith({
    User? user,
    Token? token,
  }) =>
      LoginResponse(
        user: user ?? _user,
        token: token ?? _token,
      );
  User? get user => _user;
  Token? get token => _token;
}

/// accessToken : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImZkM2M1MmZkLWRjNGYtNDk5Yy05NWI5LTYyOTRiM2NiNDZkNiIsInJvbGUiOiJVU0VSIiwiaWF0IjoxNzA1MTQ1MzI3LCJleHAiOjE3MDUxNDg5Mjd9.mLo4xWpX7RK9nSflDkaJSAO0MAIjl0mqgfbknUSqjuY"

class Token {
  Token({
    String? accessToken,
    String? refreshToken,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Token.fromJson(dynamic json) {
    _accessToken = json['accessToken'];
    _refreshToken = json['refreshToken'];
  }

  String? _accessToken;
  String? _refreshToken;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
}

/// id : "fd3c52fd-dc4f-499c-95b9-6294b3cb46d6"
/// firstName : "John"
/// lastName : "Doe"
/// email : "user@mail.com"
/// createdAt : "2023-11-11T08:56:00.398Z"
/// updatedAt : "2023-11-11T08:56:00.398Z"
/// role : "USER"

class User {
  User({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? createdAt,
    String? updatedAt,
    String? role,
  }) {
    _id = id;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _role = role;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _firstName = json['firstName'];
    _lastName = json['lastName'];
    _email = json['email'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _role = json['role'];
  }

  String? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _createdAt;
  String? _updatedAt;
  String? _role;
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? createdAt,
    String? updatedAt,
    String? role,
  }) =>
      User(
        id: id ?? _id,
        firstName: firstName ?? _firstName,
        lastName: lastName ?? _lastName,
        email: email ?? _email,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        role: role ?? _role,
      );
  String? get id => _id;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['email'] = _email;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['role'] = _role;
    return map;
  }
}
