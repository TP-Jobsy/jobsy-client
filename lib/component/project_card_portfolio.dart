import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/palette.dart';

class ProjectCardPorfolio extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final VoidCallback? onTapLink;
  final VoidCallback? onMore;

  const ProjectCardPorfolio({
    Key? key,
    required this.title,
    required this.description,
    required this.link,
    this.onTapLink,
    this.onMore,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Palette.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // заголовок и «...»
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                ),
                if (onMore != null)
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (_) => onMore!(),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                      const PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onTapLink,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.grey3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.link, size: 20, color: Palette.dotActive),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        link.isNotEmpty ? link : 'Добавить ссылку',
                        style: TextStyle(
                          fontSize: 14,
                          color: link.isNotEmpty ? Palette.black : Palette.dotActive,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/arrow_right.svg',
                      width: 16,
                      height: 16,
                      color: Palette.dotActive,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}