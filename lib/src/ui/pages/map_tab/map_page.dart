import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  static const String route = "/map_page";

  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  /// Variable para guardar el estilo del mapa customizado
  String? _darkMapStyle;

  /// Controlador del mapa, nos permite hacer actualizaciones de posiciones, cambio de estilos, entre otras funciones adicionales de control del mapa
  // GoogleMapController? controller;
  Completer<GoogleMapController> controller = Completer();

  /// Variable de control de marcadores que se agregaran
  final List<Marker> _markers = <Marker>[];

  /// Posiciones de los marcadores a agregar
  final List<LatLng> _latLen = const <LatLng>[
    LatLng(19.450955, -99.161521),
    LatLng(19.409463, -99.112298),
    LatLng(19.402331, -99.178157),
    LatLng(19.444214, -99.109411),
    LatLng(19.468845, -99.150521),
    LatLng(19.459382, -99.183795),
  ];

  @override
  void initState() {
    super.initState();

    loadData();

    rootBundle
        .loadString('assets/style/map_dark_mode.json')
        .then((String string) {
      _darkMapStyle = string;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: GoogleMap(
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              this.controller.complete(controller);

              this.controller.future.then((GoogleMapController controllerMap) =>
                  controllerMap.setMapStyle(_darkMapStyle));
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(19.435659, -99.140625), zoom: 12)),
      ),
    );
  }

  void loadData() {
    for (final LatLng location in _latLen) {
      _markers.add(Marker(
        markerId: MarkerId(location.latitude.toString()),

        /// Posicion del marcador
        position: location,
        infoWindow: InfoWindow(
          // given title for marker
          title: 'Location: ${location.latitude}, ${location.longitude}',
        ),
      ));
    }
    setState(() {});
  }
}
