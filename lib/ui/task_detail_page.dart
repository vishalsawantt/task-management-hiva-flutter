import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../utils/utils.dart';

class TaskDetailPage extends StatelessWidget {
  TaskDetailPage({super.key});

  final Map<String, dynamic> task = Get.arguments;
  final TaskController c = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final title = TextEditingController(text: task["title"]);
    final desc = TextEditingController(text: task["description"]);
    final remarks = TextEditingController(text: task["remarks"]);

    String status = task["status"] ?? "PENDING";

    return Scaffold(
      appBar: AppBar(title: const Text("Task Detail")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
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
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: remarks,
              decoration: const InputDecoration(
                labelText: "Remarks",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "PENDING", child: Text("PENDING")),
                DropdownMenuItem(
                  value: "IN_PROGRESS",
                  child: Text("IN_PROGRESS"),
                ),
                DropdownMenuItem(value: "COMPLETED", child: Text("COMPLETED")),
                DropdownMenuItem(value: "CANCELLED", child: Text("CANCELLED")),
              ],
              onChanged: (val) => status = val!,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String t = title.text.trim();
                  String d = desc.text.trim();

                  if (t.length < 5 || d.length < 5) {
                    Utils.toastMesage(
                      "Title & Description must be at least 5 characters",
                    );
                    return;
                  }

                  c.updateTask(
                    id: task["id"],
                    title: t,
                    description: d,
                    remarks: remarks.text.trim(),
                    status: status,
                  );

                  Get.back();
                },
                child: const Text("Update Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
