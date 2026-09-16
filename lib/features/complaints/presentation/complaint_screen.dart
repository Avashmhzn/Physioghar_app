import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physioghar_therapist/core/constants/app_colors.dart';
import 'package:physioghar_therapist/core/constants/app_typography.dart';
import 'package:physioghar_therapist/core/localization/app_strings.dart';
import 'package:physioghar_therapist/core/localization/language_provider.dart';
import 'package:physioghar_therapist/features/complaints/providers/complaint_provider.dart';

class ComplaintScreen extends ConsumerStatefulWidget {
  const ComplaintScreen({super.key});

  @override
  ConsumerState<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends ConsumerState<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedCategory = 'Technical Issue';
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _categories = [
    'Technical Issue',
    'Payment Issue',
    'Scheduling Issue',
    'Patient Complaint',
    'App Bug',
    'Feature Request',
    'Other',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppStrings.get('complaints', lang),
          style: AppTypography.headingSmall(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('We\'re here to help', style: AppTypography.headingMedium()),
              const SizedBox(height: 8),
              Text(
                'Please describe your issue or concern and we\'ll get back to you as soon as possible.',
                style: AppTypography.bodyMedium(color: AppColors.slateMid),
              ),
              const SizedBox(height: 24),
              Text('Category', style: AppTypography.eyebrow()),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_outlined),
                  hintText: 'Select a category',
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category, style: AppTypography.bodyMedium()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedCategory = value);
                  }
                },
                validator: (value) =>
                    value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 20),
              Text('Subject', style: AppTypography.eyebrow()),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.subject_outlined),
                  hintText: 'Brief summary of the issue',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text('Description', style: AppTypography.eyebrow()),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText:
                      'Please provide detailed information about the issue...',
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  child: Text(
                    'Submit Report',
                    style: AppTypography.buttonText(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitComplaint() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(complaintsProvider.notifier)
          .addComplaint(
            category: _selectedCategory,
            subject: _subjectController.text.trim(),
            description: _descriptionController.text.trim(),
          );

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.pinePale,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 32, color: AppColors.pine),
              ),
              const SizedBox(height: 16),
              Text('Report Submitted', style: AppTypography.headingSmall()),
              const SizedBox(height: 8),
              Text(
                'Thank you for your feedback. We\'ll review your report and get back to you soon.',
                style: AppTypography.bodyMedium(color: AppColors.slateMid),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).maybePop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  shape: const StadiumBorder(),
                ),
                child: Text('Done', style: AppTypography.buttonText()),
              ),
            ),
          ],
        ),
      );
    }
  }
}
