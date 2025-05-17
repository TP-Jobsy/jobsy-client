import 'package:flutter/material.dart';
import '../../util/palette.dart';

typedef PageChanged = void Function(int newPage);

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final PageChanged onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 25),
      child: Row(
        children: [
          Text(
            'Стр. $currentPage из $totalPages',
            style: const TextStyle(fontSize: 16, color: Palette.grey2),
          ),
          const Spacer(),
          Container(
            width: 86,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Palette.grey3),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: currentPage > 1
                        ? () => onPageChanged(currentPage - 1)
                        : null,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_left,
                        size: 16,
                        color: currentPage > 1
                            ? Palette.black
                            : Palette.grey3,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Palette.grey3,
                ),
                Expanded(
                  child: InkWell(
                    onTap: currentPage < totalPages
                        ? () => onPageChanged(currentPage + 1)
                        : null,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.chevron_right,
                        size: 16,
                        color: currentPage < totalPages
                            ? Palette.black
                            : Palette.grey3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}