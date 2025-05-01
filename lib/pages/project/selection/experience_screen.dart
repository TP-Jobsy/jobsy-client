import 'package:flutter/material.dart';
import '../../../util/palette.dart';

class ExperienceScreen extends StatelessWidget {
  static const List<String> statuses = ['BEGINNER', 'MIDDLE', 'EXPERT'];

  final List<String> items;
  final String? selected;

  const ExperienceScreen({Key? key, required this.items, this.selected})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Укажите свой опыт работы'),
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
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final String status = items[i];
          final bool isSel = status == selected;
          return InkWell(
            onTap: () => Navigator.pop(context, status),
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
                      status,
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
