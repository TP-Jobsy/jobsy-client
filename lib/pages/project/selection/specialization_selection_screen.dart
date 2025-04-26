import 'package:flutter/material.dart';

import '../../../model/specialization_dto.dart';
import '../../../util/pallete.dart';


class SpecializationSelectionScreen extends StatelessWidget {
  final List<SpecializationDto> items;
  final SpecializationDto? selected;

  const SpecializationSelectionScreen({
    super.key,
    required this.items,
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text('Выберите специализацию'),
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
          final spec = items[i];
          final isSel = spec.id == selected?.id;
          return InkWell(
            onTap: () => Navigator.pop(context, spec),
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
                      spec.name,
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
