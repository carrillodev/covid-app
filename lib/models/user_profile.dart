class UserProfile {
  final bool completed;
  final String nombres;
  final String apellidos;
  final String fechaNacimiento;
  final String folio;
  final String? imgType;
  final String? imgUrl;
  final String sexo;

  const UserProfile(
      {required this.completed,
      required this.nombres,
      required this.apellidos,
      required this.fechaNacimiento,
      required this.folio,
      this.imgType,
      this.imgUrl,
      required this.sexo});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      completed: json['completed'] as bool,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      fechaNacimiento: json['fecha_nacimiento'] as String,
      folio: json['folio'] as String,
      imgType: json['profile_image']['type'],
      imgUrl: json['profile_image']['url'],
      sexo: json['sexo'] as String,
    );
  }
}
