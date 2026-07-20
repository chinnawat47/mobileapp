import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


import 'package:hello_app/models/earthquake_model.dart';
import 'package:hello_app/services/earthquake_service.dart';



class EarthquakeDisplayScreen extends StatefulWidget {


  const EarthquakeDisplayScreen({
    super.key,
  });



  @override
  State<EarthquakeDisplayScreen> createState() =>
      _EarthquakeDisplayScreenState();


}





class _EarthquakeDisplayScreenState
    extends State<EarthquakeDisplayScreen> {



  final EarthquakeService _earthquakeService =
      EarthquakeService();



  final TextEditingController _searchController =
      TextEditingController();



  final MapController _mapController = MapController();



  List<EarthquakeModel> _searchResult = [];





  @override
  void dispose(){

    _searchController.dispose();

    super.dispose();

  }






  // ==========================
  // SEARCH
  // ==========================

  Future<void> searchEarthquake() async {


    final result =
        await _earthquakeService
            .searchEarthquake(
              _searchController.text,
            );



    setState(() {

      _searchResult = result;

    });



    if (result.isNotEmpty) {
      final first = result.first;
      _mapController.move(
        LatLng(first.latitude, first.longitude),
        6.5,
      );
    } else {
      if (_searchController.text.trim().isNotEmpty && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No earthquake matches found for "${_searchController.text}"'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }







  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title:
            const Text(
              'Global Earthquake Map',
            ),


        backgroundColor:
            Colors.deepPurple,


        foregroundColor:
            Colors.white,


        centerTitle:
            true,

        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined),
            tooltip: 'Seed Mock Data',
            onPressed: () async {
              try {
                await _earthquakeService.addEarthquake(
                  const EarthquakeModel(
                    id: '',
                    place: 'Tohoku, Japan',
                    latitude: 38.322,
                    longitude: 142.369,
                    mag: 9.0,
                    depth: '24',
                    time: '2011-03-11 14:46:24',
                  ),
                );
                await _earthquakeService.addEarthquake(
                  const EarthquakeModel(
                    id: '',
                    place: 'Chiang Rai, Thailand',
                    latitude: 19.703,
                    longitude: 99.689,
                    mag: 6.1,
                    depth: '7',
                    time: '2014-05-05 18:08:43',
                  ),
                );
                await _earthquakeService.addEarthquake(
                  const EarthquakeModel(
                    id: '',
                    place: 'Banda Aceh, Indonesia',
                    latitude: 3.316,
                    longitude: 95.854,
                    mag: 9.1,
                    depth: '30',
                    time: '2004-12-26 07:58:53',
                  ),
                );
                await _earthquakeService.addEarthquake(
                  const EarthquakeModel(
                    id: '',
                    place: 'San Francisco, USA',
                    latitude: 37.7749,
                    longitude: -122.4194,
                    mag: 4.5,
                    depth: '12',
                    time: '2026-07-20 01:23:45',
                  ),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sample earthquake data seeded successfully!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to seed data: $e'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              }
            },
          ),
        ],


      ),





      body: Column(



        children: [





          // SEARCH BOX

          Padding(

            padding:
                const EdgeInsets.all(12),


            child:
                TextField(


              controller:
                  _searchController,


              decoration:
                  InputDecoration(


                hintText:
                    'Search place (Japan, Thailand...)',



                prefixIcon:
                    const Icon(
                      Icons.search,
                    ),




                suffixIcon:
                    IconButton(


                  icon:
                      const Icon(
                        Icons.send,
                      ),



                  onPressed:
                      searchEarthquake,


                ),



                border:
                    OutlineInputBorder(


                  borderRadius:
                      BorderRadius.circular(20),


                ),



              ),



            ),



          ),






          Expanded(



            child:
                StreamBuilder<List<EarthquakeModel>>(



              stream:
                  _earthquakeService
                      .getEarthquakeStream(),



              builder:
                  (context,snapshot){



                if(snapshot.hasError){


                  return Center(

                    child:
                        Text(
                          snapshot.error.toString(),
                        ),

                  );


                }






                if(snapshot.connectionState ==
                    ConnectionState.waiting){


                  return const Center(

                    child:
                        CircularProgressIndicator(),

                  );


                }







                List<EarthquakeModel> earthquakes =
                    snapshot.data ?? [];






                // ถ้า Search แล้วใช้ผล Search

                if(_searchResult.isNotEmpty){

                  earthquakes =
                      _searchResult;

                }







                if(earthquakes.isEmpty){


                  return const Center(

                    child:
                        Text(
                          'No earthquake data',
                        ),

                  );


                }








                final markers =
                    earthquakes.map((quake){



                  return Marker(



                    point:
                        LatLng(

                      quake.latitude,

                      quake.longitude,

                    ),




                    width:
                        60,



                    height:
                        60,



                    child: Tooltip(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: quake.mag >= 5 ? Colors.redAccent.withOpacity(0.5) : Colors.orangeAccent.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      preferBelow: false,
                      richMessage: TextSpan(
                        children: [
                          TextSpan(
                            text: '${quake.place}\n',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          const TextSpan(
                            text: 'Magnitude: ',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                          TextSpan(
                            text: '${quake.mag}\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: quake.mag >= 5.0
                                  ? Colors.redAccent
                                  : Colors.orangeAccent,
                            ),
                          ),
                          TextSpan(
                            text: 'Depth: ${quake.depth} km',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final double mag = quake.mag;
                              final isMajor = mag >= 5.0;
                              final severityColor = isMajor ? Colors.redAccent : Colors.orangeAccent;
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 8,
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  constraints: const BoxConstraints(maxWidth: 380),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: severityColor.withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: severityColor, width: 1.5),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(Icons.warning_amber_rounded, color: severityColor, size: 16),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'M $mag',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: severityColor,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            icon: const Icon(Icons.close, color: Colors.grey),
                                            onPressed: () => Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        quake.place,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      const Divider(),
                                      const SizedBox(height: 8),
                                      _buildDetailRow(
                                        icon: Icons.compress_outlined,
                                        label: 'Depth',
                                        value: '${quake.depth} km',
                                        color: Colors.blueGrey,
                                      ),
                                      const SizedBox(height: 10),
                                      _buildDetailRow(
                                        icon: Icons.access_time_rounded,
                                        label: 'Time (UTC)',
                                        value: quake.time,
                                        color: Colors.deepPurple,
                                      ),
                                      const SizedBox(height: 10),
                                      _buildDetailRow(
                                        icon: Icons.location_on_outlined,
                                        label: 'Coordinates',
                                        value: '${quake.latitude.toStringAsFixed(4)}, ${quake.longitude.toStringAsFixed(4)}',
                                        color: Colors.teal,
                                      ),
                                      const SizedBox(height: 20),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.location_on,
                          size: 40,
                          color: quake.mag >= 5 ? Colors.red : Colors.orange,
                        ),
                      ),
                    ),



                  );



                }).toList();







                return FlutterMap(


                  mapController: _mapController,



                  options:
                      const MapOptions(



                    initialCenter:
                        LatLng(
                          20,
                          0,
                        ),



                    initialZoom:
                        2.5,


                  ),





                  children: [





                    TileLayer(



                      urlTemplate:

                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',



                      userAgentPackageName:
                          'hello_app',


                    ),





                    MarkerLayer(

                      markers:
                          markers,

                    ),





                    RichAttributionWidget(


                      attributions: [


                        TextSourceAttribution(

                          'OpenStreetMap contributors',

                        ),


                      ],


                    ),



                  ],



                );



              },



            ),



          ),



        ],



      ),



    );


  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}