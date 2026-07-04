import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/page_wrapper.dart';
import '../onboarding_data.dart';

class AgePage extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const AgePage({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  static const primary = Color(0xFF6C3EAB);
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: "${widget.data.age}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      title: "How old\nare you?",
      subtitle: "This helps us personalize your experience",
      onNext: widget.onNext,
      onBack: widget.onBack,
      child: Column(
        children: [
          SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  if (widget.data.age > 10) {
                    setState(() {
                      widget.data.age--;
                      _controller.text = "${widget.data.age}";
                    });
                  }
                },
                icon: Icon(Icons.remove_circle_outline, color: primary),
                iconSize: 36,
              ),
              SizedBox(width: 16),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: primary),
                  decoration: InputDecoration(border: InputBorder.none),
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null && parsed >= 10 && parsed <= 60) {
                      setState(() => widget.data.age = parsed);
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              IconButton(
                onPressed: () {
                  if (widget.data.age < 60) {
                    setState(() {
                      widget.data.age++;
                      _controller.text = "${widget.data.age}";
                    });
                  }
                },
                icon: Icon(Icons.add_circle_outline, color: primary),
                iconSize: 36,
              ),
            ],
          ),
          Text("years old",
              style: TextStyle(fontSize: 16, color: Colors.grey[500])),
        ],
      ),
    );
  }
}