import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Config',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GameConfigScreen(),
    );
  }
}

class GameConfigScreen extends StatefulWidget {
  const GameConfigScreen({super.key});

  @override
  State<GameConfigScreen> createState() => _GameConfigScreenState();
}

class _GameConfigScreenState extends State<GameConfigScreen> {
  bool _isSoundOn = true;
  int _highestScore = 3500;
  bool _isAutoSave = true;
  double _volume = 0.2;

  final TextEditingController _scoreController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSoundOn = prefs.getBool('isSoundOn') ?? true;
      _highestScore = prefs.getInt('highestScore') ?? 3500;
      _isAutoSave = prefs.getBool('isAutoSave') ?? true;
      _volume = prefs.getDouble('volume') ?? 0.2;
      _scoreController.text = _highestScore.toString();
    });
  }

  Future<void> _saveConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSoundOn', _isSoundOn);
    await prefs.setInt('highestScore', _highestScore);
    await prefs.setBool('isAutoSave', _isAutoSave);
    await prefs.setDouble('volume', _volume);
  }

  @override
  void dispose() {
    _scoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Cấu hình game đố vui',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildToggleRow('Âm thanh', _isSoundOn, (value) {
                setState(() {
                  _isSoundOn = value!;
                  _saveConfig();
                });
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Điểm cao nhất',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _scoreController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontSize: 18),
                      onChanged: (value) {
                        setState(() {
                          _highestScore = int.tryParse(value) ?? _highestScore;
                          _saveConfig();
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildToggleRow('Tự động lưu game', _isAutoSave, (value) {
                setState(() {
                  _isAutoSave = value!;
                  _saveConfig();
                });
              }),
              const SizedBox(height: 20),
              const Text(
                'Volume',
                style: TextStyle(fontSize: 18),
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: _volume,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                  onChangeEnd: (value) {
                    _saveConfig();
                  },
                  activeColor: Colors.black,
                  inactiveColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
          side: const BorderSide(color: Colors.black, width: 1),
        ),
        const Text(
          'Bật',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}