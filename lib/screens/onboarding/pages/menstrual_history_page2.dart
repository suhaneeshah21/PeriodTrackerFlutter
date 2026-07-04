import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class MenstrualHistoryPage2 extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const MenstrualHistoryPage2({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<MenstrualHistoryPage2> createState() => _MenstrualHistoryPage2State();
}

class _MenstrualHistoryPage2State extends State<MenstrualHistoryPage2> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  bool get _canProceed =>
      widget.data.bleedingType != null &&
      widget.data.spotting != null &&
      widget.data.whiteDischarge != null;

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
      title: "Menstrual\npatterns",
      subtitle: "A few more questions about your cycle",
      onNext: _canProceed ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 16),
          _radioGroup(
            question:
                "Do you experience heavy menstrual bleeding or passing of clots?",
            options: [
              "Heavy bleeding",
              "Heavy bleeding with clots",
              "No heavy bleeding",
            ],
            selected: widget.data.bleedingType,
            onSelect: (v) => widget.data.bleedingType = v,
          ),
          SizedBox(height: 12),
          _radioGroup(
            question: "Do you experience spotting (light bleeding) between periods?",
            options: ["Yes", "No", "Not sure"],
            selected: widget.data.spotting,
            onSelect: (v) => widget.data.spotting = v,
          ),
          SizedBox(height: 12),
          _radioGroup(
            question: "Do you experience white discharge?",
            options: ["Yes", "No"],
            selected: widget.data.whiteDischarge,
            onSelect: (v) => widget.data.whiteDischarge = v,
          ),
        ],
      ),
    );
  }
}