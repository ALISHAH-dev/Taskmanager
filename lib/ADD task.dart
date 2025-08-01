import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';

// Task Model
class Task {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime? date;
  final TimeOfDay? time;
  final String priority;
  final bool isFavorite;
  final bool isLocked;
  final Color themeColor;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.date,
    this.time,
    required this.priority,
    required this.isFavorite,
    required this.isLocked,
    required this.themeColor,
    required this.createdAt,
  });
}

// Global task list (in a real app, use state management like Provider/Riverpod)
class TaskManager {
  static List<Task> tasks = [];

  static void addTask(Task task) {
    tasks.insert(0, task);
  }
}

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedCategory = 'Work';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _priority = 'Medium';
  bool _isFavorite = false;
  bool _isLocked = false;
  bool _isDarkMode = false;
  Color _selectedColor = Colors.purple;

  // Error states
  String? _titleError;
  String? _descriptionError;

  late AnimationController _buttonController;
  late AnimationController _saveController;
  late AnimationController _colorController;
  late ConfettiController _confettiController;

  final List<String> _categories = ['Work', 'Study', 'Personal', 'Urgent'];
  final Map<String, Color> _priorityColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.red,
  };

  final List<Color> _themeColors = [
    Colors.purple,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.indigo,
    Colors.cyan,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _saveController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _colorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _buttonController.dispose();
    _saveController.dispose();
    _colorController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _createTask() async {
    // Clear previous errors
    setState(() {
      _titleError = null;
      _descriptionError = null;
    });

    // Validate manually for better error display
    bool hasError = false;

    if (_titleController.text.isEmpty) {
      setState(() {
        _titleError = 'Please enter a task title';
      });
      hasError = true;
    }

    if (hasError) return;

    _buttonController.forward().then((_) {
      _buttonController.reverse();
    });

    // Create new task
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      date: _selectedDate,
      time: _selectedTime,
      priority: _priority,
      isFavorite: _isFavorite,
      isLocked: _isLocked,
      themeColor: _selectedColor,
      createdAt: DateTime.now(),
    );

    // Add to task manager
    TaskManager.addTask(task);

    // Simulate task creation delay
    await Future.delayed(const Duration(milliseconds: 500));

    _confettiController.play();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Task created successfully! 🎉'),
          ],
        ),
        backgroundColor: _selectedColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Navigate back after showing success
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context, task);
    });
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _selectedColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _selectedColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? _darkTheme : _lightTheme;

    return Theme(
      data: theme,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: _isDarkMode
                    ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                )
                    : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE8E8FF), Color(0xFFF5F5FF)],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitleField(),
                            const SizedBox(height: 20),
                            _buildDescriptionField(),
                            const SizedBox(height: 20),
                            _buildColorSelector(),
                            const SizedBox(height: 25),
                            _buildCategorySelector(),
                            const SizedBox(height: 25),
                            _buildDateTimeSection(),
                            const SizedBox(height: 25),
                            _buildPrioritySelector(),
                            const SizedBox(height: 25),
                            _buildFavoriteSection(),
                            const SizedBox(height: 20),
                            //_buildLockSection(),
                            const SizedBox(height: 40),
                            _buildCreateButton(),
                          ].animate(interval: 80.ms).slideY(
                            begin: 0.2,
                            duration: 600.ms,
                            curve: Curves.easeOutCubic,
                          ).fadeIn(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.5,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -3.14 / 2,
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.05,
                shouldLoop: false,
                colors: _themeColors,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: _isDarkMode
            ? LinearGradient(
          colors: [
            Colors.purple[800]!.withOpacity(0.3),
            Colors.purple[600]!.withOpacity(0.3),
          ],
        )
            : LinearGradient(
          colors: [
            Colors.white.withOpacity(0.95),
            Colors.purple[50]!.withOpacity(0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: _isDarkMode ? Colors.white : Colors.purple[700],
            ),
          ),
          const Spacer(),
          Text(
            'Add New Task',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _isDarkMode ? Colors.white : Colors.purple[700],
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isDarkMode = !_isDarkMode;
                  });
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    key: ValueKey(_isDarkMode),
                    color: _isDarkMode ? Colors.white : Colors.purple[700],
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _saveController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_saveController.value * 0.1),
                    child: IconButton(
                      onPressed: _createTask,
                      icon: Icon(
                        Icons.check,
                        color: _isDarkMode ? Colors.white : Colors.purple[700],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(begin: -1, duration: 800.ms, curve: Curves.easeOutCubic);
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _isDarkMode
                ? Colors.grey[800]!.withOpacity(0.8)
                : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _selectedColor.withOpacity(_isDarkMode ? 0.2 : 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: _selectedColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: _titleController,
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              labelText: 'Task Title',
              hintText: 'Enter task title',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              labelStyle: TextStyle(
                color: _selectedColor,
                fontFamily: 'Poppins',
              ),
              hintStyle: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[500],
                fontFamily: 'Poppins',
              ),
              prefixIcon: Icon(
                Icons.edit,
                color: _selectedColor,
              ),
              errorStyle: const TextStyle(height: 0),
            ),
            onChanged: (value) {
              if (_titleError != null) {
                setState(() {
                  _titleError = null;
                });
              }
            },
          ),
        ),
        if (_titleError != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              _titleError!,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ).animate().slideY(begin: -0.5).fadeIn(),
          ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _isDarkMode
                ? Colors.grey[800]!.withOpacity(0.8)
                : Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _selectedColor.withOpacity(_isDarkMode ? 0.2 : 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: _selectedColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            style: TextStyle(
              fontSize: 16,
              color: _isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe the task...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
              alignLabelWithHint: true,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              labelStyle: TextStyle(
                color: _selectedColor,
                fontFamily: 'Poppins',
              ),
              hintStyle: TextStyle(
                color: _isDarkMode ? Colors.grey[400] : Colors.grey[500],
                fontFamily: 'Poppins',
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Icon(
                  Icons.description,
                  color: _selectedColor,
                ),
              ),
              errorStyle: const TextStyle(height: 0),
            ),
            onChanged: (value) {
              if (_descriptionError != null) {
                setState(() {
                  _descriptionError = null;
                });
              }
            },
          ),
        ),
        if (_descriptionError != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Text(
              _descriptionError!,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ).animate().slideY(begin: -0.5).fadeIn(),
          ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Theme Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _themeColors.length,
            itemBuilder: (context, index) {
              final color = _themeColors[index];
              final isSelected = _selectedColor == color;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                    _colorController.forward().then((_) {
                      _colorController.reverse();
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                    width: isSelected ? 50 : 40,
                    height: isSelected ? 50 : 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ]
                          : [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 20,
                    )
                        : null,
                  ).animate(delay: Duration(milliseconds: index * 50))
                      .scale(begin: Offset(0.8, 0.8))
                      .fadeIn(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final isSelected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        colors: [_selectedColor, _selectedColor.withOpacity(0.8)],
                      )
                          : null,
                      color: isSelected
                          ? null
                          : (_isDarkMode ? Colors.grey[800] : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: _selectedColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : (_isDarkMode ? Colors.white : Colors.black87),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Schedule',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCard(
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_today,
                    color: _selectedColor,
                  ),
                  title: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                        : 'Select Date',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  onTap: _selectDate,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildCard(
                child: ListTile(
                  leading: Icon(
                    Icons.access_time,
                    color: _selectedColor,
                  ),
                  title: Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'Select Time',
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.black87,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  onTap: _selectTime,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _isDarkMode ? Colors.white : Colors.black87,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: ['Low', 'Medium', 'High'].map((priority) {
            final isSelected = _priority == priority;
            final color = _priorityColors[priority]!;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _priority = priority;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? color : (_isDarkMode ? Colors.grey[800] : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          priority,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (_isDarkMode ? Colors.white : Colors.black87),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFavoriteSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey[800]!.withOpacity(0.8)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: _isFavorite ? Colors.red.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ListTile(
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : (_isDarkMode ? Colors.grey[400] : Colors.grey[600]),
              size: 28,
            ),
          ),
          title: Text(
            'Add to Favorites',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black87,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            'Mark as favorite for quick access',
            style: TextStyle(
              color: _isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
          ),
          trailing: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Switch(
              value: _isLocked,
              onChanged: (value) {
                setState(() {
                  _isLocked = value;
                });
              },
              activeColor: _selectedColor,
              activeTrackColor: _selectedColor.withOpacity(0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return AnimatedBuilder(
      animation: _buttonController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (_buttonController.value * 0.05),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_selectedColor, _selectedColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _selectedColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _createTask,
                child: const Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_task,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Create Task',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).animate(delay: 400.ms).slideY(begin: 0.3).fadeIn();
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: _isDarkMode
            ? Colors.grey[800]!.withOpacity(0.8)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDarkMode ? 0.3 : 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  ThemeData get _lightTheme => ThemeData(
    primarySwatch: Colors.purple,
    scaffoldBackgroundColor: Colors.transparent,
    fontFamily: 'Poppins',
  );

  ThemeData get _darkTheme => ThemeData.dark().copyWith(
    primaryColor: Colors.purple,
    scaffoldBackgroundColor: Colors.transparent,

  );
}