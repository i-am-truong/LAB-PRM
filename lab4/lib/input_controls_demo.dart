import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

enum PaymentMethod { cash, card, momo }

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _volume = 30;
  bool _notifications = true;
  PaymentMethod _method = PaymentMethod.cash;
  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year),
      lastDate: DateTime(now.year + 5),
      initialDate: _selectedDate ?? now,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String _dateText() {
    final d = _selectedDate;
    if (d == null) return 'No date selected';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 2 - Input Widgets')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Interactive Controls',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text('Volume: ${_volume.toStringAsFixed(0)}'),
            Slider(
              value: _volume,
              min: 0,
              max: 100,
              divisions: 100,
              label: _volume.toStringAsFixed(0),
              onChanged: (v) => setState(() {
                _volume = v;
              }),
            ),
            const SizedBox(height: 12),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notifications'),
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
            const SizedBox(height: 12),

            const Text('Payment method:'),
            RadioListTile<PaymentMethod>(
              title: const Text('Cash'),
              value: PaymentMethod.cash,
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v!),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('Card'),
              value: PaymentMethod.card,
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v!),
            ),
            RadioListTile<PaymentMethod>(
              title: const Text('Mono'),
              value: PaymentMethod.momo,
              groupValue: _method,
              onChanged: (v) => setState(() => _method = v!),
            ),
            const SizedBox(height: 12),

            ElevatedButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.date_range),
              label: const Text('Pick a date'),
            ),
            const SizedBox(height: 8),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Current values:\n'
                  '- Volume: ${_volume.toStringAsFixed(0)}\n'
                  '- Notifications: $_notifications\n'
                  '- Method: $_method\n'
                  '- Date: ${_dateText()}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
