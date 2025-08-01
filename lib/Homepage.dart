import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmanager/ADD%20Note.dart';
import 'package:taskmanager/ADD%20reminder.dart';
import 'package:taskmanager/ADD%20task.dart';
import 'package:taskmanager/Favorite%20task.dart';
import 'package:taskmanager/Lockscreen.dart';
import 'package:taskmanager/Signup.dart';


void main() {
  runApp(TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Poppins',
      ),
      home: TaskManagerHomepage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TaskManagerHomepage extends StatefulWidget {
  @override
  _TaskManagerHomepageState createState() => _TaskManagerHomepageState();
}

class _TaskManagerHomepageState extends State<TaskManagerHomepage>
    with TickerProviderStateMixin {
  bool isDarkMode = false;
  String selectedCategory = 'All';
  int completedTasks = 7;
  int totalTasks = 12;
  late AnimationController _fabController;
  late AnimationController _confettiController;
  bool showSpeedDial = false;

  final List<String> categories = ['All', 'Work', 'Study', 'Fitness', 'Groceries'];
  final List<Task> tasks = [
    Task('Complete Flutter project', 'Work', '2:00 PM', false, true),
    Task('Review design mockups', 'Work', '3:30 PM', true, false),
    Task('Grocery shopping', 'Groceries', '5:00 PM', false, false),
    Task('Workout session', 'Fitness', '6:30 PM', false, true),
    Task('Read chapter 5', 'Study', '8:00 PM', false, false),
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning, Fatima ☀️';
    if (hour < 17) return 'Good Afternoon, Fatima 🌤️';
    return 'Good Evening, Fatima 🌙';
  }

  Color get primaryColor => isDarkMode ? Color(0xFF1A1A2E) : Color(0xFFF8F9FA);
  Color get surfaceColor => isDarkMode ? Color(0xFF16213E) : Colors.white;
  Color get textColor => isDarkMode ? Colors.white : Color(0xFF2D3748);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      drawer: _buildAnimatedDrawer(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: CustomScrollView(
          slivers: [
            _buildGlassmorphismAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFeaturedTask(),
                    SizedBox(height: 24),
                    _buildCategoryChips(),
                    SizedBox(height: 24),
                    _buildTodaysTasksSection(),
                    SizedBox(height: 24),
                    _buildProductivityMeter(),
                    SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildSpeedDialFAB(),
    );
  }

  Widget _buildGlassmorphismAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE6E6FA).withOpacity(0.8),
              Color(0xFFFFC0CB).withOpacity(0.6),
              Color(0xFFAFEEEE).withOpacity(0.7),
            ],
          ),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              getGreeting(),
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: textColor,
                ),
                onPressed: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Color(0xFFFFC0CB).withOpacity(0.8),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE6E6FA).withOpacity(0.9),
                    Color(0xFFAFEEEE).withOpacity(0.8),
                  ],
                ),
              ),
              accountName: Text(
                'Fatima Ali',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF2D3748),
                ),
              ),
              accountEmail: Text(
                'fatima@example.com',
                style: TextStyle(color: Color(0xFF4A5568)),
              ),

            ),

            _buildDrawerItem(Icons.favorite, 'Favorites', () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return FavoritesScreen();
              }));
            }),
            _buildDrawerItem(Icons.lock, 'Locked Tasks', () {
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return LockScreen();
              }));
            }),

        Divider(thickness: 1, color: Colors.grey.shade300),
        _buildDrawerItem(Icons.logout, 'Logout', () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text('Confirm Logout'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Logout'),
                  onPressed: () async {
                    // SharedPreferences prefs = await SharedPreferences.getInstance();
                    // await prefs.clear(); // Optional: clear user data
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SignupScreen();
                    }));
                  },
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 16),
      ])
    ),
    );
  }


  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Color(0xFF6B46C1), size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D3748),
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildFeaturedTask() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6B46C1),
            Color(0xFF9333EA),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6B46C1).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Priority Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Spacer(),
              Icon(Icons.star, color: Colors.amber, size: 24),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Complete Flutter project presentation',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white70, size: 16),
              SizedBox(width: 4),
              Text(
                '2:00 PM',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Work',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;

              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: AnimatedScale(
                    scale: isSelected ? 1.05 : 1.0,
                    duration: Duration(milliseconds: 150),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                          colors: [Color(0xFFE6E6FA), Color(0xFFFFC0CB)],
                        )
                            : null,
                        color: isSelected ? null : surfaceColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Color(0xFFE6E6FA).withOpacity(0.5),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ]
                            : null,
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: isSelected ? Color(0xFF6B46C1) : textColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysTasksSection() {
    final filteredTasks = selectedCategory == 'All'
        ? tasks
        : tasks.where((task) => task.category == selectedCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              '${filteredTasks.where((t) => t.isCompleted).length}/${filteredTasks.length}',
              style: TextStyle(
                color: Color(0xFF6B46C1),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return _buildTaskCard(task, index);
          },
        ),
      ],
    );
  }

  Widget _buildTaskCard(Task task, int index) {
    return Dismissible(
      key: Key(task.title),
      background: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFF10B981),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerLeft,
        child: Icon(Icons.check, color: Colors.white, size: 24),
      ),
      secondaryBackground: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Mark as complete
          setState(() {
            task.isCompleted = true;
          });
          _showCompletionAnimation();
        } else {
          // Delete task
          _showDeleteConfirmation(task);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  task.isCompleted = !task.isCompleted;
                });
                if (task.isCompleted) {
                  _showCompletionAnimation();
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: task.isCompleted ? Color(0xFF10B981) : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted ? Color(0xFF10B981) : Color(0xFFCBD5E0),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: task.isCompleted
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: task.isCompleted
                          ? textColor.withOpacity(0.5)
                          : textColor,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(task.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getCategoryColor(task.category),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.access_time, size: 14, color: Color(0xFF9CA3AF)),
                      SizedBox(width: 4),
                      Text(
                        task.time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  task.isFavorite = !task.isFavorite;
                });
              },
              child: AnimatedScale(
                scale: task.isFavorite ? 1.2 : 1.0,
                duration: Duration(milliseconds: 150),
                child: Icon(
                  task.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: task.isFavorite ? Color(0xFFEF4444) : Color(0xFF9CA3AF),
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductivityMeter() {
    double progress = totalTasks > 0 ? completedTasks / totalTasks : 0;

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Productivity Meter',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B46C1),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                LinearGradient(
                  colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                ).colors.first,
              ),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 12),
          Text(
            '$completedTasks of $totalTasks tasks completed',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedDialFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSpeedDial) ...[
          _buildSpeedDialOption(Icons.note_add, 'Add Note', () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddNoteScreen();
            }));
          }),
          SizedBox(height: 16),
          _buildSpeedDialOption(Icons.notification_add, 'Add Reminder', () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddReminderScreen();
            }));
          }),
          SizedBox(height: 16),
          _buildSpeedDialOption(Icons.task_alt, 'Add Task', () {
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return AddTaskScreen();
            }));
          }),
          SizedBox(height: 16),
        ],
        FloatingActionButton(
          onPressed: () {
            setState(() {
              showSpeedDial = !showSpeedDial;
            });
            if (showSpeedDial) {
              _fabController.forward();
            } else {
              _fabController.reverse();
            }
          },
          child: AnimatedRotation(
            turns: showSpeedDial ? 0.125 : 0,
            duration: Duration(milliseconds: 200),
            child: Icon(Icons.add),
          ),
          backgroundColor: Color(0xFF6B46C1),
          elevation: 8,
        ),
      ],
    );
  }

  Widget _buildSpeedDialOption(IconData icon, String label, VoidCallback onTap) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 16),
        FloatingActionButton(
          mini: true,
          onPressed: onTap,
          child: Icon(icon),
          backgroundColor: Color(0xFFE6E6FA),
          foregroundColor: Color(0xFF6B46C1),
          elevation: 4,
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Color(0xFF6B46C1);
      case 'Study':
        return Color(0xFF3B82F6);
      case 'Fitness':
        return Color(0xFF10B981);
      case 'Groceries':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    // Add refresh logic here
  }

  void _showCompletionAnimation() {
    _confettiController.forward().then((_) {
      _confettiController.reset();
    });
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                setState(() {
                  tasks.remove(task);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Task {
  String title;
  String category;
  String time;
  bool isCompleted;
  bool isFavorite;

  Task(this.title, this.category, this.time, this.isCompleted, this.isFavorite);
}