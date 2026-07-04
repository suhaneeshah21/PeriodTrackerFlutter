class OnboardingData {
  // Basic
  int age = 20;
  double heightCm = 160;
  double weightKg = 55;

  // Cycle
  int avgCycleLength = 28;
  int avgPeriodDuration = 5;
  DateTime? lastPeriodDate;

  // Goals — now multi-select
  List<String> goals = [];

  // Conditions
  List<String> existingConditions = [];

  // Lifestyle
  String? dietaryPreference;
  String? ironRichFoods;
  String? sleepHours;
  int stressLevel = 3;

  // Menstrual history
  int? ageAtFirstPeriod;
  String? takesDelayPills;
  String? cycleRegularity;
  String? bleedingType;
  String? spotting;
  String? whiteDischarge;
  String? painLevel;
  String? prePeriodSymptoms;
}