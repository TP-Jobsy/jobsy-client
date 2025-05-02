import 'package:flutter/material.dart';
import '../../../model/category.dart';
import '../../../util/palette.dart';

class CategorySelectionScreen extends StatefulWidget {
  final List<CategoryDto> categories;
  final CategoryDto? selected;

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
  CategoryDto? _current;

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
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,
        leading: BackButton(onPressed: _submit),
        title: const Text(
          'Выберите категорию',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _close,
          ),
        ],
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
            ),
          );
        },
      ),
    );
  }
}