import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../component/custom_nav_bar.dart';
import '../../service/freelancer_service.dart';
import '../../util/palette.dart';
import '../../model/profile/free/freelancer_profile_dto.dart';
import 'freelancer_profile_screen.dart';

class FreelancerProfileScreenById extends StatefulWidget {
  final int freelancerId;

  const FreelancerProfileScreenById({Key? key, required this.freelancerId})
    : super(key: key);

  @override
  _FreelancerProfileScreenByIdState createState() =>
      _FreelancerProfileScreenByIdState();
}

class _FreelancerProfileScreenByIdState
    extends State<FreelancerProfileScreenById> {
  bool _isLoading = true;
  String? _error;
  FreelancerProfile? _profile;
  late final FreelancerService _service;

  @override
  void initState() {
    super.initState();
    _service = context.read<FreelancerService>();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final p = await _service.fetchFreelancerById(widget.freelancerId);
      setState(() => _profile = p);
    } catch (e) {
      setState(() => _error = 'Ошибка загрузки профиля: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      appBar: CustomNavBar(title: '', leading: const SizedBox()),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(child: Text(_error!))
              : FreelancerProfileScreen(freelancer: _profile!),
    );
  }
}
