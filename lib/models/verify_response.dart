class VerifyResponse {
  User? user;
  Token? token;

  VerifyResponse({this.user, this.token});

  VerifyResponse.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    token = json['token'] != null ? Token.fromJson(json['token']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (token != null) {
      data['token'] = token!.toJson();
    }
    return data;
  }
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? createdAt;
  String? updatedAt;
  String? role;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.createdAt,
        this.updatedAt,
        this.role});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['role'] = role;
    return data;
  }
}

class Token {
  String? accessToken;
  String? refreshToken;

  Token({this.accessToken, this.refreshToken});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['accessToken'] = accessToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}