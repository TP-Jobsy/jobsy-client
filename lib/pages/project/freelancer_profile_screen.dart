import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import '../../../../util/palette.dart';
import 'invite_project_screen.dart';

class FreelancerProfileScreen extends StatelessWidget {
  final FreelancerProfile freelancer;

  const FreelancerProfileScreen({
    super.key,
    required this.freelancer,
  });

  @override
  Widget build(BuildContext context) {
    final name = '${freelancer.basic.firstName} ${freelancer.basic.lastName}';
    final position = freelancer.about.specializationName ?? '';
    final location = freelancer.basic.city ?? '';
    final avatarUrl = freelancer.avatarUrl ?? '';
    final rating = '4.9';
    final description = freelancer.about.aboutMe;
    final skills = freelancer.about.skills.map((s) => s.name).toList();
    final experience = freelancer.about.experienceLevel;
    final country = freelancer.basic.country ?? '';

    return Scaffold(
      backgroundColor: Palette.white,
      appBar: AppBar(
        backgroundColor: Palette.white,
        foregroundColor: Palette.black,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/icons/ArrowLeft.svg',
            width: 20,
            height: 20,
            color: Palette.navbar,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: avatarUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  avatarUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
                  : SvgPicture.asset('assets/icons/avatar.svg'),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(position,
                      style: const TextStyle(
                          fontSize: 16, color: Palette.secondary)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/location.svg',
                          width: 17, height: 17, color: Palette.thin),
                      const SizedBox(width: 8),
                      Text(location,
                          style: const TextStyle(
                              fontSize: 14, color: Palette.secondary)),
                      const SizedBox(width: 16),
                      SvgPicture.asset('assets/icons/star.svg',
                          width: 17, height: 17, color: Palette.thin),
                      const SizedBox(width: 8),
                      Text(rating,
                          style: const TextStyle(
                              fontSize: 14, color: Palette.secondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('О себе:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(description,
                style: const TextStyle(fontSize: 14, color: Palette.black)),
            const SizedBox(height: 16),
            _infoRow('Опыт:', experience),
            _infoRow('Страна:', country),
            const SizedBox(height: 16),
            const Text('Навыки:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((skill) =>
                   Chip(
                label: Text(skill, style: const TextStyle(color: Palette.black)),
                     backgroundColor: Palette.white,
                     side: const BorderSide(color: Palette.black),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(20),
                     ),
              ))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              onPressed: () {
              },
              style: OutlinedButton.styleFrom(
                  backgroundColor: Palette.sky,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: const Text('Связаться',
                  style: TextStyle(
                      color: Palette.white,
                      fontSize: 16,
                      fontFamily: 'Inter')),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => InviteProjectScreen(
                      freelancerId: freelancer.id,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
              child: const Text('Пригласить',
                  style: TextStyle(
                      color: Palette.white,
                      fontSize: 16,
                      fontFamily: 'Inter')),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$label ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        Expanded(child: Text(value, style: const TextStyle(fontFamily: 'Inter')))
      ]),
    );
  }
}