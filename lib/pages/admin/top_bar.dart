import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/palette.dart';
import '../../widgets/avatar.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      color: Colors.white,
      child: Container(
        height: 90,
        padding: const EdgeInsets.only(left: 50, right: 24),
        child: Row(
          children: [
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(8),
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                width: 24,
                height: 24,
                color: Palette.black,
              ),
            ),
            const SizedBox(width: 50),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - (50 + 24 + 50 + 75 + 24)),
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/search.svg',
                        width: 20,
                        height: 20,
                        color: Palette.grey2,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Поиск',
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Avatar(
              size: 75,
              placeholderAsset: 'assets/icons/avatar.svg',
            ),
            const SizedBox(width: 24),
          ],
        ),
      ),
    );
  }
}