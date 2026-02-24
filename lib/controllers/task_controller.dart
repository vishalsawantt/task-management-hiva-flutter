import 'package:get/get.dart';
import 'package:taskmanagementflutter/services/connectivity_service.dart';
import 'package:taskmanagementflutter/services/offline_service.dart';
import '../data/repository/task_repository.dart';
import '../utils/utils.dart';

class TaskController extends GetxController {
  final repo = TaskRepository();
  RxList<Map<String, dynamic>> tasks = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  final offline = OfflineService();

  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  Future initLoad() async {
    await syncOfflineUpdates();
    await fetchTasks();
  }

  Future fetchTasks({int pageNo = 0, int pageSize = 10}) async {
    isLoading.value = true;
    bool online = await ConnectivityService.isOnline();
    if (online) {
      final res = await repo.getTasks(pageNo, pageSize);

      List serverTasks = (res["content"] as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();

      //Cached tasks
      List cachedRaw = offline.getCachedTasks();
      List cached = cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList();
      List offlineOnly = cached.where((t) => t["isOffline"] == true).toList();
      tasks.value = [...serverTasks, ...offlineOnly];
      offline.cacheTasks(tasks);
    } else {
      List cachedRaw = offline.getCachedTasks();
      tasks.value = cachedRaw.map((e) => Map<String, dynamic>.from(e)).toList();
      Utils.toastMesage("Showing offline data");
    }
    isLoading.value = false;
  }

  
  Future createTask(String title, String description) async {
    bool online = await ConnectivityService.isOnline();

    if (online) {
      await repo.createTask(title, description);
      await fetchTasks();
      Utils.snackBar("Success", "Task created successfully");
    } else {
      //Create local temp task
      final tempTask = {
        "id": DateTime.now().millisecondsSinceEpoch,
        "title": title,
        "description": description,
        "status": "PENDING",
        "remarks": "",
        "isOffline": true,
      };

      //Add to UI
      tasks.add(tempTask);

      //Add to queue
      offline.addToQueue({"action": "CREATE", "data": tempTask});

      //Cache updated list
      offline.cacheTasks(tasks);

      Utils.toastMesage("Task saved offline");
    }
  }

  Future updateTask({
    required int id,
    String? title,
    String? description,
    String? status,
    String? remarks,
  }) async {
    bool online = await ConnectivityService.isOnline();

    final data = {
      "id": id,
      "title": title,
      "description": description,
      "status": status,
      "remarks": remarks,
    };

    if (online) {
      await repo.updateTask(id, data);
      await fetchTasks();
    } else {
      offline.addToQueue({"action": "UPDATE", "data": data});
      Utils.toastMesage("Saved offline. Will sync later");
    }
  }

  Future syncOfflineUpdates() async {
    bool online = await ConnectivityService.isOnline();
    if (!online) return;

    List queue = offline.getQueue();
    if (queue.isEmpty) return;

    try {
      for (var item in queue) {
        if (item["action"] == "CREATE") {
          await repo.createTask(
            item["data"]["title"],
            item["data"]["description"],
          );
        } else if (item["action"] == "UPDATE") {
          await repo.updateTask(item["data"]["id"], item["data"]);
        }
      }

      offline.clearQueue();

      //remove offline flag from cache
      List cached = offline
          .getCachedTasks()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      cached.removeWhere((t) => t["isOffline"] == true);
      offline.cacheTasks(cached);

      Utils.toastMesage("Offline changes synced");
    } catch (e) {
      Utils.snackBarError("Sync failed", "Will retry later");
    }
  }
}
