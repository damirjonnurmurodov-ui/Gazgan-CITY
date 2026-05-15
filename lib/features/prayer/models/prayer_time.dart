class PrayerTime {
  const PrayerTime({required this.name, required this.time});

  final String name;
  final String time;

  int get minutesSinceMidnight {
    final parts = time.split(':');
    if (parts.length != 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }
}

class DailyPrayerTimes {
  const DailyPrayerTimes({
    required this.location,
    required this.date,
    required this.times,
    this.isDefaultLocation = true,
  });

  final String location;
  final DateTime date;
  final List<PrayerTime> times;
  final bool isDefaultLocation;

  PrayerTime get featuredPrayer => times.first;

  PrayerTime get nextAfterFeatured {
    if (times.length < 2) return times.first;
    return times[1];
  }
}
