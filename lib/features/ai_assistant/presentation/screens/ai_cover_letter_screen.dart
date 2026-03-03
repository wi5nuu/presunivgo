import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/pu_button.dart';

class AICoverLetterScreen extends StatefulWidget {
  const AICoverLetterScreen({super.key});

  @override
  State<AICoverLetterScreen> createState() => _AICoverLetterScreenState();
}

class _AICoverLetterScreenState extends State<AICoverLetterScreen> {
  String _tone = 'Professional';
  bool _isGenerating = false;
  String? _generatedLetter;

  void _generate() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _generatedLetter =
          "Dear Hiring Manager,\n\nI am writing to express my strong interest in the Flutter Developer position. As a student at President University, I have developed a passion for building high-quality mobile applications...";
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('AI Cover Letter',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Tone',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Professional', 'Confident', 'Humble'].map((t) {
                return ChoiceChip(
                  label: Text(t),
                  selected: _tone == t,
                  onSelected: (val) => setState(() => _tone = t),
                  selectedColor: AppColors.royalBlue.withOpacity(0.2),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            PUButton(
              text: 'Generate with AI',
              isLoading: _isGenerating,
              onPressed: _generate,
            ),
            if (_generatedLetter != null) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Text(_generatedLetter!),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.copy),
                          label: const Text('Copy'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
