import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class LifestylePage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LifestylePage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<LifestylePage> createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  bool get _canProceed =>
      widget.data.dietaryPreference != null &&
      widget.data.ironRichFoods != null &&
      widget.data.sleepHours != null;

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

  Widget _stressSlider() {
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
          Text("How would you rate your stress level in the past 3 months?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800])),
          SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primary,
              inactiveTrackColor: Colors.grey[200],
              thumbColor: primary,
              overlayColor: primary.withOpacity(0.1),
            ),
            child: Slider(
              value: widget.data.stressLevel.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              onChanged: (val) =>
                  setState(() => widget.data.stressLevel = val.toInt()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Very Low",
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[500])),
              Text("${widget.data.stressLevel}",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primary)),
              Text("Very High",
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "Your lifestyle",
      subtitle: "Helps us understand your overall health",
      onNext: _canProceed ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 16),
          _radioGroup(
            question: "What is your dietary preference?",
            options: ["Vegetarian", "Non-Vegetarian"],
            selected: widget.data.dietaryPreference,
            onSelect: (v) => widget.data.dietaryPreference = v,
          ),
          SizedBox(height: 12),
          _radioGroup(
            question:
                "Are iron & protein-rich foods a regular part of your daily meals?",
            options: [
              "Yes, almost every day",
              "Yes, a few times a week",
              "Occasionally",
              "Rarely",
              "No",
            ],
            selected: widget.data.ironRichFoods,
            onSelect: (v) => widget.data.ironRichFoods = v,
          ),
          SizedBox(height: 12),
          _radioGroup(
            question: "On average, how many hours do you sleep per night?",
            options: [
              "Less than 5 hours",
              "5-6 hours",
              "6-7 hours",
              "7-8 hours",
              "More than 8 hours",
            ],
            selected: widget.data.sleepHours,
            onSelect: (v) => widget.data.sleepHours = v,
          ),
          SizedBox(height: 12),
          _stressSlider(),
        ],
      ),
    );
  }
}