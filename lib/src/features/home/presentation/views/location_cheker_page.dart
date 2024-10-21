import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_track/src/features/home/cubit/location_cubit.dart';

class LocationChekerPage extends StatelessWidget {
  const LocationChekerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locationCubit = context.read<LocationCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Checker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<LocationCubit, LocationState>(
              builder: (context, state) {
                if (state is LocationInitial) {
                  return Text(state.message);
                } else if (state is LocationLoading) {
                  return const CircularProgressIndicator();
                } else if (state is LocationSuccess) {
                  return Text(state.message);
                } else if (state is LocationFailure) {
                  return Text('Error: ${state.message}');
                } else if (state is LocationCheckSuccess) {
                  return Text(state.message);
                } else {
                  return const Text("خطأ غير معروف");
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: locationCubit.saveLocation,
              child: const Text("حفظ الموقع الحالي"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: locationCubit.loadSavedLocation,
              child: const Text("تحميل الموقع الحالي"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: locationCubit.checkLocation,
              child: const Text("تحقق من الموقع"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: locationCubit.clearLocation,
              child: const Text("حذف الموقع الحالي"),
            ),
          ],
        ),
      ),
    );
  }
}
