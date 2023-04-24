part of 'pick_image_cubit.dart';

abstract class PickImageState extends Equatable {
  const PickImageState();

  @override
  List<Object> get props => [];
}

class NoImage extends PickImageState {}

class ImagePicked extends PickImageState {
  final File selectedImage;
  const ImagePicked({required this.selectedImage});
  @override
  List<Object> get props => [selectedImage];
}
