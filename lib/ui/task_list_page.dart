import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../utils/utils.dart';

class TaskListPage extends StatelessWidget {
  final TaskController c = Get.put(TaskController());
  final AuthController auth = Get.find<AuthController>();

  TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    c.fetchTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(),
        child: const Icon(Icons.add),
      ),

      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// Empty state
        if (c.tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.task_alt, size: 60, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No tasks yet",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Create tasks and manage your day 🚀",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
  onRefresh: () async {
    await c.syncOfflineUpdates();
    await c.fetchTasks();
  },
  child: ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: c.tasks.length,
    itemBuilder: (_, i) {
      final task = c.tasks[i];

      return Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6),
        child: ListTile(
          title: Text(task["title"] ?? ""),
          subtitle: Text(task["status"] ?? ""),
          trailing: task["isOffline"] == true
              ? const Icon(Icons.cloud_off, color: Colors.orange)
              : const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => Get.toNamed("/detail", arguments: task),
        ),
      );
    },
  ),
);
      }),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),

          ElevatedButton(
            onPressed: () {
              auth.logout();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  /// Create Task Dialog with validation
  void _showCreateDialog() {
    final title = TextEditingController();
    final desc = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        title: const Text(
          "Create Task",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: desc,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),

        actions: [
          /// Cancel button
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),

          /// Create button
          ElevatedButton(
            onPressed: () {
              String t = title.text.trim();
              String d = desc.text.trim();

              if (t.length < 5 || d.length < 5) {
                Utils.toastMesage("Minimum 5 characters required");
                return;
              }

              c.createTask(t, d);

              Get.back();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
