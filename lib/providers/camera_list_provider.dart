import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraList extends InheritedWidget{
  final List<CameraDescription> cameras;
  final Widget child;

  CameraList({Key key, this.cameras, this.child}) : super(key: key, child: child);


  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    
    return true;
  }
  
  static CameraList of(BuildContext context)=>
      context.inheritFromWidgetOfExactType(CameraList);
}