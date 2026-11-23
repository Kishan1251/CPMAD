import 'package:flutter/material.dart';
import 'core/getx.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GetxShowcaseApp(),
  ));
}


// --- 1. Basic Counter Controller (Section 14.2) ---
class CounterController extends GetxController {
  var count = 0.obs;

  void increment() => count.value++;
  void decrement() {
    if (count.value > 0) count.value--;
  }

  void reset() => count.value = 0;
}

// --- 2. Reactive User Model & Controller (Section 14.3) ---
class User {
  var name = 'John Doe'.obs;
  var age = 28.obs;
}

class UserController extends GetxController {
  final user = User().obs;

  void updateUser(String newName, int newAge) {
    user.update((val) {
      val?.name.value = newName;
      val?.age.value = newAge;
    });
  }
}

// --- 3. Dependency Injection Service & Controller (Section 14.4) ---
class ApiService {
  Future<List<String>> fetchData() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return ['Flutter 3.47', 'GetX Reactive State', 'Dependency Injection', 'SQLite DB', 'Cloud Firestore'];
  }
}

class DataController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  var items = <String>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    final result = await _apiService.fetchData();
    items.assignAll(result);
    isLoading.value = false;
  }
}

// --- Main GetX Showcase UI ---
class GetxShowcaseApp extends StatelessWidget {
  const GetxShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Register dependencies as taught in Section 14
    Get.put(ApiService());
    final CounterController counterController = Get.put(CounterController());
    final UserController userController = Get.put(UserController());
    final DataController dataController = Get.put(DataController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GetX State Management Suite'),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.add_circle_outline), text: 'Counter'),
              Tab(icon: Icon(Icons.person_outline), text: 'Reactive User'),
              Tab(icon: Icon(Icons.cloud_sync), text: 'Dependency Inj.'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active),
              tooltip: 'Show Get.snackbar',
              onPressed: () {
                Get.snackbar(
                  'GetX Notification',
                  'Triggered with Get.snackbar() without BuildContext!',
                  backgroundColor: Colors.indigo,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1: Counter (.obs + Obx)
            _buildCounterTab(context, counterController),

            // Tab 2: Reactive User Model (.update + Obx)
            _buildUserTab(context, userController),

            // Tab 3: Dependency Injection (Get.put + Get.find)
            _buildDataTab(context, dataController),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterTab(BuildContext context, CounterController c) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Section 14.2: Basic State Management with Obx',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Obx(() => Text(
                  'Clicks: ${c.count}',
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.indigo),
                )),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'dec_btn',
                  onPressed: c.decrement,
                  child: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'reset_btn',
                  onPressed: c.reset,
                  child: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'inc_btn',
                  onPressed: c.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTab(BuildContext context, UserController uc) {
    final nameInput = TextEditingController(text: 'Alice Wonder');
    final ageInput = TextEditingController(text: '24');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Section 14.3: Reactive Custom Model (User().obs)',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(() => Column(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        child: Icon(Icons.person, size: 40),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Name: ${uc.user.value.name}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Age: ${uc.user.value.age} years old',
                        style: const TextStyle(fontSize: 16, color: Colors.indigo),
                      ),
                    ],
                  )),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: nameInput,
            decoration: const InputDecoration(labelText: 'New Name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ageInput,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'New Age'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              final age = int.tryParse(ageInput.text) ?? 20;
              uc.updateUser(nameInput.text.trim(), age);
              Get.snackbar('User Updated', 'Reactive state refreshed automatically.');
            },
            icon: const Icon(Icons.edit),
            label: const Text('Update User Reactively'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTab(BuildContext context, DataController dc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Section 14.4: Dependency Injection (Get.put & Get.find)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (dc.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: dc.items.length,
                itemBuilder: (context, idx) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text('${idx + 1}')),
                      title: Text(dc.items[idx]),
                      subtitle: const Text('Injected via ApiService'),
                    ),
                  );
                },
              );
            }),
          ),
          ElevatedButton.icon(
            onPressed: dc.fetchItems,
            icon: const Icon(Icons.refresh),
            label: const Text('Reload Injected Service Data'),
          ),
        ],
      ),
    );
  }
}