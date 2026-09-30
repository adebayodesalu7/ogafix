import 'package:flutter/material.dart';

import '../chat/chats_list_screen.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // As requested, service bookings/chats page is the realtime ChatsListScreen inbox
    return const ChatsListScreen();
  }
}
