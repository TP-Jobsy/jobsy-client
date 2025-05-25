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
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenHeight < 600;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: 'Оценка работы',
        titleStyle: TextStyle(
          fontSize: isSmallScreen ? 20 : 22,
          fontFamily: 'Inter',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isVerySmallScreen ? 12 : 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final value = 5 - index;
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: isVerySmallScreen ? 15 : 25,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.white,
                        border: Border.all(
                          color: _rating == value
                              ? Palette.primary
                              : Palette.grey3,
                          width: _rating == value ? 1.5 : 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RadioListTile<int>(
                        value: value,
                        groupValue: _rating,
                        activeColor: Palette.primary,
                        title: Text(
                          value.toString(),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            fontFamily: 'Inter',
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
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
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 12 : 16,
                  0,
                  isSmallScreen ? 12 : 16,
                  isVerySmallScreen ? 20 : 50,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 44 : 48,
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
                    child: Text(
                      'Сохранить',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 16,
                        fontFamily: 'Inter',
                        color: Palette.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}