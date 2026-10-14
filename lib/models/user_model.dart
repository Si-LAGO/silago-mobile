class UserModel {
  final int id;
  final String name;
  final String? nim;
  final String email;
  final String? phone;
  final String? profilePhotoUrl;
  final String? avatarUrl;
  final String role;
  final String status;
  final String? emailVerifiedAt;
  final bool emailDomainVerified;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    this.nim,
    required this.email,
    this.phone,
    this.profilePhotoUrl,
    this.avatarUrl,
    required this.role,
    required this.status,
    this.emailVerifiedAt,
    this.emailDomainVerified = false,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nim: json['nim'] as String?,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      profilePhotoUrl: json['profile_photo_url'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String,
      status: json['status'] as String,
      emailVerifiedAt: json['email_verified_at'] as String?,
      emailDomainVerified: json['email_domain_verified'] as bool? ?? false,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nim': nim,
      'email': email,
      'phone': phone,
      'profile_photo_url': profilePhotoUrl,
      'avatar_url': avatarUrl,
      'role': role,
      'status': status,
      'email_verified_at': emailVerifiedAt,
      'email_domain_verified': emailDomainVerified,
      'created_at': createdAt,
    };
  }
}
