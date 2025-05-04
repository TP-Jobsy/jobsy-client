import 'package:flutter/material.dart';
import '../../../model/specialization/specialization.dart';
import '../../../util/palette.dart';

class SpecializationSelectionScreen extends StatefulWidget {
  final List<Specialization> items;
  final Specialization? selected;

  const SpecializationSelectionScreen({
    super.key,
    required this.items,
    this.selected,
  });

  @override
  State<SpecializationSelectionScreen> createState() =>
      _SpecializationSelectionScreenState();
}

class _SpecializationSelectionScreenState
    extends State<SpecializationSelectionScreen> {
  Specialization? _current;

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
          'Выберите специализацию',
          style: TextStyle(color: Palette.black),
        ),
        centerTitle: true,
        foregroundColor: Palette.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _close,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.items.length,
        itemBuilder: (ctx, i) {
          final spec = widget.items[i];
          final isSel = spec.id == _current?.id;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: InkWell(
              onTap: () => setState(() => _current = spec),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSel ? Palette.primary : Palette.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSel ? Palette.primary : Palette.grey3,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        spec.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSel ? Palette.white : Palette.black,
                        ),
                      ),
                    ),
                    if (isSel) const Icon(Icons.check, color: Palette.white),
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