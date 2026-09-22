class MaterialDetailsEntity {
  final int? materialId;
  final int? staffId;
  final String? accYear;
  final int? standardId;
  final int? divisionId;
  final int? subjectId;
  final List<String> material;
  final int? branchId;
  final String? createdDate;
  final String? createdUser;
  final String? modifiedDate;
  final String? modifiedUser;
  final String? notes;
  final String? link;
  final bool? favorite;

  const MaterialDetailsEntity({
    this.materialId,
    this.staffId,
    this.accYear,
    this.standardId,
    this.divisionId,
    this.subjectId,
    this.material = const [],
    this.branchId,
    this.createdDate,
    this.createdUser,
    this.modifiedDate,
    this.modifiedUser,
    this.notes,
    this.link,
    this.favorite,
  });
}

class MaterialDetailsResponseEntity {
  final int? status;
  final bool? error;
  final MaterialDetailsEntity? data;

  const MaterialDetailsResponseEntity({this.status, this.error, this.data});
}
