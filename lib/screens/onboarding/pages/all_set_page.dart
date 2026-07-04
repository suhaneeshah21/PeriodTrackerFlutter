import 'package:flutter/material.dart';
import '../onboarding_data.dart';
import '../widgets/summary_item.dart';

class AllSetPage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onFinish;

  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  const AllSetPage({
    super.key,
    required this.data,
    required this.onFinish,
  });

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  String _bmi() {
    final h = data.heightCm / 100;
    return (data.weightKg / (h * h)).toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.check_circle, color: primary, size: 40),
          ),
          SizedBox(height: 32),
          Text("You're all set!",
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: primary)),
          SizedBox(height: 8),
          Text("Here's a summary of your profile:",
              style: TextStyle(fontSize: 14, color: Colors.grey[500])),
          SizedBox(height: 24),
          SummaryItem(label: "Age", value: "${data.age} years"),
          SummaryItem(
              label: "Height", value: "${data.heightCm.toInt()} cm"),
          SummaryItem(
              label: "Weight", value: "${data.weightKg} kg"),
          SummaryItem(label: "BMI", value: _bmi()),
          SummaryItem(
              label: "Cycle length", value: "${data.avgCycleLength} days"),
          SummaryItem(
              label: "Period duration",
              value: "${data.avgPeriodDuration} days"),
          SummaryItem(
              label: "Last period",
              value: data.lastPeriodDate != null
                  ? "${data.lastPeriodDate!.day} ${_monthName(data.lastPeriodDate!.month)} ${data.lastPeriodDate!.year}"
                  : "Not set"),
            SummaryItem(
              label: "Goals",
              value: data.goals.isEmpty ? "Not set" : data.goals.join(", ")),
          SummaryItem(
              label: "Conditions",
              value: data.existingConditions.isEmpty
                  ? "None"
                  : data.existingConditions.join(", ")),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onFinish,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text("Start using NariHealth",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}