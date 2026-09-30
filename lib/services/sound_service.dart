import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playNotificationSound() async {
    try {
      // Play a standard notification beep URL or asset
      await _player.play(
        UrlSource(
          'https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3',
        ),
      );
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }
  }
}
