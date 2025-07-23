// coverage:ignore-file

import 'package:rarolabs/src/domain/entities/page.dart';
import 'package:rarolabs/src/data/models/user_model.dart';

class PageModel extends Page {
  PageModel({
    required super.page,
    required super.perPage,
    required super.total,
    required super.totalPages,
    required super.data,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      page: json['page'],
      perPage: json['per_page'],
      total: json['total'],
      totalPages: json['total_pages'],
      data: (json['data'] as List)
          .map((userJson) => UserModel.fromJson(userJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'per_page': perPage,
      'total': total,
      'total_pages': totalPages,
      'data': data,
    };
  }
}
