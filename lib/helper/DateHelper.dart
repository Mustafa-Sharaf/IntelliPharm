
//New code
/*
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
}*/
class DateHelper {
  // دالتك القديمة
  static String getFormattedDate() {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return "${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}";
  }

  // الدالة الجديدة لتنسيق الزيارة المجدولة: "Mon, 6 April 2026 at 10:15 AM"
  static String formatScheduledVisit() {
    final now = DateTime.now();
    const shortDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const fullMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    final dayName = shortDays[now.weekday - 1];
    final monthName = fullMonths[now.month - 1];

    // تنسيق الساعة والدقائق ونظام الـ AM/PM
    int hour = now.hour;
    final String period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12; // معالجة الساعة 00 لتصبح 12

    final String minute = now.minute.toString().padLeft(2, '0');

    return "$dayName, ${now.day} $monthName ${now.year} at $hour:$minute $period";
  }
}