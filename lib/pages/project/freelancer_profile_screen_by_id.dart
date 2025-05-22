import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../component/custom_nav_bar.dart';
import '../../provider/auth_provider.dart';
import '../../service/freelancer_response_service.dart';
import '../../service/freelancer_service.dart';
import '../../util/palette.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import 'freelancer_profile_screen.dart';

class FreelancerProfileScreenById extends StatefulWidget {
  final int freelancerId;
  const FreelancerProfileScreenById({
    Key? key,
    required this.freelancerId,
  }) : super(key: key);

  @override
  _FreelancerProfileScreenByIdState createState() =>
      _FreelancerProfileScreenByIdState();
}

class _FreelancerProfileScreenByIdState
    extends State<FreelancerProfileScreenById> {
  bool _isLoading = true;
  String? _error;
  FreelancerProfile? _profile;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) {
      setState(() {
        _error = 'Не авторизованы';
        _isLoading = false;
      });
      return;
    }

    try {
      final service = context.read<FreelancerService>();
      final p = await service.fetchFreelancerById(
        widget.freelancerId,
        token,
      );
      setState(() {
        _profile = p;
      });
    } catch (e) {
      setState(() {
        _error = 'Ошибка загрузки профиля: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(
        title: '',
        leading: const SizedBox(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : FreelancerProfileScreen(freelancer: _profile!),
    );
  }
}