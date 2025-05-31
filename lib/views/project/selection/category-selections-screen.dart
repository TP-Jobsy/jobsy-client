import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
import '../../../model/category/category.dart';
import '../../../util/palette.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<Category> categories;
  final Category? selected;

  const CategorySelectionScreen({
    super.key,
    required this.categories,
    this.selected,
  });

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  Category? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.selected;
  }

  void _submit() {
    Navigator.pop(context, _current);
  }

  void _close() {
    Navigator.pop(context, null);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: isSmallScreen ? 16 : 20,
            height: isSmallScreen ? 16 : 20,
            color: Palette.navbar,
          ),
          onPressed: _submit,
        ),
        title: 'Выберите категорию',
        titleStyle: TextStyle(
          fontSize: isSmallScreen ? 18 : 22,
          fontFamily: 'Inter',
        ),
        trailing: const SizedBox(width: 24),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          vertical: isVerySmallScreen ? 4 : 8,
          horizontal: isSmallScreen ? 12 : 16,
        ),
        itemCount: widget.categories.length,
        itemBuilder: (ctx, i) {
          final cat = widget.categories[i];
          final isSel = cat.id == _current?.id;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 4 : 6,
            ),
            child: InkWell(
              onTap: () => setState(() => _current = cat),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 12 : 14,
                  horizontal: isSmallScreen ? 14 : 16,
                ),
                decoration: BoxDecoration(
                  color: isSel ? Palette.primary : Palette.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSel ? Palette.primary : Palette.dotInactive,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        cat.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: isSel ? Palette.white : Palette.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    if (isSel)
                      SvgPicture.asset(
                        'assets/icons/Check.svg',
                        width: isSmallScreen ? 16 : 20,
                        height: isSmallScreen ? 16 : 20,
                        color: Palette.white,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}