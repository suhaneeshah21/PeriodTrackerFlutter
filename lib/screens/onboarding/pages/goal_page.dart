import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class GoalPage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GoalPage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  final List<Map<String, String>> goals = [
    {"icon": "📅", "label": "Track my period"},
    {"icon": "🤰", "label": "Plan a pregnancy"},
    {"icon": "🛡️", "label": "Avoid pregnancy"},
    {"icon": "❤️", "label": "Monitor my health"},
  ];

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "What are your\ngoals?",
      subtitle: "Select all that apply",
      onNext: widget.data.goals.isNotEmpty ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 16),
          ...goals.map((g) {
            final isSelected = widget.data.goals.contains(g["label"]);
            return GestureDetector(
              onTap: () {
                setState(() {
                  isSelected
                      ? widget.data.goals.remove(g["label"])
                      : widget.data.goals.add(g["label"]!);
                });
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected ? accent : Colors.white,
                  border: Border.all(
                      color: isSelected ? primary : Colors.grey[300]!,
                      width: isSelected ? 2 : 1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(g["icon"]!, style: TextStyle(fontSize: 24)),
                    SizedBox(width: 16),
                    Text(g["label"]!,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? primary : Colors.grey[700])),
                    Spacer(),
                    if (isSelected)
                      Icon(Icons.check_circle, color: primary, size: 20),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}