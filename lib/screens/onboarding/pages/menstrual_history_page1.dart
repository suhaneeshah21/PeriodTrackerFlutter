import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class MenstrualHistoryPage1 extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const MenstrualHistoryPage1({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<MenstrualHistoryPage1> createState() => _MenstrualHistoryPage1State();
}

class _MenstrualHistoryPage1State extends State<MenstrualHistoryPage1> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(
        text: widget.data.ageAtFirstPeriod?.toString() ?? "");
  }

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  bool get _canProceed =>
      widget.data.ageAtFirstPeriod != null &&
      widget.data.takesDelayPills != null &&
      widget.data.cycleRegularity != null;

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
      title: "Menstrual\nhistory",
      subtitle: "This helps us understand your cycle better",
      onNext: _canProceed ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 16),

          // Age at first period
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("At what age did you get your first period?",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800])),
                SizedBox(height: 10),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Enter age",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                    suffixText: "years",
                  ),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= 8 && parsed <= 20) {
                      setState(() => widget.data.ageAtFirstPeriod = parsed);
                    }
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          _radioGroup(
            question: "Do you take pills/medicines to delay your periods?",
            options: ["Yes", "No"],
            selected: widget.data.takesDelayPills,
            onSelect: (v) => widget.data.takesDelayPills = v,
          ),

          SizedBox(height: 12),

          _radioGroup(
            question: "How regular are your periods?",
            options: [
              "Very regular (arrives within 1-2 days of expected date)",
              "Mostly regular (small changes of 3-5 days)",
              "Often irregular (changes more than 7 days)",
              "Completely unpredictable",
              "I do not track my cycle",
            ],
            selected: widget.data.cycleRegularity,
            onSelect: (v) => widget.data.cycleRegularity = v,
          ),
        ],
      ),
    );
  }
}