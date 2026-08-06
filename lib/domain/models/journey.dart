// lib/domain/models/journey.dart

enum JourneyStatus { active, completed }

class Journey {
  final String id;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final String? coverPhotoPath; // đường dẫn local file
  final DateTime createdAt;
  final DateTime updatedAt;

  const Journey({
    required this.id,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
    this.coverPhotoPath,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convenience getter
  JourneyStatus get status =>
      endDate == null ? JourneyStatus.active : JourneyStatus.completed;

  bool get isActive => status == JourneyStatus.active;
  bool get isCompleted => status == JourneyStatus.completed;

  Journey copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? coverPhotoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearEndDate = false,
    bool clearCoverPhoto = false,
    bool clearDescription = false,
  }) {
    return Journey(
      id: id ?? this.id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      coverPhotoPath: clearCoverPhoto
          ? null
          : (coverPhotoPath ?? this.coverPhotoPath),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    startDate,
    endDate,
    coverPhotoPath,
    createdAt,
    updatedAt,
  ];
}
