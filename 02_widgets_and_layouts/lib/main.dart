import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WidgetsLayoutsApp(),
  ));
}


/// Udemy Course - Sections 4, 5, 6: Flutter Widgets, Layouts & Positioning
/// Demonstrates:
/// - Text styling, alignment, overflow handling
/// - Button variants: ElevatedButton, TextButton, OutlinedButton
/// - Network & Asset Images with loading and error builders
/// - Layout widgets: Row, Column, Expanded, Flexible
/// - Container styling: BoxDecoration, borders, shadows, and Matrix4 transformations
class WidgetsLayoutsApp extends StatelessWidget {
  const WidgetsLayoutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Widgets & Layouts Showcase'),
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.widgets), text: 'Basic Widgets'),
              Tab(icon: Icon(Icons.view_quilt), text: 'Layouts'),
              Tab(icon: Icon(Icons.format_paint), text: 'Containers'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BasicWidgetsTab(),
            _LayoutsTab(),
            _ContainersTab(),
          ],
        ),
      ),
    );
  }
}

class _BasicWidgetsTab extends StatelessWidget {
  const _BasicWidgetsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Text Widgets
        _sectionHeader('1. Text Widget Styles (Section 5)'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Styled Headline Text',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Center aligned text with custom line height and italic style.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This is a very long text demonstration that will automatically truncate with ellipsis when space runs out in the layout.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 2. Buttons
        _sectionHeader('2. Button Widgets (Elevated, Text, Outlined)'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ElevatedButton Pressed!')),
                    );
                  },
                  icon: const Icon(Icons.touch_app),
                  label: const Text('Elevated Button'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('TextButton Pressed!')),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                  label: const Text('Text Button'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OutlinedButton Pressed!')),
                    );
                  },
                  icon: const Icon(Icons.crop_square),
                  label: const Text('Outlined Button'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(color: Colors.orange, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Images with Error/Loading Builders
        _sectionHeader('3. Image Widget & Error Handling (Section 5)'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1579202673506-ca3ce28943ef?w=400',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        height: 160,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 160,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.broken_image, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text('Image Failed to Load (Network Offline)'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
      ),
    );
  }
}

class _LayoutsTab extends StatelessWidget {
  const _LayoutsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Row with spaceEvenly & Icons (Section 6)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.star, color: Colors.amber, size: 36),
                Icon(Icons.star, color: Colors.amber, size: 36),
                Icon(Icons.star, color: Colors.amber, size: 36),
                Icon(Icons.star_half, color: Colors.amber, size: 36),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Expanded & Flexible Space Allocation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 60,
                    color: Colors.red.shade400,
                    alignment: Alignment.center,
                    child: const Text('Expanded (flex: 2)', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  flex: 1,
                  child: Container(
                    height: 60,
                    color: Colors.green.shade500,
                    alignment: Alignment.center,
                    child: const Text('Flexible', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 60,
                    color: Colors.blue.shade400,
                    alignment: Alignment.center,
                    child: const Text('Flex: 1', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'ListView Linear Arrangement (Section 4)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: const [
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.blue, child: Icon(Icons.map, color: Colors.white)),
                title: Text('Map Navigation'),
                subtitle: Text('Section 4 ListView Example'),
              ),
              Divider(height: 1),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.photo_album, color: Colors.white)),
                title: Text('Photo Album'),
                subtitle: Text('Linear list item'),
              ),
              Divider(height: 1),
              ListTile(
                leading: CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.phone, color: Colors.white)),
                title: Text('Phone Contacts'),
                subtitle: Text('Communication item'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContainersTab extends StatelessWidget {
  const _ContainersTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Decorated Container (Border, Radius & Shadow)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 240,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.amber.shade200,
              border: Border.all(color: Colors.redAccent, width: 3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'Decorated Container\n(Section 6 Example)',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Matrix4 Transformation (Rotation)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 160,
            height: 80,
            transform: Matrix4.rotationZ(0.08),
            decoration: BoxDecoration(
              color: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Rotated Matrix4',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Alignment & Margins',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          height: 100,
          color: Colors.purple.shade50,
          alignment: Alignment.bottomRight,
          child: Text(
            'Bottom Right Aligned Child',
            style: TextStyle(color: Colors.purple.shade800, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}