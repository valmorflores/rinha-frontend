import 'package:get/get.dart';

import '../constants/enum_stage.dart';

class ApplicationController extends GetxController {
  StepStage _stage = StepStage.unknow;
  bool _isSelectedFile = false;

  setStage(StepStage stage) => _stage = stage;
  getStage() => _stage;

  setSelectedFile(bool isSelected) => _isSelectedFile = isSelected;
  isSelectedFile() {
    return _isSelectedFile;
  }
}
