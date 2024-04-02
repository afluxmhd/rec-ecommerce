// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rec_ecommerce/core/design/components/app_snackbar.dart';
import 'package:rec_ecommerce/features/user/repository/user_repo.dart';
import 'package:rec_ecommerce/models/rec_configuration.dart';

final userControllerProvider = Provider((ref) {
  return UserController(ref: ref, userRepo: ref.watch(userRepositoryProvider));
});

class UserController extends StateNotifier<bool> {
  final Ref _ref;
  final UserRepo _userRepo;

  UserController({required Ref ref, required UserRepo userRepo})
      : _ref = ref,
        _userRepo = userRepo,
        super(false);

  saveRecConfiguration(BuildContext context, RecConfiguration config) {
    _userRepo.saveRecConfiguration(config.toString()).then((value) {
      if (value) {
        AppSnackBar().show(context, "Settings Configured!");
      } else {
        AppSnackBar().show(context, "Something went wrong!");
      }
    });
  }

  Future<RecConfiguration> getUserRecommendationConfiguration() async {
    var val = await _userRepo.getRecConfiguration();

    if (val == null) {
      return RecConfiguration(
        combination: '2',
        accuracy: '5',
      );
    }

    // Extracting values using RegExp
    RegExp regExp = RegExp(r'(\d+)');
    Iterable<Match> matches = regExp.allMatches(val);

    // Checking if matches are found
    if (matches.length >= 2) {
      String combination = matches.elementAt(0).group(0)!;
      String accuracy = matches.elementAt(1).group(0)!;

      return RecConfiguration(
        combination: combination,
        accuracy: accuracy,
      );
    } else {
      throw FormatException('Invalid format: $val');
    }
  }
}
