import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../component/custom_nav_bar.dart';
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
        title: 'Выберите специализацию',
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
        itemCount: widget.items.length,
        itemBuilder: (ctx, i) {
          final spec = widget.items[i];
          final isSel = spec.id == _current?.id;
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 4 : 6,
            ),
            child: InkWell(
              onTap: () => setState(() => _current = spec),
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
                    color: isSel ? Palette.primary : Palette.grey3,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        spec.name,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: isSel ? Palette.white : Palette.black,
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