import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  String selectedFilter = 'All';
  String selectedSort = 'Due Date';
  TextEditingController searchController = TextEditingController();

  List<FavoriteTask> favoriteTasks = [
    FavoriteTask(
      id: '1',
      title: 'Complete project presentation',
      description: 'Prepare slides and practice presentation for client meeting',
      priority: Priority.high,
      dueDate: DateTime.now().add(Duration(days: 1)),
      category: 'Work',
      progress: 0.8,
      isCompleted: false,
    ),
    FavoriteTask(
      id: '2',
      title: 'Review quarterly reports',
      description: 'Analyze Q3 performance metrics and prepare summary',
      priority: Priority.medium,
      dueDate: DateTime.now().add(Duration(days: 3)),
      category: 'Analysis',
      progress: 0.6,
      isCompleted: false,
    ),
    FavoriteTask(
      id: '3',
      title: 'Team building event planning',
      description: 'Organize team outing and book venue for next month',
      priority: Priority.low,
      dueDate: DateTime.now().add(Duration(days: 7)),
      category: 'HR',
      progress: 0.3,
      isCompleted: false,
    ),
    FavoriteTask(
      id: '4',
      title: 'Update security protocols',
      description: 'Review and update company security guidelines',
      priority: Priority.high,
      dueDate: DateTime.now().subtract(Duration(days: 1)),
      category: 'Security',
      progress: 0.9,
      isCompleted: false,
    ),
  ];

  List<FavoriteTask> get filteredTasks {
    List<FavoriteTask> filtered = favoriteTasks;

    // Apply search filter
    if (searchController.text.isNotEmpty) {
      filtered = filtered.where((task) =>
      task.title.toLowerCase().contains(searchController.text.toLowerCase()) ||
          task.description.toLowerCase().contains(searchController.text.toLowerCase())
      ).toList();
    }

    // Apply category filter
    switch (selectedFilter) {
      case 'High Priority':
        filtered = filtered.where((task) => task.priority == Priority.high).toList();
        break;
      case 'Due Soon':
        filtered = filtered.where((task) =>
        task.dueDate.difference(DateTime.now()).inDays <= 2
        ).toList();
        break;
      case 'Overdue':
        filtered = filtered.where((task) =>
        task.dueDate.isBefore(DateTime.now()) && !task.isCompleted
        ).toList();
        break;
    }

    // Apply sorting
    switch (selectedSort) {
      case 'Due Date':
        filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'Priority':
        filtered.sort((a, b) => _getPriorityValue(b.priority).compareTo(_getPriorityValue(a.priority)));
        break;
      case 'Alphabetical':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Recently Added':
      // Assuming tasks are added in order, reverse the list
        filtered = filtered.reversed.toList();
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Favorites',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => setState(() => selectedSort = value),
            itemBuilder: (context) => [
              PopupMenuItem(value: 'Due Date', child: Text('Sort by Due Date')),
              PopupMenuItem(value: 'Priority', child: Text('Sort by Priority')),
              PopupMenuItem(value: 'Alphabetical', child: Text('Sort Alphabetically')),
              PopupMenuItem(value: 'Recently Added', child: Text('Recently Added')),
            ],
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.sort, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(),
          Expanded(
            child: filteredTasks.isEmpty
                ? _buildEmptyState()
                : _buildTasksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search favorite tasks...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                icon: Icon(Icons.clear, color: Colors.grey[500]),
                onPressed: () {
                  searchController.clear();
                  setState(() {});
                },
              )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue[600]!),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'High Priority', 'Due Soon', 'Overdue']
                  .map((filter) => _buildFilterChip(filter))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    bool isSelected = selectedFilter == filter;
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(filter),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedFilter = selected ? filter : 'All';
          });
        },
        backgroundColor: Colors.grey[100],
        selectedColor: Colors.blue[100],
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue[800] : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.blue[300]! : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(Duration(seconds: 1));
        setState(() {});
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return _buildTaskCard(filteredTasks[index]);
        },
      ),
    );
  }

  Widget _buildTaskCard(FavoriteTask task) {
    bool isOverdue = task.dueDate.isBefore(DateTime.now()) && !task.isCompleted;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOverdue ? Colors.red[300]! : Colors.grey[200]!,
          width: isOverdue ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.horizontal,
        background: Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 20),
          child: Icon(Icons.check, color: Colors.white, size: 24),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(Icons.star_border, color: Colors.white, size: 24),
        ),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            // Mark as complete
            setState(() {
              task.isCompleted = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Task marked as complete')),
            );
          } else {
            // Remove from favorites
            setState(() {
              favoriteTasks.remove(task);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Removed from favorites')),
            );
          }
        },
        child: InkWell(
          onTap: () => _showTaskPreview(task),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          favoriteTasks.remove(task);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.star,
                          color: Colors.amber[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(task.priority).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getPriorityColor(task.priority).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(task.priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            _getPriorityText(task.priority),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(task.priority),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.category,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      _getRelativeDate(task.dueDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? Colors.red[600] : Colors.grey[600],
                        fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                if (task.progress > 0) ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: task.progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                          minHeight: 4,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${(task.progress * 100).round()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      onTap: () => _editTask(task),
                    ),
                    SizedBox(width: 12),
                    _buildActionButton(
                      icon: task.isCompleted ? Icons.undo : Icons.check,
                      label: task.isCompleted ? 'Undo' : 'Complete',
                      onTap: () => setState(() => task.isCompleted = !task.isCompleted),
                    ),
                    Spacer(),
                    _buildActionButton(
                      icon: Icons.more_horiz,
                      label: 'More',
                      onTap: () => _showMoreOptions(task),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.star_border,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            'No Favorite Tasks',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Star your important tasks to see them here',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to all tasks or create new task
              Navigator.pop(context);
            },
            icon: Icon(Icons.add),
            label: Text('Browse All Tasks'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  int _getPriorityValue(Priority priority) {
    switch (priority) {
      case Priority.high:
        return 3;
      case Priority.medium:
        return 2;
      case Priority.low:
        return 1;
    }
  }

  String _getRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference < 0) {
      return 'Overdue';
    } else if (difference == 0) {
      return 'Due Today';
    } else if (difference == 1) {
      return 'Due Tomorrow';
    } else if (difference <= 7) {
      return 'Due in $difference days';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }

  void _showTaskPreview(FavoriteTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.star,
                          color: Colors.amber[600],
                          size: 28,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      task.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    _buildDetailRow('Priority', _getPriorityText(task.priority), _getPriorityColor(task.priority)),
                    _buildDetailRow('Category', task.category, Colors.blue[600]!),
                    _buildDetailRow('Due Date', DateFormat('EEEE, MMM d, y').format(task.dueDate), Colors.grey[600]!),
                    SizedBox(height: 24),
                    if (task.progress > 0) ...[
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: task.progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                        minHeight: 8,
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${(task.progress * 100).round()}% Complete',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _editTask(task);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.grey[700],
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text('Edit Task'),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(task.isCompleted ? 'Mark Incomplete' : 'Mark Complete'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editTask(FavoriteTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: task.title),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: task.description),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions(FavoriteTask task) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Task'),
              onTap: () {
                Navigator.pop(context);
                _editTask(task);
              },
            ),
            ListTile(
              leading: Icon(Icons.copy),
              title: Text('Duplicate Task'),
              onTap: () {
                Navigator.pop(context);
                // Implement duplicate functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share Task'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.star_border, color: Colors.orange),
              title: Text('Remove from Favorites'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  favoriteTasks.remove(task);
                });
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete Task'),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(task);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(FavoriteTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                favoriteTasks.remove(task);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Task deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Data model for favorite tasks
class FavoriteTask {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final DateTime dueDate;
  final String category;
  final double progress;
  bool isCompleted;

  FavoriteTask({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    required this.category,
    required this.progress,
    this.isCompleted = false,
  });
}

enum Priority { high, medium, low }
