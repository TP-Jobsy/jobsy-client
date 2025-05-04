import 'package:flutter/material.dart';
import '../../util/palette.dart';

class ApplicationCard extends StatelessWidget {
  final String name;
  final String position;
  final String location;
  final double rating;
  final String avatarUrl;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final String status;
  final bool isProcessed;

  const ApplicationCard({
    super.key,
    required this.name,
    required this.position,
    required this.location,
    required this.rating,
    required this.avatarUrl,
    required this.onAccept,
    required this.onReject,
    required this.status,
    required this.isProcessed,
  });

  @override
  Widget build(BuildContext context) {
    // Определяем текст и цвет для статуса
    String statusText;
    Color statusColor;

    switch (status) {
      case 'Рассматривается':
        statusColor = Palette.primary;
        statusText = 'Рассматривается';
        break;
      case 'Отклонено':
        statusColor = Palette.red;
        statusText = 'Отклонено';
        break;
      default:
        statusColor = Palette.grey3;
        statusText = 'Ожидает';
        break;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(
                    avatarUrl,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          overflow: TextOverflow.ellipsis, // Чтобы текст не выходил за пределы
                        ),
                        maxLines: 1, // Чтобы текст не переползал за пределы
                      ),
                      const SizedBox(height: 4),
                      Text(
                        position,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          overflow: TextOverflow.ellipsis, // Чтобы текст не выходил за пределы
                        ),
                        maxLines: 1, // Чтобы текст не переползал за пределы
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildTag(
                            icon: Icons.location_on,
                            label: location,
                          ),
                          const SizedBox(width: 8),
                          _buildTag(
                            icon: Icons.star,
                            label: rating.toStringAsFixed(1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Просто текст для статуса без контейнера
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor, // Цвет для статуса
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Если статус "Отклонено" или "Рассматривается", скрываем кнопки
                if (!isProcessed) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Palette.red,
                        side: const BorderSide(color: Palette.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                      ),
                      child: const Text('Отказать',
                          style: TextStyle(fontSize: 16, fontFamily: 'Inter')),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.primary,
                        foregroundColor: Palette.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                      ),
                      child: const Text('Принять',
                          style: TextStyle(fontSize: 16, fontFamily: 'Inter')),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.grey3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Palette.grey8),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFamily: 'Inter',
              color: Palette.black,
            ),
          ),
        ],
      ),
    );
  }
}
