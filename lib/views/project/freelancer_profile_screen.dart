import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../component/custom_nav_bar.dart';
import '../../component/project_card_portfolio.dart';
import '../../model/portfolio/portfolio.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import '../../service/portfolio_service.dart';
import '../../util/link_utils.dart';
import '../../util/palette.dart';
import 'invite_project_screen.dart';
import 'freelancer_profile_content.dart';


class FreelancerProfileScreen extends StatefulWidget {
  final FreelancerProfile freelancer;

  const FreelancerProfileScreen({Key? key, required this.freelancer})
    : super(key: key);

  @override
  _FreelancerProfileScreenState createState() =>
      _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen> {
  late final PortfolioService _portfolioService;
  late Future<List<FreelancerPortfolioDto>> _futurePortfolios;

  @override
  void initState() {
    super.initState();
    _portfolioService = context.read<PortfolioService>();
    _futurePortfolios = _portfolioService.fetchPortfolioByFreelancer(
      widget.freelancer.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final freelancer = widget.freelancer;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FreelancerProfileContent(freelancer: freelancer),

            FutureBuilder<List<FreelancerPortfolioDto>>(
              future: _futurePortfolios,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'Ошибка при загрузке портфолио:\n${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                final portfolios = snapshot.data ?? [];

                if (portfolios.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('У фрилансера нет проектов в портфолио'),
                    ),
                  );
                }

                final isSmallScreen = width < 360;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8, bottom: 16),
                  itemCount: portfolios.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final p = portfolios[index];
                    return ProjectCardPortfolio(
                      title: p.title,
                      description: p.description,
                      link: p.projectLink,
                      skills: p.skills,
                      isCompact: isSmallScreen,
                      onTapLink: () async {
                        final raw = p.projectLink.trim();
                        if (raw.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ссылка не указана'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        final uri = Uri.tryParse(raw);
                        if (uri != null && await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Неверный формат ссылки'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      onMore: null,
                      onRemoveSkill: null,
                    );
                  },
                );
              },
            ),
          ],
        ),
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) =>
                              InviteProjectScreen(freelancerId: freelancer.id),
                    ),
                  );
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
