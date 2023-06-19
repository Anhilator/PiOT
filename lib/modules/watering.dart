import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'home_page.dart';
import 'package:timezone/timezone.dart';
import 'package:location/location.dart' as loc;

class WateringPage extends StatefulWidget {
  final Plant plant;

  WateringPage({required this.plant});

  @override
  _WateringPageState createState() => _WateringPageState();
}

class _WateringPageState extends State<WateringPage> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedInterval = 1;
  bool _isHourly = true;
  bool _isDaily = true;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    final int intervalInMinutes = _isHourly ? _selectedInterval * 60 : 24 * 60;
    final DateTime now = DateTime.now();
    final Location romeLocation = getLocation('Europe/Rome');


    final TZDateTime scheduledDateTime = TZDateTime(
      romeLocation,
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    ).add(Duration(minutes: intervalInMinutes));



    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
    );
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Watering Reminder',
      'It\'s time to water ${widget.plant.name}!',
      scheduledDateTime,
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Reminder Set'),
        content: Text(
          'A reminder has been set to water ${widget.plant.name} '
              '${_isHourly ? 'every $_selectedInterval hour(s)' : 'at ${_formatTime(_selectedTime)}'}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay timeOfDay) {
    final formattedTime =
    DateFormat.Hm().format(DateTime(2021, 1, 1, timeOfDay.hour, timeOfDay.minute));
    return formattedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watering Reminder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set Reminder for ${widget.plant.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Time:'),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (selectedTime != null) {
                      setState(() {
                        _selectedTime = selectedTime;
                      });
                    }
                  },
                  child: Text(_formatTime(_selectedTime)),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Interval:'),
                SizedBox(width: 8),
                DropdownButton<int>(
                  value: _selectedInterval,
                  onChanged: (value) {
                    setState(() {
                      _selectedInterval = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem<int>(value: 1, child: Text('1 hour')),
                    DropdownMenuItem<int>(value: 2, child: Text('2 hours')),
                    DropdownMenuItem<int>(value: 3, child: Text('3 hours')),
                    // Add more options as needed
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Repeat:'),
                SizedBox(width: 8),
                Checkbox(
                  value: _isHourly,
                  onChanged: (value) {
                    setState(() {
                      _isHourly = value!;
                    });
                  },
                ),
                Text('Hourly'),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _scheduleNotification,
              child: Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }
}