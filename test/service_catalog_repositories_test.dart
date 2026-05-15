import 'package:flutter_test/flutter_test.dart';
import 'package:gazgan_city/features/services/data/jobs_repository.dart';
import 'package:gazgan_city/features/services/data/masters_repository.dart';
import 'package:gazgan_city/features/services/data/taxi_services_repository.dart';
import 'package:gazgan_city/features/services/data/useful_contacts_repository.dart';

void main() {
  test('taxi services repository maps active service rows', () async {
    final repository = TaxiServicesRepository(
      dataSource: _TaxiDataSource(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'taxi-1',
          'name': 'Gazgan Taxi',
          'phone': '+998901112233',
          'description': 'Shahar bo\'ylab tezkor taxi.',
          'is_active': true,
        },
      ]),
    );

    final result = await repository.fetchServicesResult();
    final item = result.data.single;

    expect(result.isFallback, isFalse);
    expect(item.id, 'taxi-1');
    expect(item.name, 'Gazgan Taxi');
    expect(item.phone, '+998901112233');
    expect(item.description, 'Shahar bo\'ylab tezkor taxi.');
    expect(item.isActive, isTrue);
  });

  test('masters repository maps active master rows', () async {
    final repository = MastersRepository(
      dataSource: _MastersDataSource(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'master-1',
          'name': 'Ali usta',
          'profession': 'Elektrik',
          'phone': '+998911112233',
          'description': 'Uy elektr tarmoqlarini ta\'mirlaydi.',
          'is_active': true,
        },
      ]),
    );

    final result = await repository.fetchMastersResult();
    final item = result.data.single;

    expect(result.isFallback, isFalse);
    expect(item.id, 'master-1');
    expect(item.name, 'Ali usta');
    expect(item.profession, 'Elektrik');
    expect(item.phone, '+998911112233');
    expect(item.description, 'Uy elektr tarmoqlarini ta\'mirlaydi.');
    expect(item.isActive, isTrue);
  });

  test('useful contacts repository maps active contact rows', () async {
    final repository = UsefulContactsRepository(
      dataSource: _ContactsDataSource(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'contact-1',
          'title': 'Shahar ishonch telefoni',
          'phone': '1050',
          'category': 'Ishonch raqami',
          'description': 'Murojaatlar uchun rasmiy raqam.',
          'is_active': true,
        },
      ]),
    );

    final result = await repository.fetchContactsResult();
    final item = result.data.single;

    expect(result.isFallback, isFalse);
    expect(item.id, 'contact-1');
    expect(item.title, 'Shahar ishonch telefoni');
    expect(item.phone, '1050');
    expect(item.category, 'Ishonch raqami');
    expect(item.description, 'Murojaatlar uchun rasmiy raqam.');
    expect(item.isActive, isTrue);
  });

  test('jobs repository maps active job rows', () async {
    final repository = JobsRepository(
      dataSource: _JobsDataSource(<Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'job-1',
          'title': 'Operator',
          'organization': 'Gazgan City markazi',
          'salary': 'Kelishiladi',
          'phone': '+998971112233',
          'description': 'Fuqarolar murojaatlari bilan ishlash.',
          'is_active': true,
        },
      ]),
    );

    final result = await repository.fetchJobsResult();
    final item = result.data.single;

    expect(result.isFallback, isFalse);
    expect(item.id, 'job-1');
    expect(item.title, 'Operator');
    expect(item.organization, 'Gazgan City markazi');
    expect(item.salary, 'Kelishiladi');
    expect(item.phone, '+998971112233');
    expect(item.description, 'Fuqarolar murojaatlari bilan ishlash.');
    expect(item.isActive, isTrue);
  });
}

class _TaxiDataSource implements TaxiServicesDataSource {
  const _TaxiDataSource(this.rows);

  final List<Map<String, dynamic>> rows;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async => rows;
}

class _MastersDataSource implements MastersDataSource {
  const _MastersDataSource(this.rows);

  final List<Map<String, dynamic>> rows;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async => rows;
}

class _ContactsDataSource implements UsefulContactsDataSource {
  const _ContactsDataSource(this.rows);

  final List<Map<String, dynamic>> rows;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async => rows;
}

class _JobsDataSource implements JobsDataSource {
  const _JobsDataSource(this.rows);

  final List<Map<String, dynamic>> rows;

  @override
  Future<List<Map<String, dynamic>>> fetchRows() async => rows;
}
