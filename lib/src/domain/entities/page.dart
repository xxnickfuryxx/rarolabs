// coverage:ignore-file
import 'package:equatable/equatable.dart';
import 'package:rarolabs/src/domain/entities/user.dart';

class Page extends Equatable {
  Page({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.data,
  });

  final int page;
  final int perPage;
  final int total;
  final int totalPages;
  final List<User> data;

  @override
  List<Object?> get props => [page, perPage, total, totalPages, data];
}
