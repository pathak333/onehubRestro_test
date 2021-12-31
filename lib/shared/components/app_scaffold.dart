import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:onehubrestro/controllers/navigation/navigation-controller.dart';
import 'package:onehubrestro/screens/maintainence/no_internet.dart';
import 'package:onehubrestro/utilities/maintainence/connection_status.dart';

class AppContainer extends StatelessWidget {

  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();

  AppContainer({
    this.route,
    this.child
  }){
    NavigationController navigationController = Get.find<NavigationController>();
    navigationController.setRoute(route);
  }

  final Widget child;
  final String route;
  
  @override
  Widget build(BuildContext context) {

    if(!connectionStatus.hasConnection){
      return NoInternet();
    }
    
    return StreamBuilder<Object>(
      stream: connectionStatus.connectionChange,
      builder: (context, snapshot) {
        if((snapshot.data == null && connectionStatus.hasConnection) || snapshot.data){
          return child;
        } else {
          return NoInternet();
        }
      }
    );
  }
}