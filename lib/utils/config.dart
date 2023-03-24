import 'package:geolocator/geolocator.dart';

String DEFAULT_HELP_MESSAGE({required Position position}) =>
    "I need help. I am currently here - Latitude : ${position.latitude > 0 ? ("${position.latitude}N") : ("${position.latitude}S")}, Longitude : Latitude : ${position.longitude > 0 ? ("${position.longitude}N") : ("${position.longitude}S")}";
