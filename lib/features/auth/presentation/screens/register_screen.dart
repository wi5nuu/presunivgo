import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/pu_button.dart';
import '../../../../shared/widgets/pu_text_field.dart';
import '../../../../shared/widgets/wave_clipper.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController();
  final UserRole _detectedRole = UserRole.student;
  ActivityStatus _activityStatus = ActivityStatus.student;
  String? _selectedFaculty;
  String? _selectedMajor;
  bool _acceptedTerms = false;

  final Map<String, List<String>> _majorsByFaculty = {
    'Faculty of Business': [
      'Accounting',
      'Actuarial Science',
      'Agribusiness',
      'Business Administration',
      'Management',
      'Master of Management in Technology',
      'Doctor of Management',
    ],
    'Faculty of Engineering': [
      'Civil Engineering',
      'Electrical Engineering',
      'Environmental Engineering',
      'Industrial Engineering',
      'Mechanical Engineering',
    ],
    'Faculty of Computing': [
      'Information System',
      'Informatics',
      'Master in Informatics',
    ],
    'Faculty of Social Science and Education': [
      'Communication',
      'Elementary Teacher Education',
      'International Relations',
    ],
    'Faculty of Art, Design, and Architecture': [
      'Architecture',
      'Interior Design',
      'Visual Communication Design',
    ],
    'Faculty of Law': [
      'Law',
      'Master of Law',
    ],
    'Faculty of Medicine': [
      'Medicine',
      'Medicine (Profession)',
    ],
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        next.whenOrNull(
          error: (error, stackTrace) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: AppColors.error,
              ),
            );
          },
          data: (_) {
            if (previous?.isLoading == true) {
              context.go('/verify-email');
            }
          },
        );
      },
    );

    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  // Radiant Magenta Header
                  ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      height: 260,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primary, AppColors.secondary],
                        ),
                      ),
                    ),
                  ),
                  // Title
                  Positioned(
                    top: 60,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () => context.pop(),
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Join the community today',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  // Register Card
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 180, left: 24, right: 24),
                    child: Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          PUTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            hintText: 'e.g. Wisnu Alfian',
                          ),
                          const SizedBox(height: 16),
                          PUTextField(
                            controller: _emailController,
                            label: 'University Email',
                            hintText: 'user@student.president.ac.id',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Status',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<ActivityStatus>(
                            value: _activityStatus,
                            onChanged: (val) => setState(() => _activityStatus =
                                val ?? ActivityStatus.student),
                            items: ActivityStatus.values
                                .map((s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.name.toUpperCase())))
                                .toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.surfaceVariant,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                          if (_activityStatus == ActivityStatus.internship ||
                              _activityStatus == ActivityStatus.working) ...[
                            const SizedBox(height: 16),
                            PUTextField(
                              controller: _companyController,
                              label: 'Company Name',
                              hintText: 'e.g. Google, PU Tech Club',
                            ),
                          ],
                          const SizedBox(height: 16),
                          const Text(
                            'Academic Information',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedFaculty,
                            hint: const Text('Select Faculty'),
                            onChanged: (val) => setState(() {
                              _selectedFaculty = val;
                              _selectedMajor = null;
                            }),
                            items: _majorsByFaculty.keys
                                .map((f) =>
                                    DropdownMenuItem(value: f, child: Text(f)))
                                .toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.surfaceVariant,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none),
                            ),
                          ),
                          if (_selectedFaculty != null) ...[
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: _selectedMajor,
                              hint: const Text('Select Major'),
                              onChanged: (val) =>
                                  setState(() => _selectedMajor = val),
                              items: _majorsByFaculty[_selectedFaculty]!
                                  .map((m) => DropdownMenuItem(
                                      value: m, child: Text(m)))
                                  .toList(),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.surfaceVariant,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          PUTextField(
                            controller: _passwordController,
                            label: 'Password',
                            isPassword: true,
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  value: _acceptedTerms,
                                  onChanged: (val) => setState(
                                      () => _acceptedTerms = val ?? false),
                                  activeColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text('I accept the Terms and Conditions',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          PUButton(
                            text: 'Register',
                            isLoading: authState.isLoading,
                            onPressed: !_acceptedTerms
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      await ref
                                          .read(authControllerProvider.notifier)
                                          .register(
                                            name: _nameController.text.trim(),
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                            role: _detectedRole,
                                            activityStatus: _activityStatus,
                                            major: _selectedMajor,
                                            faculty: _selectedFaculty,
                                            currentCompany:
                                                _companyController.text.isEmpty
                                                    ? null
                                                    : _companyController.text
                                                        .trim(),
                                          );
                                    }
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?",
                      style: TextStyle(color: AppColors.textSecondary)),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Login here',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
