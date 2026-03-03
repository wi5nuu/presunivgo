import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/glass_container.dart';

class AICareerRoadmapScreen extends StatelessWidget {
  const AICareerRoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RoadmapMilestone> milestones = [
      RoadmapMilestone(
          year: "Year 1",
          title: "Foundation & Skills",
          items: ["Python/Dart Basics", "Join 2 Clubs", "Academic Excellence"]),
      RoadmapMilestone(year: "Year 2", title: "Specialization", items: [
        "Mobile Dev Projects",
        "Start Open Source",
        "Hackathon Participation"
      ]),
      RoadmapMilestone(year: "Year 3", title: "Industry Exposure", items: [
        "Internship at Tech Giant",
        "Professional Certifications",
        "Networking with Alumni"
      ]),
      RoadmapMilestone(year: "Year 4", title: "Launch & Career", items: [
        "Final Project/Thesis",
        "Full-time Job Huntington",
        "Alumni Mentorship Role"
      ]),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("AI Career Roadmap")),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: milestones.length,
        itemBuilder: (context, index) {
          final m = milestones[index];
          return IntrinsicHeight(
            child: Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.royalBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                              color: AppColors.royalBlue.withOpacity(0.3),
                              blurRadius: 10)
                        ],
                      ),
                    ),
                    if (index != milestones.length - 1)
                      Expanded(
                        child: Container(
                            width: 2,
                            color: AppColors.royalBlue.withOpacity(0.3)),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.year,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.royalBlue)),
                          const SizedBox(height: 8),
                          Text(m.title,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navy)),
                          const SizedBox(height: 12),
                          ...m.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle_outline,
                                        size: 14, color: AppColors.success),
                                    const SizedBox(width: 8),
                                    Text(item,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary)),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(delay: (index * 200).ms)
                        .slideX(begin: 0.1),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class RoadmapMilestone {
  final String year;
  final String title;
  final List<String> items;

  RoadmapMilestone(
      {required this.year, required this.title, required this.items});
}
