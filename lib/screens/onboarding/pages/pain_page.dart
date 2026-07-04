import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class PainPage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const PainPage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<PainPage> createState() => _PainPageState();
}

class _PainPageState extends State<PainPage> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  bool get _canProceed =>
      widget.data.painLevel != null &&
      widget.data.prePeriodSymptoms != null;

  Widget _radioGroup({
    required String question,
    required List<String> options,
    required String? selected,
    required Function(String) onSelect,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800])),
          SizedBox(height: 10),
          ...options.map((opt) {
            final isSelected = selected == opt;
            return GestureDetector(
              onTap: () => setState(() => onSelect(opt)),
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? accent : Colors.grey[50],
                  border: Border.all(
                      color: isSelected ? primary : Colors.grey[200]!,
                      width: isSelected ? 2 : 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(opt,
                          style: TextStyle(
                              fontSize: 13,
                              color: isSelected ? primary : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: primary, size: 16),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "Pain &\nsymptoms",
      subtitle: "Helps us predict and manage your discomfort",
      onNext: _canProceed ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 16),
          _radioGroup(
            question: "How painful are your periods usually?",
            options: [
              "No pain",
              "Mild pain (manageable without medicine)",
              "Moderate pain (need pain relief sometimes)",
              "Severe pain (affects daily activities)",
              "Extremely severe (miss school/work)",
            ],
            selected: widget.data.painLevel,
            onSelect: (v) => widget.data.painLevel = v,
          ),
          SizedBox(height: 12),
          _radioGroup(
            question:
                "Before your period starts, how strong are the symptoms you experience (mood swings, cramps, bloating, headaches, fatigue)?",
            options: [
              "I usually don't experience any symptoms",
              "Mild symptoms (slightly uncomfortable but manageable)",
              "Moderate symptoms (noticeable and sometimes affect daily activities)",
              "Severe symptoms (strong and often disturb daily activities)",
              "Very severe symptoms (very difficult to manage)",
            ],
            selected: widget.data.prePeriodSymptoms,
            onSelect: (v) => widget.data.prePeriodSymptoms = v,
          ),
        ],
      ),
    );
  }
}