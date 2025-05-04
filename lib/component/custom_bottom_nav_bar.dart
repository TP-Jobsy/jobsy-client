import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/palette.dart';

typedef NavTapCallback = void Function(int index);

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final NavTapCallback onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom
        + MediaQuery.of(context).viewInsets.bottom;

    const double sideMargin  = 30;
    const double navHeight   = 60;
    const double iconSize    = 32;
    const double pillHeight  = 40;
    const double pillBorder  = 10;
    const double pillWidth   = 70;

    final items = <_NavItem>[
      _NavItem(
        SvgPicture.asset(
          'assets/icons/Home.svg',
          color: Palette.white, // Set color to white
        ),
      ),
      _NavItem(
        SvgPicture.asset(
          'assets/icons/Search.svg',
          color: Palette.white, // Set color to white
        ),
      ),
      _NavItem(
        SvgPicture.asset(
          'assets/icons/Heart Outlined.svg',
          color: Palette.white, // Set color to white
        ),
      ),
      _NavItem(
        SvgPicture.asset(
          'assets/icons/user.svg',
          color: Palette.white, // Set color to white
        ),
      ),
    ];

    return SizedBox(
      height: navHeight + bottomInset,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Center(
          child: Container(
            height: navHeight,
            margin: const EdgeInsets.symmetric(horizontal: sideMargin),
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
                          final sel = i == currentIndex;
                          final icon = items[i].inactive;
                          return Expanded(
                            child: InkWell(
                              onTap: () => onTap(i),
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
