class PageHeaderModel {
  final int pages;
  final int itemsTotalCount;

  PageHeaderModel({
    required this.pages,
    required this.itemsTotalCount,
  });

  factory PageHeaderModel.fromMap(Map<String, dynamic> map) {
    return PageHeaderModel(
      pages: int.parse(map['x-wp-totalpages'] as String? ?? '0'),
      itemsTotalCount: int.parse(map['x-wp-total'] as String? ?? '0'),
    );
  }
}
