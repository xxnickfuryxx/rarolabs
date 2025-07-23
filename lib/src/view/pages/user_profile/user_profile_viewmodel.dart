import 'package:flutter/foundation.dart';
import 'package:faker/faker.dart';

class UserProfileViewModel extends ChangeNotifier {
  String _jobTitle = '';
  String get jobTitle => _jobTitle;

  String _jobArea = '';
  String get jobArea => _jobArea;

  String _biography = '';
  String get biography => _biography;

  void generateFakeData() {
    final faker = Faker();
    _jobTitle = faker.job.title();
    _jobArea = faker.company.position();
    _biography = faker.lorem.sentences(5).join(' ');
  }

}
