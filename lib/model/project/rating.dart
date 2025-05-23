import 'package:flutter/material.dart';
import 'package:jobsy/component/custom_nav_bar.dart';
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
      appBar: CustomNavBar(
        title: 'Оценка работы',
          titleStyle: TextStyle(fontSize: 22, fontFamily: 'Inter'),
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
                    margin: const EdgeInsets.only(bottom: 25),
                    decoration: BoxDecoration(
                      color: Palette.white,
                      border: Border.all(
                        color: _rating == value
                            ? Palette.primary
                            : Palette.grey3,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: RadioListTile<int>(
                      value: value,
                      groupValue: _rating,
                      activeColor: Palette.primary,
                      title: Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 20),
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
            Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 50),
          child:SizedBox(
            width: double.infinity,
            height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  debugPrint('Выбранный рейтинг: $_rating');
                  Navigator.of(context).pop(_rating);
                },
                child: const Text(
                  'Сохранить',
                  style: TextStyle(fontSize: 16, fontFamily: 'Inter',
                    color: Palette.white,),
                ),
              ),
            ),
      ),
          ],
        ),
      ),
    );
  }
}
