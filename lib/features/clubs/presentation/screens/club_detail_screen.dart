import 'package:flutter/material.dart';
import 'package:presunivgo/core/constants/app_colors.dart';

class ClubDetailScreen extends StatefulWidget {
  final String clubId;

  const ClubDetailScreen({super.key, required this.clubId});

  @override
  State<ClubDetailScreen> createState() => _ClubDetailScreenState();
}

class _ClubDetailScreenState extends State<ClubDetailScreen> {
  String _selectedChannel = '#general';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildChannelDrawer(),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('IT Club',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(_selectedChannel,
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.people_outline), onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildChannelMessages()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildChannelDrawer() {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildChannelCategory('TEXT CHANNELS'),
                _buildChannelTile('# announcements', Icons.campaign_outlined),
                _buildChannelTile('# general', Icons.tag),
                _buildChannelTile('# resources', Icons.description_outlined),
                const SizedBox(height: 16),
                _buildChannelCategory('VOICE CHANNELS'),
                _buildChannelTile('General Voice', Icons.volume_up_outlined),
                _buildChannelTile('Study Room', Icons.volume_up_outlined),
              ],
            ),
          ),
          _buildUserBar(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: AppColors.primary),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.groups, color: AppColors.primary),
      ),
      accountName:
          Text('IT Club', style: TextStyle(fontWeight: FontWeight.bold)),
      accountEmail: Text('Verified Community'),
    );
  }

  Widget _buildChannelCategory(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textHint,
            letterSpacing: 1),
      ),
    );
  }

  Widget _buildChannelTile(String name, IconData icon) {
    bool isSelected = _selectedChannel == name;
    return ListTile(
      leading: Icon(icon,
          size: 20,
          color: isSelected ? AppColors.primary : AppColors.textSecondary),
      title: Text(
        name,
        style: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() => _selectedChannel = name);
        Navigator.pop(context);
      },
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildUserBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.surface,
      child: const Row(
        children: [
          CircleAvatar(radius: 16, backgroundColor: AppColors.border),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('John Doe',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('#PU1234',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.mic, size: 20, color: AppColors.textHint),
          SizedBox(width: 12),
          Icon(Icons.headphones, size: 20, color: AppColors.textHint),
        ],
      ),
    );
  }

  Widget _buildChannelMessages() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      reverse: true,
      itemCount: 20,
      itemBuilder: (context, index) {
        return _buildMessageItem(index);
      },
    );
  }

  Widget _buildMessageItem(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(radius: 18, backgroundColor: AppColors.border),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Student Name',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(width: 8),
                    Text('12:4${index % 10} PM',
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textHint)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'This is a sample message in the club channel. We are discussing the upcoming hackathon!',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: () {}),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Message #general',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined,
                    color: AppColors.textHint),
                onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
