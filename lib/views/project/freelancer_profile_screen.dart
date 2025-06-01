import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import '../../util/link_utils.dart';
import '../../util/palette.dart';
import '../../component/custom_nav_bar.dart';
import 'freelancer_profile_content.dart';
import 'invite_project_screen.dart';

class FreelancerProfileScreen extends StatelessWidget {
  final FreelancerProfile freelancer;

  const FreelancerProfileScreen({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    final link = freelancer.contact.contactLink;
    final media = MediaQuery.of(context);
    final width = media.size.width;

    final buttonWidth = width > 600 ? 600.0 : width - 32;

    final buttonHeight = width < 350 ? 40.0 : 48.0;

    final fontSize = width < 350 ? 14.0 : 16.0;

    final verticalSpacing = width < 350 ? 8.0 : 12.0;

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: FreelancerProfileContent(freelancer: freelancer),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: OutlinedButton(
                onPressed: () => openExternalLink(context, link),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Palette.sky,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Связаться',
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: fontSize,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
            SizedBox(height: verticalSpacing),
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () {
                  AppMetrica.reportEventWithMap(
                    'FreelancerProfileScreen_invite_tap',
                    {'freelancerId': freelancer.id},
                  );
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => InviteProjectScreen(
                      freelancerId: freelancer.id,
                    ),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Пригласить',
                  style: TextStyle(
                    color: Palette.white,
                    fontSize: fontSize,
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
