import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:presunivgo/core/constants/app_colors.dart';
import '../../domain/entities/ai_entities.dart';
import '../../data/services/ai_service.dart';
import '../../data/services/resume_export_service.dart';
import '../../../../shared/widgets/glass_container.dart';

class MentorBotScreen extends StatefulWidget {
  const MentorBotScreen({super.key});

  @override
  State<MentorBotScreen> createState() => _MentorBotScreenState();
}

class _MentorBotScreenState extends State<MentorBotScreen> {
  final List<AIChatMessage> _messages = [
    AIChatMessage(
      content:
          "Hello! I'm MentorBot, your PresUnivGo AI assistant. I can help you with CV reviews, cover letters, and planning your entire career roadmap. How can I assist you today?",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];
  final _textController = TextEditingController();
  final _aiService = GeminiServiceMock();
  bool _isLoading = false;

  void _handleSend() async {
    if (_textController.text.trim().isEmpty) return;

    final userMsg = AIChatMessage(
      content: _textController.text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isLoading = true;
    });

    final query = _textController.text;
    _textController.clear();

    try {
      final response =
          await _aiService.getCareerAdvice(query, "Student, IT, 2022");
      if (mounted) {
        setState(() {
          _messages.add(AIChatMessage(
            content: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: AppColors.primary),
            SizedBox(width: 8),
            Text('MentorBot AI', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildTopActions(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index])
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  color: AppColors.primary),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTopActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildActionChip(
                'CV Review', Icons.description_outlined, '/ai-cv-review'),
            _buildActionChip(
                'Cover Letter', Icons.history_edu_outlined, '/ai-cover-letter'),
            _buildActionChip(
                'Career Roadmap', Icons.map_outlined, '/ai-career-roadmap'),
            _buildActionChip(
                'Export Resume (PDF)', Icons.picture_as_pdf_outlined, 'export'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, String? action) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: AppColors.primary),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: () {
          if (action == 'export') {
            _handleResumeExport();
          } else if (action != null) {
            context.push(action);
          }
        },
        backgroundColor: AppColors.surface,
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ).animate().fadeIn().scale(delay: 200.ms);
  }

  void _handleResumeExport() async {
    setState(() => _isLoading = true);
    try {
      await ResumeExportService.exportResume(
        name: "User Name", // Should be from auth provider
        email: "student@president.ac.id",
        major: "Information Technology",
        activityStatus: "Studying",
      );
      if (mounted) {
        setState(() {
          _messages.add(AIChatMessage(
            content:
                "I've generated your professional resume PDF and sent it to your printing service! Reach out if you need adjustments.",
            isUser: false,
            timestamp: DateTime.now(),
          ));
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildMessageBubble(AIChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: msg.isUser ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
              bottomLeft: Radius.circular(msg.isUser ? 20 : 4),
              bottomRight: Radius.circular(msg.isUser ? 4 : 20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            msg.content,
            style: TextStyle(
                color: msg.isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                height: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return GlassContainer(
      borderRadius: BorderRadius.zero,
      blur: 10,
      opacity: 0.9,
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Ask your AI mentor...',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onSubmitted: (_) => _handleSend(),
              ),
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                onPressed: _handleSend,
                icon: const Icon(Icons.send_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
