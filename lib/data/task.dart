enum Priority { high, medium, low }

extension on Priority {
  int compareTo(Priority other) => index.compareTo(other.index);

  String get name {
    switch (this) {
      case Priority.high:
        return "Alta";
      case Priority.medium:
        return "Media";
      case Priority.low:
        return "Baja";
      default:
        return "";
    }
  }
}

Priority priorityFromName(String name) {
  switch (name) {
    case "Alta":
      return Priority.high;
    case "Media":
      return Priority.medium;
    case "Baja":
      return Priority.low;
    default:
      return Priority.low;
  }
}

String priorityName(Priority priority) => priority.name;

class Task {
  final String title;
  final String description;
  final DateTime date;
  final Priority priority;
  bool isDone;

  Task(
      {required this.title,
      required this.description,
      required this.date,
      required this.priority,
      required this.isDone});

  int compareTo(Task other) {
    if (priority == other.priority) {
      return date.compareTo(other.date);
    } else {
      return priority.compareTo(other.priority);
    }
  }

  String get priorityName => priority.name;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
      title: json["title"] as String,
      description: json["description"] as String,
      date: DateTime.parse(json["date"] as String),
      priority: priorityFromName(json["priority"] as String),
      isDone: json["isDone"] as bool);

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "date": date.toIso8601String(),
        "priority": priorityName,
        "isDone": isDone,
      };
}

class User {
  String name;
  String email;
  String password;

  User({required this.name, required this.email, required this.password});
}
