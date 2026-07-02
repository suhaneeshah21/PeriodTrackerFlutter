import 'package:flutter/material.dart';

class CycleLogScreen extends StatefulWidget {
  const CycleLogScreen({super.key});

  @override
  State<CycleLogScreen> createState() => _CycleLogScreenState();
}

class _CycleLogScreenState extends State<CycleLogScreen> {
  DateTime viewingDate = DateTime.now();
  DateTime? periodStartDate;
  String? selectedFlow;
  List<String> selectedSymptoms = [];

  final List<String> allSymptoms = [
    "Cramps", "Bloating", "Fatigue", "Headache",
    "Acne", "Hair Loss", "Mood Swings", "Back Pain",
    "Nausea", "Breast Tenderness",
  ];

  late final List<DateTime> dateList;
  late final ScrollController _scrollController;

  static const primary = Color.fromARGB(255, 171, 62, 144);
  static const accent = Color.fromARGB(30, 171, 62, 144);
  static const cardBg = Color.fromARGB(255, 171, 62, 144);
  static const bg = Color(0xFFF7F3FF);

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    dateList = List.generate(61, (i) => today.subtract(Duration(days: 30 - i)));
    _scrollController = ScrollController(initialScrollOffset: 30 * 56.0);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _openCalendar() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: periodStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: "Select Period Start Date",
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => periodStartDate = picked);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekDay(DateTime date) {
    const days = ["S", "M", "T", "W", "T", "F", "S"];
    return days[date.weekday % 7];
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  String _getCycleInfo() {
    if (periodStartDate == null) return "Log your period\nstart date";
    final diff = viewingDate.difference(periodStartDate!).inDays;
    if (diff < 0) return "Before period";
    if (diff < 5) return "Period\nDay ${diff + 1}";
    if (diff < 14) return "Follicular\nPhase";
    if (diff == 14) return "Ovulation\nDay";
    return "Luteal\nPhase";
  }

  String _getDaysToOvulation() {
    if (periodStartDate == null) return "--";
    final ovulation = periodStartDate!.add(Duration(days: 14));
    final diff = ovulation.difference(viewingDate).inDays;
    if (diff < 0) return "Passed";
    if (diff == 0) return "Today";
    return "$diff days";
  }

  String _getDaysToNextPeriod() {
    if (periodStartDate == null) return "--";
    final next = periodStartDate!.add(Duration(days: 28));
    final diff = next.difference(viewingDate).inDays;
    if (diff < 0) return "Passed";
    if (diff == 0) return "Today";
    return "$diff days";
  }

  void _saveLog() {
    if (periodStartDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please log your period start date first")),
      );
      return;
    }
    if (selectedFlow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select flow intensity")),
      );
      return;
    }
    print("Period Start: $periodStartDate");
    print("Flow: $selectedFlow");
    print("Symptoms: $selectedSymptoms");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cycle logged!"), backgroundColor: primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // --- Top Bar ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NariHealth",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                                letterSpacing: 1.2)),
                        Text(
                          "${viewingDate.day} ${_monthName(viewingDate.month)} ${viewingDate.year}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primary),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _openCalendar,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.calendar_month,
                            color: primary, size: 24),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Horizontal Strip ---
              SizedBox(
                height: 82,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: dateList.length,
                  itemExtent: 56,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: (context, index) {
                    final date = dateList[index];
                    final isViewing = _isSameDay(date, viewingDate);
                    final isToday = _isSameDay(date, DateTime.now());

                    return GestureDetector(
                      onTap: () => setState(() => viewingDate = date),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _weekDay(date),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isViewing ? primary : Colors.grey[400],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isViewing ? primary : Colors.transparent,
                              border: isToday && !isViewing
                                  ? Border.all(color: primary, width: 1.5)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                "${date.day}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isViewing
                                      ? Colors.white
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday ? primary : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 12),

              // --- Cycle Info Card ---
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.3),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: periodStartDate == null
                    ? Column(
                        children: [
                          Icon(Icons.favorite_border,
                              color: Colors.white60, size: 36),
                          SizedBox(height: 10),
                          Text(
                            "Tap the calendar icon\nto log your period start date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cycle Status",
                                    style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                        letterSpacing: 1)),
                                SizedBox(height: 4),
                                Text(
                                  _getCycleInfo(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      height: 1.3),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _infoChip("Ovulation", _getDaysToOvulation()),
                              SizedBox(height: 8),
                              _infoChip("Next period", _getDaysToNextPeriod()),
                            ],
                          ),
                        ],
                      ),
              ),

              SizedBox(height: 28),

              // --- Flow Intensity ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Flow Intensity",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ["Light", "Medium", "Heavy", "Spotting"]
                          .map((flow) {
                        final isSelected = selectedFlow == flow;
                        return GestureDetector(
                          onTap: () => setState(() => selectedFlow = flow),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? primary : Colors.white,
                              border: Border.all(
                                  color: isSelected
                                      ? primary
                                      : Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: primary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              flow,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // --- Symptoms ---
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Symptoms",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800])),
                    SizedBox(height: 4),
                    Text("Select all that apply",
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[500])),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: allSymptoms.map((symptom) {
                        final isSelected = selectedSymptoms.contains(symptom);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              isSelected
                                  ? selectedSymptoms.remove(symptom)
                                  : selectedSymptoms.add(symptom);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? accent : Colors.white,
                              border: Border.all(
                                  color: isSelected
                                      ? primary
                                      : Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              symptom,
                              style: TextStyle(
                                color: isSelected
                                    ? primary
                                    : Colors.grey[700],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28),

              // --- Save Button ---
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 36),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 4,
                      shadowColor: primary.withOpacity(0.4),
                    ),
                    child: Text(
                      "Save Log",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: Colors.white60)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
        ],
      ),
    );
  }
}