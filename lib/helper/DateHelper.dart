
//New code
class DateHelper {
  static String getFormattedDate() {
    final now = DateTime.now();

    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final dayName = days[now.weekday - 1];
    final day = now.day;
    final monthName = months[now.month - 1];
    final year = now.year;

    return "$dayName, $day $monthName $year";
  }
}