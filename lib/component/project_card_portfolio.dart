import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/skill/skill.dart';
import '../util/palette.dart';

class ProjectCardPortfolio extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  final List<Skill> skills;
  final void Function(Skill)? onRemoveSkill;
  final VoidCallback? onMore;
  final VoidCallback? onTapLink;
  final bool isCompact;

  const ProjectCardPortfolio({
    super.key,
    required this.title,
    required this.description,
    required this.link,
    this.skills = const [],
    this.onRemoveSkill,
    this.onMore,
    this.onTapLink,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final titleFontSize = isSmallScreen || isCompact ? 14.0 : 16.0;
    final descFontSize = isSmallScreen || isCompact ? 12.0 : 14.0;
    final chipFontSize = isSmallScreen || isCompact ? 10.0 : 12.0;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Palette.grey3, width: 1),
      ),
      elevation: 2,
      color: Palette.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (onMore != null)
                  PopupMenuButton<String>(
                    color: Palette.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    icon: SvgPicture.asset(
                      'assets/icons/Trailing.svg',
                      width: 8,
                      height: 8,
                      color: Palette.secondaryIcon,
                    ),
                    onSelected: (_) => onMore!(),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Редактировать')),
                      PopupMenuItem(value: 'delete', child: Text('Удалить')),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: descFontSize,
                fontFamily: 'Inter',
              ),
            ),

            if (skills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: skills.map((s) {
                  return InputChip(
                    label: Text(
                      s.name,
                      style: TextStyle(
                        fontSize: chipFontSize,
                        fontFamily: 'Inter',
                        color: Palette.black,
                      ),
                    ),
                    backgroundColor: Palette.white,
                    side: const BorderSide(color: Palette.grey3),
                    deleteIcon: SvgPicture.asset(
                      'assets/icons/Close.svg',
                      width: 12,
                      height: 12,
                      color: Palette.black,
                    ),
                    onDeleted: onRemoveSkill != null
                        ? () => onRemoveSkill!(s)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 12),

            GestureDetector(
              onTap: onTapLink,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.grey3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        link.isNotEmpty ? link : 'Добавить ссылку',
                        style: TextStyle(
                          fontSize: isSmallScreen || isCompact ? 12 : 14,
                          color: link.isNotEmpty
                              ? Palette.black
                              : Palette.dotActive,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SvgPicture.asset(
                      'assets/icons/akar-icons_link-out.svg',
                      width: 16,
                      height: 16,
                      color: Palette.grey1,
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