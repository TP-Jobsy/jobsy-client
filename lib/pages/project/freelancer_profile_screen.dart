import 'package:flutter/material.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import '../../util/palette.dart';
import '../../component/custom_nav_bar.dart';
import 'freelancer_profile_content.dart';
import 'invite_project_screen.dart';

class FreelancerProfileScreen extends StatelessWidget {
  final FreelancerProfile freelancer;

  const FreelancerProfileScreen({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(title: ''),
      body: FreelancerProfileContent(freelancer: freelancer),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Palette.sky,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text(
                  'Связаться',
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => InviteProjectScreen(
                      freelancerId: freelancer.id,
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text(
                  'Пригласить',
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: 16,
                    fontFamily: 'Inter',
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