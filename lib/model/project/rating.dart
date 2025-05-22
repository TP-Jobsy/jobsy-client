import 'package:flutter/material.dart';
import '../../util/palette.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({Key? key}) : super(key: key);

  @override
  _RatingScreenState createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  int _rating = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        elevation: 0,                    // без тени
        title: const Text(
          'Оценка работы',
          style: TextStyle(color: Palette.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Palette.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  final value = 5 - index;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Palette.white, // фон карточки
                      border: Border.all(
                        color: _rating == value
                            ? Palette.primary
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile<int>(
                      value: value,
                      groupValue: _rating,
                      activeColor: Palette.primary,
                      title: Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _rating = val);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  foregroundColor: Palette.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  debugPrint('Выбранный рейтинг: $_rating');
                  Navigator.of(context).pop(_rating);
                },
                child: const Text(
                  'Сохранить',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
