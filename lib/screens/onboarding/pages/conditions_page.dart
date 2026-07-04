import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class ConditionsPage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const ConditionsPage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ConditionsPage> createState() => _ConditionsPageState();
}

class _ConditionsPageState extends State<ConditionsPage> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  final List<String> conditions = [
    "PCOS",
    "Anemia",
    "Thyroid disorder",
    "Endometriosis",
    "Diabetes",
    "None of the above",
  ];

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "Any existing\nconditions?",
      subtitle: "Select all that apply — helps us give better insights",
      onNext: widget.data.existingConditions.isNotEmpty ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: conditions.map((c) {
              final isSelected = widget.data.existingConditions.contains(c);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (c == "None of the above") {
                      widget.data.existingConditions = ["None of the above"];
                    } else {
                      widget.data.existingConditions.remove("None of the above");
                      isSelected
                          ? widget.data.existingConditions.remove(c)
                          : widget.data.existingConditions.add(c);
                    }
                  });
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? accent : Colors.white,
                    border: Border.all(
                        color: isSelected ? primary : Colors.grey[300]!,
                        width: isSelected ? 2 : 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(c,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? primary : Colors.grey[700])),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}