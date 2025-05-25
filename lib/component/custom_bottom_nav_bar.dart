import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/palette.dart';

typedef NavTapCallback = void Function(int index);

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final NavTapCallback onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 360;

    const double iconSize = 26;
    const double navHeight = 60;
    const double pillHeight = 40;
    const double pillWidth = 70;
    const double pillBorder = 10;

    final double sideMargin = isSmallScreen ? 20 : 30;
    final double bottomPadding = isSmallScreen ? 8 : 12;
    final double bottomInset = mediaQuery.padding.bottom + mediaQuery.viewInsets.bottom;

    final items = <_NavItem>[
      _NavItem(
        SvgPicture.asset(
          'assets/icons/Home.svg',
          width: iconSize,
          height: iconSize,
          color: Palette.white,
        ),
      ),
      _NavItem(
        SvgPicture.asset(
          'assets/icons/Search.svg',
          width: iconSize,
          height: iconSize,
          color: Palette.white,
        ),
      ),
      _NavItem(
        SvgPicture.asset(
          'assets/icons/Heart Outlined.svg',
          width: iconSize,
          height: iconSize,
          color: Palette.white,
        ),
      ),
      _NavItem(
        SvgPicture.asset(
          'assets/icons/user.svg',
          width: iconSize,
          height: iconSize,
          color: Palette.white,
        ),
      ),
    ];

    return SizedBox(
      height: navHeight + bottomPadding + bottomInset,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding + bottomInset),
        child: Center(
          child: Container(
            height: navHeight,
            margin: EdgeInsets.symmetric(horizontal: sideMargin),
            decoration: BoxDecoration(
              color: Palette.navbar,
              borderRadius: BorderRadius.circular(15),
            ),
            child: LayoutBuilder(
              builder: (ctx, constraints) {
                final availableW = constraints.maxWidth;
                final cellW = availableW / items.length;
                final pillLeft = cellW * currentIndex + (cellW - pillWidth) / 2;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: pillLeft,
                      top: (navHeight - pillHeight) / 2,
                      child: Container(
                        width: pillWidth,
                        height: pillHeight,
                        decoration: BoxDecoration(
                          color: Palette.primary,
                          borderRadius: BorderRadius.circular(pillBorder),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Row(
                        children: List.generate(items.length, (i) {
                          final icon = items[i].inactive;
                          return Expanded(
                            child: InkWell(
                              onTap: () => onTap(i),
                              borderRadius: BorderRadius.circular(15),
                              child: Center(
                                child: icon,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final Widget inactive;
  const _NavItem(this.inactive);
}