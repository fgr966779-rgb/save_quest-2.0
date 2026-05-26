import 'dart:convert';
import 'package:uuid/uuid.dart';

class Bounty {
  final String id;
  final String title;
  final String description;
  final double targetAmount; // how much needs to be saved
  final int rewardXp;
  final int rewardCredits;
  final DateTime deadline;
  final bool isCompleted;

  Bounty({
    String? id,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.rewardXp,
    required this.rewardCredits,
    required this.deadline,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  Bounty copyWith({
    String? id,
    String? title,
    String? description,
    double? targetAmount,
    int? rewardXp,
    int? rewardCredits,
    DateTime? deadline,
    bool? isCompleted,
  }) {
    return Bounty(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      rewardXp: rewardXp ?? this.rewardXp,
      rewardCredits: rewardCredits ?? this.rewardCredits,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'targetAmount': targetAmount,
      'rewardXp': rewardXp,
      'rewardCredits': rewardCredits,
      'deadline': deadline.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  factory Bounty.fromMap(Map<String, dynamic> map) {
    return Bounty(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetAmount: map['targetAmount']?.toDouble() ?? 0.0,
      rewardXp: map['rewardXp']?.toInt() ?? 0,
      rewardCredits: map['rewardCredits']?.toInt() ?? 0,
      deadline: DateTime.fromMillisecondsSinceEpoch(map['deadline']),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bounty.fromJson(String source) => Bounty.fromMap(json.decode(source));
}
