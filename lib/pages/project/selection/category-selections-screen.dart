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
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: (_submit),
        ),
        title: 'Выберите категорию',
          titleStyle: TextStyle(fontSize: 22, fontFamily: 'Inter'),
        trailing: IconButton(
            icon: SvgPicture.asset('assets/icons/Close.svg',
                width: 18,
                height: 18,
                color: Palette.navbar),
            onPressed: _close,
          ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.categories.length,
        itemBuilder: (ctx, i) {
          final cat = widget.categories[i];
          final isSel = cat.id == _current?.id;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: InkWell(
              onTap: () => setState(() => _current = cat),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                          fontSize: 16,
                          color: isSel ? Palette.white : Palette.black,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                    if (isSel)  SvgPicture.asset('assets/icons/Check.svg',
                        width: 20,
                        height: 20,
                        color: Palette.white),
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