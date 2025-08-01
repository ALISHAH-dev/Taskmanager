import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({Key? key}) : super(key: key);

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen>
    with TickerProviderStateMixin {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _titleFocusNode = FocusNode();
  final _notesFocusNode = FocusNode();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _repeatOption = 'None';
  bool _notificationEnabled = true;
  bool _isDarkMode = false;
  bool _isPrivate = false;
  int _selectedColorIndex = 0;

  late AnimationController _saveButtonController;
  late AnimationController _bellController;
  late AnimationController _confettiController;
  late Animation<double> _saveButtonScale;
  late Animation<double> _bellShake;

  final List<Color> _accentColors = [
    Colors.blue.shade400,
    Colors.purple.shade400,
    Colors.green.shade400,
    Colors.orange.shade400,
    Colors.pink.shade400,
    Colors.teal.shade400,
    Colors.indigo.shade400,
    Colors.amber.shade400,
  ];

  final List<String> _repeatOptions = ['None', 'Daily', 'Weekly', 'Monthly', 'Custom'];

  @override
  void initState() {
    super.initState();
    _saveButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _bellController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _saveButtonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _saveButtonController, curve: Curves.easeInOut),
    );

    _bellShake = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bellController, curve: Curves.elasticOut),
    );

    _titleController.addListener(_updatePreview);
    _notesController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _titleFocusNode.dispose();
    _notesFocusNode.dispose();
    _saveButtonController.dispose();
    _bellController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {});
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _accentColors[_selectedColorIndex],
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _accentColors[_selectedColorIndex],
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveReminder() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a reminder title'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();
    _saveButtonController.forward().then((_) {
      _saveButtonController.reverse();
    });

    if (_notificationEnabled) {
      _bellController.forward().then((_) {
        _bellController.reset();
      });
    }

    _confettiController.forward();

    // Simulate save delay
    await Future.delayed(const Duration(milliseconds: 800));

    Navigator.pop(context, {
      'title': _titleController.text.trim(),
      'notes': _notesController.text.trim(),
      'date': _selectedDate,
      'time': _selectedTime,
      'repeat': _repeatOption,
      'notification': _notificationEnabled,
      'color': _accentColors[_selectedColorIndex],
      'isPrivate': _isPrivate,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = _isDarkMode || theme.brightness == Brightness.dark;

    return Theme(
      data: theme.copyWith(
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDark
            ? const Color(0xFF1A1A2E)
            : const Color(0xFFF8F9FF),
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF8F9FF),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: isDark ? Colors.white : Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Add Reminder',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.white : Colors.black87,
              ),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
            ),
            AnimatedBuilder(
              animation: _saveButtonScale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _saveButtonScale.value,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _accentColors[_selectedColorIndex],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColors[_selectedColorIndex].withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: _saveReminder,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              _buildInputCard(
                child: TextField(
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'e.g. Take medicine',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.title_rounded,
                      color: _accentColors[_selectedColorIndex],
                    ),
                    border: InputBorder.none,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: _accentColors[_selectedColorIndex],
                        width: 2,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: isDark ? Colors.white24 : Colors.black12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Notes Input
              _buildInputCard(
                child: TextField(
                  controller: _notesController,
                  focusNode: _notesFocusNode,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add details...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.notes_rounded,
                      color: _accentColors[_selectedColorIndex],
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Date and Time Row
              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.calendar_today_rounded,
                      title: 'Date',
                      subtitle: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      onTap: _selectDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.access_time_rounded,
                      title: 'Time',
                      subtitle: _selectedTime.format(context),
                      onTap: _selectTime,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Repeat Option
              _buildActionCard(
                icon: Icons.repeat_rounded,
                title: 'Repeat',
                subtitle: _repeatOption,
                trailing: DropdownButton<String>(
                  value: _repeatOption,
                  underline: const SizedBox(),
                  items: _repeatOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _repeatOption = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Notification Toggle
              _buildActionCard(
                icon: Icons.notifications_rounded,
                title: 'Notification',
                subtitle: _notificationEnabled ? 'Enabled' : 'Disabled',
                trailing: AnimatedBuilder(
                  animation: _bellShake,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _bellShake.value * 0.3,
                      child: Switch(
                        value: _notificationEnabled,
                        activeColor: _accentColors[_selectedColorIndex],
                        onChanged: (value) {
                          setState(() {
                            _notificationEnabled = value;
                          });
                          if (value) {
                            _bellController.forward().then((_) {
                              _bellController.reset();
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Privacy Toggle
              _buildActionCard(
                icon: Icons.lock_rounded,
                title: 'Private Reminder',
                subtitle: _isPrivate ? 'Protected' : 'Normal',
                trailing: Switch(
                  value: _isPrivate,
                  activeColor: _accentColors[_selectedColorIndex],
                  onChanged: (value) {
                    setState(() {
                      _isPrivate = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Color Picker
              Text(
                'Accent Color',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _accentColors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final color = entry.value;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedColorIndex = index;
                        });
                        HapticFeedback.selectionClick();
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _selectedColorIndex == index ? 32 : 24,
                        height: _selectedColorIndex == index ? 32 : 24,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: _selectedColorIndex == index
                              ? Border.all(
                            color: isDark ? Colors.white : Colors.black26,
                            width: 2,
                          )
                              : null,
                          boxShadow: _selectedColorIndex == index
                              ? [
                            BoxShadow(
                              color: color.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                              : null,
                        ),
                        child: _selectedColorIndex == index
                            ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              // Live Preview
              if (_titleController.text.isNotEmpty) ...[
                Text(
                  'Preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPreviewCard(),
                const SizedBox(height: 24),
              ],

              // Create Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: AnimatedBuilder(
                  animation: _confettiController,
                  builder: (context, child) {
                    return ElevatedButton(
                      onPressed: _saveReminder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColors[_selectedColorIndex],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: _accentColors[_selectedColorIndex].withOpacity(0.3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_confettiController.value > 0) ...[
                            Transform.scale(
                              scale: 1 + (_confettiController.value * 0.2),
                              child: const Icon(Icons.celebration_rounded),
                            ),
                            const SizedBox(width: 8),
                          ] else
                            const Icon(Icons.add_alert_rounded),
                          if (_confettiController.value == 0) const SizedBox(width: 8),
                          const Text(
                            'Set Reminder',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({required Widget child}) {
    final isDark = _isDarkMode || Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final isDark = _isDarkMode || Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _accentColors[_selectedColorIndex].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: _accentColors[_selectedColorIndex],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    final isDark = _isDarkMode || Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _accentColors[_selectedColorIndex].withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColors[_selectedColorIndex].withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _accentColors[_selectedColorIndex],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _titleController.text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    if (_isPrivate)
                      Icon(
                        Icons.lock_rounded,
                        size: 16,
                        color: _accentColors[_selectedColorIndex],
                      ),
                  ],
                ),
                if (_notesController.text.isNotEmpty)
                  Text(
                    _notesController.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 12,
                      color: _accentColors[_selectedColorIndex],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month} at ${_selectedTime.format(context)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _accentColors[_selectedColorIndex],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (_notificationEnabled) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.notifications_active_rounded,
                        size: 12,
                        color: _accentColors[_selectedColorIndex],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}