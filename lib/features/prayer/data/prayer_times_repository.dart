import '../models/prayer_time.dart';

class PrayerTimesRepository {
  Future<DailyPrayerTimes> fetchTodayPrayerTimes() async {
    return defaultGazganTimes();
  }

  PrayerTime getCurrentOrNextPrayer(
    DailyPrayerTimes prayerTimes, {
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final currentMinutes = current.hour * 60 + current.minute;

    for (final prayer in prayerTimes.times) {
      if (prayer.minutesSinceMidnight >= currentMinutes) {
        return prayer;
      }
    }

    return prayerTimes.times.first;
  }

  static DailyPrayerTimes defaultGazganTimes({DateTime? date}) {
    return DailyPrayerTimes(
      location: "G'ozg'on",
      date: date ?? DateTime.now(),
      isDefaultLocation: true,
      times: const <PrayerTime>[
        PrayerTime(name: 'Bomdod', time: '05:12'),
        PrayerTime(name: 'Quyosh', time: '06:38'),
        PrayerTime(name: 'Peshin', time: '12:34'),
        PrayerTime(name: 'Asr', time: '16:42'),
        PrayerTime(name: 'Shom', time: '19:08'),
        PrayerTime(name: 'Xufton', time: '20:31'),
      ],
    );
  }
}
