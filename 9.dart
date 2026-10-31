import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyA_APKI_API_KEY_YAHAN_AAYEGI',
      appId: '1:123456789:android:abcdef123456',
      messagingSenderId: '123456789012',
      projectId: 'apka-project-id',
    ),
  );
  runApp(const MaterialApp(
    home: StudentListRealtime(),
    debugShowCheckedModeBanner: false,
  ));
}

class StudentListRealtime extends StatelessWidget {
  const StudentListRealtime({super.key});

  Future<void> _addStudentRecord(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('students').add({
        'name': 'Rishabh Yadav',
        'roll_number': '243026239',
        'course': 'BCA',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student record added successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add record: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Student Records'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addStudentRecord(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Student'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading records: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No student records found.\nClick "+ Add Student" below to insert.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final studentDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 80),
            itemCount: studentDocs.length,
            itemBuilder: (context, index) {
              final student = studentDocs[index].data() as Map<String, dynamic>;
              final String name = student['name'] ?? 'Unknown';
              final String roll = student['roll_number'] ?? 'N/A';
              final String course = student['course'] ?? 'N/A';

              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text('Roll No: $roll | Course: $course'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}