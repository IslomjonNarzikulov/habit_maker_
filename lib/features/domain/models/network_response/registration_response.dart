class SignUpResponse {
String? token;

SignUpResponse({this.token});

SignUpResponse.fromJson(Map<String, dynamic> json) {
token = json['token'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['token'] = this.token;
return data;
}
}