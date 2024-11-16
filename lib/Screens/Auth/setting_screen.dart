import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:video_conference_app1/Models/user_provider.dart';
import 'package:video_conference_app1/Widgets/appbar.dart';
import 'package:video_conference_app1/Widgets/auth_widgets.dart';
import 'package:video_conference_app1/constants/const_widgets.dart';
import 'package:video_conference_app1/services/auth_services.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    ref
        .read(userDataNotifierProvider.notifier)
        .fetchCurrentUserData(_authService.user?.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar("Settings"),
      body: _body(),
    );
  }

  Widget _body() {
    final userData = ref.watch(userDataNotifierProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _customListtile(
            iconOrImage: userImageCircle(userData, 30),
            title: userData.name!.isEmpty
                ? "Your Account"
                : userData.name ?? "Your Account",
            onTap: () {
              Navigator.of(context).pushNamed("/userProfile");
            },
          ),
          const SizedBox(
            height: 10,
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          _customListtile(
            iconOrImage: const Icon(Icons.notifications),
            title: "Notifications",
            onTap: () {},
            subTitle: "Messages, Group and Others",
          ),
          const SizedBox(
            height: 10,
          ),
          _customListtile(
            iconOrImage: const Icon(Icons.help),
            title: "Help",
            subTitle: "Help Center, Contact Us, Privacy Policy",
            onTap: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          _customListtile(
            iconOrImage: const Icon(Icons.group),
            title: "Invite a friend",
            onTap: () {},
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
          _customListtile(
            iconOrImage: const Icon(Icons.logout_outlined),
            title: "Logout",
            onTap: () {
              _authService.logoutDilog(context, ref);
            },
          ),
        ],
      ),
    );
  }

  Widget _customListtile({
    required Widget iconOrImage,
    required String title,
    String? subTitle = "",
    required void Function() onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        foregroundColor: primaryColor,
        backgroundColor: Colors.grey.shade300,
        child: iconOrImage,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
      subtitle: (subTitle!.isNotEmpty)
          ? Text(
              subTitle,
              style: const TextStyle(
                color: Colors.grey,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
