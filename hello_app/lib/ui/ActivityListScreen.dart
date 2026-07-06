import 'package:flutter/material.dart';
import 'package:hello_app/models/Activity.dart';
import 'package:hello_app/services/ActivityDBHelper.dart';

class ActivityListScreen extends StatelessWidget {
  const ActivityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Activities'),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.blueGrey.shade50, shape: BoxShape.circle),
                        child: const Icon(Icons.list_alt, size: 28, color: Colors.blueGrey),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text('Activities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Browse and manage activities', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  // Stream content
                  Expanded(
                    child: StreamBuilder<List<Activity>>(
                      stream: ActivityDBHelper.getActivitiesStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('Data not found'));
                        }

                        final actlist = snapshot.data!;

                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount: actlist.length,
                          itemBuilder: (context, index) {
                            final actItem = actlist[index];

                            return Dismissible(
                              key: ValueKey(actItem.id),
                              background: Container(
                                color: Colors.redAccent,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                final should = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete activity?'),
                                    content: const Text('This action cannot be undone.'),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                                    ],
                                  ),
                                );
                                return should == true;
                              },
                              onDismissed: (direction) async {
                                await ActivityDBHelper.deleteActivity(actItem.id);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Activity deleted')));
                                }
                              },
                              child: Card(
                                elevation: 1,
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                child: ListTile(
                                  title: Text(
                                    actItem.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    actItem.desc,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Share',
                                        icon: const Icon(Icons.share, size: 18, color: Colors.blueGrey),
                                        onPressed: () {
                                          // TODO: implement share action using `share_plus`
                                        },
                                      ),
                                      const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                                    ],
                                  ),
                                  onTap: () {
                                    // TODO: navigate to activity detail screen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Placeholder()),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
