import 'package:flutter/material.dart';

import '../../../model/category.dart';
import '../../../util/pallete.dart';


class CategorySelectionScreen extends StatelessWidget {
  final List<CategoryDto> categories;
  final CategoryDto? selected;

  const CategorySelectionScreen({
    super.key,
    required this.categories,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Выберите категорию'),
        centerTitle: true,
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      backgroundColor: Palette.white,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: categories.length,
        itemBuilder: (ctx, i) {
          final cat = categories[i];
          final isSel = cat.id == selected?.id;
          return InkWell(
            onTap: () => Navigator.pop(context, cat),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              decoration: BoxDecoration(
                color: isSel ? Palette.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSel ? Palette.primary : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSel ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  if (isSel) const Icon(Icons.check, color: Colors.white),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
