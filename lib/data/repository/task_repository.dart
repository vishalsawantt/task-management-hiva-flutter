import '../../core/network_service.dart';

class TaskRepository {

  final api = NetworkApiService();

  Future<dynamic> getTasks(int pageNo, int pageSize) async {
    return await api.getApi("/tasks", data: {
      "pageNo": pageNo,
      "pageSize": pageSize
    });
  }

  Future<dynamic> createTask(String title, String description) async {
    return await api.postApi("/tasks", {
      "title": title,
      "description": description
    });
  }

  Future<dynamic> updateTask(int id, Map<String, dynamic> data) async {
    return await api.putApi("/tasks/$id", data);
  }

  Future<dynamic> bulkSync(List queue) async {
  return await api.postApi("/tasks/bulk-sync", queue);
}
}