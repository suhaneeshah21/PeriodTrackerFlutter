import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class HeightWeightPage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const HeightWeightPage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<HeightWeightPage> createState() => _HeightWeightPageState();
}

class _HeightWeightPageState extends State<HeightWeightPage> {
  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);

  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(
        text: widget.data.heightCm.toInt().toString());
    _weightController = TextEditingController(
        text: widget.data.weightKg.toString());
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  String _getBMI() {
    final h = widget.data.heightCm / 100;
    final bmi = widget.data.weightKg / (h * h);
    return bmi.toStringAsFixed(1);
  }

  Widget _stepperWithInput({
    required String label,
    required String unit,
    required double value,
    required double min,
    required double max,
    required double step,
    required TextEditingController controller,
    required Function(double) onChanged,
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
                  if (value - step >= min) {
                    setState(() {
                      onChanged(value - step);
                      controller.text = (value - step) % 1 == 0
                          ? (value - step).toInt().toString()
                          : (value - step).toStringAsFixed(1);
                    });
                  }
                },
                icon: Icon(Icons.remove_circle_outline, color: primary),
                iconSize: 32,
              ),
              SizedBox(width: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  SizedBox(
                    width: 70,
                    child: TextField(
                      controller: controller,
                      textAlign: TextAlign.center,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,1}'))
                      ],
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primary),
                      decoration: InputDecoration(border: InputBorder.none),
                      onChanged: (val) {
                        final parsed = double.tryParse(val);
                        if (parsed != null &&
                            parsed >= min &&
                            parsed <= max) {
                          setState(() => onChanged(parsed));
                        }
                      },
                    ),
                  ),
                  Text(" $unit",
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey[500])),
                ],
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  if (value + step <= max) {
                    setState(() {
                      onChanged(value + step);
                      controller.text = (value + step) % 1 == 0
                          ? (value + step).toInt().toString()
                          : (value + step).toStringAsFixed(1);
                    });
                  }
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
      title: "Your body\nmeasurements",
      subtitle: "Used for health insights and BMI calculation",
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 24),
          _stepperWithInput(
            label: "Height",
            unit: "cm",
            value: widget.data.heightCm,
            min: 100,
            max: 220,
            step: 1,
            controller: _heightController,
            onChanged: (v) => widget.data.heightCm = v,
          ),
          SizedBox(height: 16),
          _stepperWithInput(
            label: "Weight",
            unit: "kg",
            value: widget.data.weightKg,
            min: 30,
            max: 200,
            step: 0.5,
            controller: _weightController,
            onChanged: (v) => widget.data.weightKg = v,
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Your BMI",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: primary)),
                Text(_getBMI(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}