import 'package:flutter/material.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class LastPeriodPage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const LastPeriodPage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<LastPeriodPage> createState() => _LastPeriodPageState();
}

class _LastPeriodPageState extends State<LastPeriodPage> {
  static const primary = Color(0xFF6C3EAB);

  String _monthName(int month) {
    const months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "When did your\nlast period start?",
      subtitle: "Used to calculate your current cycle phase",
      onNext: widget.data.lastPeriodDate != null ? widget.onNext : null,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 32),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: widget.data.lastPeriodDate ?? DateTime.now(),
                firstDate: DateTime(2024),
                lastDate: DateTime.now(),
                builder: (context, child) => Theme(
                  data: ThemeData.light().copyWith(
                    colorScheme: ColorScheme.light(primary: primary),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) {
                setState(() => widget.data.lastPeriodDate = picked);
              }
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: widget.data.lastPeriodDate != null
                        ? primary
                        : Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.data.lastPeriodDate == null
                        ? "Select date"
                        : "${widget.data.lastPeriodDate!.day} ${_monthName(widget.data.lastPeriodDate!.month)} ${widget.data.lastPeriodDate!.year}",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: widget.data.lastPeriodDate == null
                            ? Colors.grey[400]
                            : primary),
                  ),
                  Icon(Icons.calendar_month,
                      color: widget.data.lastPeriodDate != null
                          ? primary
                          : Colors.grey[400]),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Don't remember exactly? An approximate date works fine.",
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}