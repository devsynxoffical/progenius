class ProfileModel {
  String? id;
  String? fullName;
  String? email;
  String? role;
  String? phoneNumber;
  String? status;
  String? profileImage; // If image is included later

  ProfileModel({
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.phoneNumber,
    this.status,
    this.profileImage,
  });

  // ✅ Correctly extract data from "data" object
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['data']['_id'],
      fullName: json['data']['fullName'],
      email: json['data']['email'],
      role: json['data']['role'],
      phoneNumber: json['data']['phoneNumber'],
      status: json['data']['status'],
      profileImage: json['data']['file'], // If API returns an image
    );
  }
}
