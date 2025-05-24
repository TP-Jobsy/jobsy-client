import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../component/error_snackbar.dart';

Future<void> openExternalLink(BuildContext context, String? rawUrl) async {
  if (rawUrl == null || rawUrl.isEmpty) {
    ErrorSnackbar.show(
      context,
      type: ErrorType.error,
      title: 'Ошибка',
      message: 'Контактная ссылка не указана',
    );
    return;
  }

  Uri uri;
  try {
    uri = Uri.parse(rawUrl);
  } catch (_) {
    ErrorSnackbar.show(
      context,
      type: ErrorType.error,
      title: 'Ошибка',
      message: 'Некорректная ссылка: $rawUrl',
    );
    return;
  }

  if (!await canLaunchUrl(uri)) {
    ErrorSnackbar.show(
      context,
      type: ErrorType.error,
      title: 'Ошибка',
      message: 'Невозможно открыть ссылку',
    );
    return;
  }

  await launchUrl(uri, mode: LaunchMode.externalApplication);
}