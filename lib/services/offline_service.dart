import 'package:hive/hive.dart';

class OfflineService {

  final tasksBox = Hive.box("tasksBox");
  final queueBox = Hive.box("syncQueueBox");

  /// Save tasks locally
  void cacheTasks(List tasks) {
    tasksBox.put("tasks", tasks);
  }

  /// Get cached tasks
  List getCachedTasks() {
    return tasksBox.get("tasks", defaultValue: []);
  }

  /// Add update to queue
  void addToQueue(Map taskUpdate) {
    List queue = queueBox.get("queue", defaultValue: []);
    queue.add(taskUpdate);
    queueBox.put("queue", queue);
  }

  /// Get queue
  List getQueue() {
    return queueBox.get("queue", defaultValue: []);
  }

  /// Clear queue
  void clearQueue() {
    queueBox.put("queue", []);
  }
}