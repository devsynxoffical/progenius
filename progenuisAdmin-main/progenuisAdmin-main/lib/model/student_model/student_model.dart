class Customer {
  final String? id;
  final String? fullName;
  final String? email;
  final String? role;
  final String? phoneNumber;
  final String? profilePicture;
   final String? destination;
  final String? status;
   bool? hasAccess;

  Customer({
    this.id,
    this.fullName,
    this.email,
    this.role,
    this.phoneNumber,
    this.profilePicture,
    this.destination,
    this.status,
    this.hasAccess
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      profilePicture: json['profilePicture'],
      destination: json['destination'],
      status: json['status'],
      hasAccess: json['hasAccess'],

    );
  }
}
