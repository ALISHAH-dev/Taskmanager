import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: softBeige,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1A1A2E),
      ),
      themeMode: ThemeMode.system,
      home: AddNoteScreen(),
    );
  }
}

final Color softLavender = Color(0xFFE6E6FA);
final Color dustyPink = Color(0xFFD8BFD8);
final Color softBeige = Color(0xFFF5F5DC);
final Color mint = Color(0xFF98FF98);
final Color warmGrey = Color(0xFFD3D3D3);

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  Color _selectedColor = softLavender;
  bool _isLocked = false;
  bool _isPinned = false;
  List<String> _tags = [];
  bool _isSaveVisible = false;
  String? _lastSaved;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_updateSaveButton);
    _bodyController.addListener(_updateSaveButton);
  }

  void _updateSaveButton() {
    setState(() {
      _isSaveVisible =
          _titleController.text.isNotEmpty || _bodyController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/paper_texture.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: Column(
          children: [
            AppBar(
              title: Text('New Note')
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                AnimatedOpacity(
                  opacity: _isSaveVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: _isSaveVisible ? _saveNote : null,
                  ),
                ),
              ],
            ).animate().slideY(begin: -1.0, duration: 800.ms),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title your thoughts...',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: _selectedColor),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                    BorderSide(color: _selectedColor.withOpacity(0.5)),
                  ),
                ),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                cursorColor: _selectedColor,
              ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Start writing...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[800]!.withOpacity(0.8)
                        : Colors.white.withOpacity(0.95),
                  ),
                  style: TextStyle(fontSize: 16),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: _showColorPicker,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _selectedColor,
                        boxShadow: [
                          BoxShadow(
                            color: _selectedColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(_isLocked ? Icons.lock : Icons.lock_open),
                    color: _isLocked
                        ? Colors.red
                        : Theme.of(context).iconTheme.color,
                    onPressed: () {
                      setState(() => _isLocked = !_isLocked);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                        _isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                    color: _isPinned
                        ? Colors.blue
                        : Theme.of(context).iconTheme.color,
                    onPressed: () {
                      setState(() => _isPinned = !_isPinned);
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 8,
                        children: [
                          ..._tags.map(
                                (tag) => Chip(
                              label: Text(tag),
                              onDeleted: () {
                                setState(() => _tags.remove(tag));
                              },
                            ),
                          ),
                          ActionChip(
                            label: Text('Add Tag'),
                            onPressed: _addTag,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _lastSaved ?? 'Not saved yet',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${_bodyController.text.length} characters',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() => _selectedColor = color);
              },
              paletteType: PaletteType.hueWheel,
              enableAlpha: false,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Done'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _addTag() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Tag'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter tag (e.g., Idea, Meeting)'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() => _tags.add(controller.text));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _saveNote() {
    setState(() {
      _lastSaved = 'Saved just now...';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Lottie.asset('assets/check.json', width: 50, height: 50),
            SizedBox(width: 10),
            Text('Note saved!'),
          ],
        ),
        backgroundColor: _selectedColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
