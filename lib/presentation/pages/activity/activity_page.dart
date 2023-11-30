import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../cubit/auth/cubit/auth_cubit.dart';

import '../../../core/constant/constants.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  @override
  void initState() {
    super.initState();
    // context.read<AuthCubit>().loggedOut();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      "Activity",
      style: TextStyle(
        color: primaryColor,
      ),
    ));
  }
}
