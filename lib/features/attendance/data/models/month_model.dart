class MonthModel {
  final int monthId;
  final String monthName;

  MonthModel({
    required this.monthId,
    required this.monthName,
  });
}

final List<MonthModel> monthList = [
  MonthModel(monthId: 1, monthName: 'January'),
  MonthModel(monthId: 2, monthName: 'February'),
  MonthModel(monthId: 3, monthName: 'March'),
  MonthModel(monthId: 4, monthName: 'April'),
  MonthModel(monthId: 5, monthName: 'May'),
  MonthModel(monthId: 6, monthName: 'June'),
  MonthModel(monthId: 7, monthName: 'July'),
  MonthModel(monthId: 8, monthName: 'August'),
  MonthModel(monthId: 9, monthName: 'September'),
  MonthModel(monthId: 10, monthName: 'October'),
  MonthModel(monthId: 11, monthName: 'November'),
  MonthModel(monthId: 12, monthName: 'December'),
];