import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy data — will come from user profile later
  final DateTime periodStartDate = DateTime(2026, 6, 15);
  final int avgCycleLength = 28;

  late DateTime viewingDate;
  late List<DateTime> dateList;
  late DateTime nextPeriodDate;
  late ScrollController _scrollController;

  static const primary = Color(0xFF6C3EAB);
  static const accent = Color(0xFFE8DEFF);
  static const cardBg = Color(0xFF7B4FBE);
  static const bg = Color(0xFFF7F3FF);

  @override
  void initState() {
    super.initState();
    viewingDate = DateTime.now();
    nextPeriodDate = periodStartDate.add(Duration(days: avgCycleLength));

    // Date list from period start to next predicted period
    final totalDays = nextPeriodDate.difference(periodStartDate).inDays + 1;
    dateList = List.generate(
      totalDays,
      (i) => periodStartDate.add(Duration(days: i)),
    );

    // Scroll to today
    final todayIndex = DateTime.now().difference(periodStartDate).inDays;
    final clampedIndex = todayIndex.clamp(0, dateList.length - 1);
    _scrollController = ScrollController(
      initialScrollOffset: clampedIndex * 56.0,
    );

    // Clamp viewingDate to valid range
    if (viewingDate.isBefore(periodStartDate)) viewingDate = periodStartDate;
    if (viewingDate.isAfter(nextPeriodDate)) viewingDate = nextPeriodDate;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  String _getPhase() {
    final day = viewingDate.difference(periodStartDate).inDays;
    if (day < 5) return "Menstrual Phase";
    if (day < 14) return "Follicular Phase";
    if (day == 14) return "Ovulation";
    return "Luteal Phase";
  }

  String _getPhaseDescription() {
    final day = viewingDate.difference(periodStartDate).inDays;
    if (day < 5) return "Your body is shedding the uterine lining. Rest and stay hydrated.";
    if (day < 14) return "Estrogen is rising. Energy levels are increasing gradually.";
    if (day == 14) return "Peak fertility window. Ovulation is happening today.";
    return "Progesterone rises. You may feel calmer but energy may dip closer to your period.";
  }

  int _getDaysToNextPeriod() {
    return nextPeriodDate.difference(viewingDate).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final daysToNext = _getDaysToNextPeriod();

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
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Cycle Day ${viewingDate.difference(periodStartDate).inDays + 1}",
                        style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              // --- Date Strip ---
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
                    final isLast = _isSameDay(date, nextPeriodDate);

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
                              color: isViewing
                                  ? primary
                                  : isLast
                                      ? Colors.red[100]
                                      : Colors.transparent,
                              border: isToday && !isViewing
                                  ? Border.all(color: primary, width: 1.5)
                                  : isLast && !isViewing
                                      ? Border.all(
                                          color: Colors.red[300]!, width: 1.5)
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
                                      : isLast
                                          ? Colors.red[400]
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
                              color: isToday
                                  ? primary
                                  : Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16),

              // --- Phase Card ---
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Phase + days row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Current Phase",
                                style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                    letterSpacing: 1)),
                            SizedBox(height: 4),
                            Text(
                              _getPhase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "$daysToNext",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "days to\nnext period",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    // Phase description
                    Text(
                      _getPhaseDescription(),
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.5),
                    ),

                    SizedBox(height: 16),

                    // Know more
                    GestureDetector(
                      onTap: () {
                        // opens phase detail screen later
                      },
                      child: Row(
                        children: [
                          Text(
                            "Know more",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 12),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}