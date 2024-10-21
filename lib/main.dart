import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_track/src/features/home/cubit/location_cubit.dart';
import 'package:location_track/src/features/home/data/repo/location_repo_implementation.dart';
import 'package:location_track/src/features/home/presentation/views/location_cheker_page.dart';

void main() {
  runApp(const LocacationChekerApp());
}

class LocacationChekerApp extends StatelessWidget {
  const LocacationChekerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationCubit(LocationRepoImplementation()),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LocationChekerPage(),
      ),
    );
  }
}
