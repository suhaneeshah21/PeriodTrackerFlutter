import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class CycleInfoPage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const CycleInfoPage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<CycleInfoPage> createState() => _CycleInfoPageState();
}

class _CycleInfoPageState extends State<CycleInfoPage> {
  static const primary = Color(0xFF6C3EAB);

  Widget _stepper({
    required String label,
    required int value,
    required int min,
    required int max,
    required Function(int) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700])),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (value > min) setState(() => onChanged(value - 1));
                },
                icon: Icon(Icons.remove_circle_outline, color: primary),
                iconSize: 32,
              ),
              SizedBox(width: 16),
              Text("$value days",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primary)),
              SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  if (value < max) setState(() => onChanged(value + 1));
                },
                icon: Icon(Icons.add_circle_outline, color: primary),
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "Tell us about\nyour cycle",
      subtitle: "We'll use this to predict your next period",
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 24),
          _stepper(
            label: "Average cycle length",
            value: widget.data.avgCycleLength,
            min: 20,
            max: 45,
            onChanged: (v) => widget.data.avgCycleLength = v,
          ),
          SizedBox(height: 16),
          _stepper(
            label: "Average period duration",
            value: widget.data.avgPeriodDuration,
            min: 1,
            max: 10,
            onChanged: (v) => widget.data.avgPeriodDuration = v,
          ),
        ],
      ),
    );
  }
}