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
}