class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите email';
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return emailRegex.hasMatch(value) ? null : 'Некорректный email';
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Минимум 8 символов';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Добавьте хотя бы одну цифру';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value)) {
      return 'Добавьте хотя бы одну букву';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите номер телефона';
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11 || !digits.startsWith('7')) {
      return 'Некорректный номер';
    }
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Заполните поле';
    }
    return null;
  }

  static String? validateBirthDate(String? v) {
    if (v == null || v.isEmpty) {
      return 'Заполните поле';
    }
    final parts = v.split('.');
    if (parts.length != 3) return 'дд.мм.гггг';
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return 'дд.мм.гггг';
    if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900) {
      return 'дд.мм.гггг';
    }
    DateTime birthDate;
    try {
      birthDate = DateTime(year, month, day);
    } catch (_) {
      return 'Неверная дата';
    }
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    if (age < 18) {
      return 'Вам должно быть не менее 18 лет';
    }
    return null;
  }
}