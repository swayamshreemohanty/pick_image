import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(NoImage());

  void clearPickedImage() {
    emit(NoImage());
  }

  Future<void> pickImage(
    BuildContext context, {
    required ImageSource imageSource,
  }) async {
    try {
      await Permission.storage.request();
      if (await Permission.storage.isGranted) {
        final pickedFile = await ImagePicker().pickImage(
          source: imageSource,
          imageQuality: 80,
          maxHeight: 1024,
          maxWidth: 1920,
        );

        if (pickedFile != null) {
          //Check for image size should not cross 1 mb
          if (await pickedFile.length() > 1000000) {
            Fluttertoast.showToast(
              msg: "Maximum image size will be 1 mb",
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
            );
          } else {
            final selectedImage = File(pickedFile.path);
            emit(NoImage());
            emit(ImagePicked(selectedImage: selectedImage));
            return;
          }
        } else {
          Fluttertoast.showToast(msg: "No image selected");
        }
      } else {
        Fluttertoast.showToast(msg: "Permission required");
      }
      emit(NoImage());
      return;
    } catch (e) {
      emit(NoImage());
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
