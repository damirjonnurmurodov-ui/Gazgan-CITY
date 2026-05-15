import '../../../core/data/json_readers.dart';
import '../../news/models/news_item.dart';

class HomeContent {
  const HomeContent({
    required this.announcement,
    required this.reception,
    required this.news,
    required this.announcementCount,
    required this.receptionCount,
  });

  final HomeAnnouncement announcement;
  final HomeReception reception;
  final List<NewsItem> news;
  final int announcementCount;
  final int receptionCount;
}

class HomeAnnouncement {
  const HomeAnnouncement({
    required this.badge,
    required this.title,
    required this.description,
  });

  final String badge;
  final String title;
  final String description;

  factory HomeAnnouncement.fromJson(Map<String, dynamic> json) {
    return HomeAnnouncement(
      badge: readString(json, const <String>[
        'badge',
        'category',
        'category_name',
      ], fallback: 'Rasmiy e\'lon'),
      title: readString(json, const <String>[
        'title',
        'name',
      ], fallback: 'Bugun Marmarobod MFYda sayyor qabul'),
      description: readString(json, const <String>[
        'description',
        'content',
        'body',
      ], fallback: 'Soat 15:00 da hokim sayyor qabuli bo\'lib o\'tadi'),
    );
  }
}

class HomeReception {
  const HomeReception({
    required this.title,
    required this.location,
    required this.time,
  });

  final String title;
  final String location;
  final String time;

  factory HomeReception.fromJson(Map<String, dynamic> json) {
    return HomeReception(
      title: readString(json, const <String>[
        'title',
        'name',
      ], fallback: 'Hokim sayyor qabuli'),
      location: readString(json, const <String>[
        'location',
        'address',
        'mahalla',
      ], fallback: 'Marmarobod MFY'),
      time: readString(json, const <String>[
        'time',
        'date',
        'starts_at',
        'created_at',
      ], fallback: 'Bugun, 15:00'),
    );
  }
}
