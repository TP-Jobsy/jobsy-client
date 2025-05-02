class PublicUserDto {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dateBirth;

  PublicUserDto({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateBirth,
  });

  factory PublicUserDto.fromJson(Map<String, dynamic> json) {
    return PublicUserDto(
        firstName : json['firstName']  as String,
        lastName  : json['lastName']   as String,
        email     : json['email']      as String,
        phone     : json['phone']      as String,
        dateBirth : json['dateBirth']  as String,
      );
  }


  Map<String, dynamic> toJson() => {
    'firstName' : firstName,
    'lastName'  : lastName,
    'email'     : email,
    'phone'     : phone,
    'dateBirth' : dateBirth,
  };
}