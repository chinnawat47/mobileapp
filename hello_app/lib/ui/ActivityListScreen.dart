import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:hello_app/models/Activity.dart';
import 'package:hello_app/services/ActivityDBHelper.dart';
import 'package:hello_app/ui/ActivityFormScreen.dart';


class ActivityListScreen extends StatelessWidget {

  const ActivityListScreen({super.key});


  Future<void> deleteActivity(
      BuildContext context,
      String id,
      ) async {

    try {

      await ActivityDBHelper.deleteActivity(id);

      if (context.mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text(
              'Activity deleted',
            ),
          ),

        );

      }


    } catch (e) {

      if (context.mounted) {

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
              'Delete error: $e',
            ),
          ),

        );

      }

    }

  }



  Future<bool?> confirmDelete(
      BuildContext context,
      ) async {


    return showDialog<bool>(

      context: context,

      builder: (context) {


        return AlertDialog(

          title: const Text(
              'Delete activity?'
          ),


          content: const Text(
              'Confirm delete this activity'
          ),


          actions: [


            TextButton(

              onPressed: () {

                Navigator.pop(
                    context,
                    false
                );

              },

              child: const Text(
                  'Cancel'
              ),

            ),



            TextButton(

              onPressed: () {

                Navigator.pop(
                    context,
                    true
                );

              },

              child: const Text(
                  'Delete'
              ),

            ),


          ],


        );


      },

    );


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text(
            'University Activities'
        ),

        backgroundColor: Colors.blueGrey,

        foregroundColor: Colors.white,

      ),




      body: Container(


        decoration: BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Colors.blueGrey.shade50,

              Colors.white,

            ],

          ),

        ),



        child: Padding(

          padding: const EdgeInsets.fromLTRB(
              16,
              24,
              16,
              16
          ),



          child: Card(

            elevation: 6,


            shape: RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(16),

            ),



            child: Padding(

              padding:
              const EdgeInsets.all(16),



              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children: [


                  const Row(

                    children: [

                      Icon(
                        Icons.list_alt,
                        size: 28,
                        color: Colors.blueGrey,
                      ),


                      SizedBox(
                          width: 12
                      ),


                      Text(

                        'Activities',

                        style: TextStyle(

                          fontSize: 20,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),

                    ],

                  ),




                  const SizedBox(
                      height: 12
                  ),



                  const Text(

                    'Browse and manage activities',

                    style: TextStyle(

                      color: Colors.black54,

                    ),

                  ),



                  const SizedBox(
                      height: 12
                  ),




                  Expanded(

                    child:
                    StreamBuilder<List<Activity>>(

                      stream:
                      ActivityDBHelper
                          .getActivitiesStream(),



                      builder:
                          (context, snapshot) {


                        if(snapshot.connectionState ==
                            ConnectionState.waiting) {


                          return const Center(

                            child:
                            CircularProgressIndicator(),

                          );


                        }



                        if(snapshot.hasError) {


                          return Center(

                            child:
                            Text(
                                'Error: ${snapshot.error}'
                            ),

                          );


                        }




                        if(!snapshot.hasData ||
                            snapshot.data!.isEmpty) {


                          return const Center(

                            child:
                            Text(
                                'Data not found'
                            ),

                          );


                        }



                        final actlist =
                        snapshot.data!;



                        return ListView.builder(

                          itemCount:
                          actlist.length,


                          itemBuilder:
                              (context,index) {


                            final actItem =
                            actlist[index];



                            return Slidable(


                              key:
                              ValueKey(
                                  actItem.id
                              ),



                              endActionPane:


                              ActionPane(

                                motion:
                                const DrawerMotion(),



                                children: [



                                  SlidableAction(

                                    onPressed:
                                        (context) async {


                                      final confirm =
                                      await confirmDelete(
                                          context
                                      );


                                      if(confirm == true) {


                                        deleteActivity(
                                            context,
                                            actItem.id
                                        );


                                      }


                                    },


                                    backgroundColor:
                                    Colors.red,


                                    foregroundColor:
                                    Colors.white,


                                    icon:
                                    Icons.delete,


                                    label:
                                    'Delete',

                                  ),




                                  SlidableAction(

                                    onPressed:
                                        (context) {


                                      Navigator.push(

                                        context,

                                        MaterialPageRoute(

                                          builder:
                                              (context) =>

                                              ActivityFormScreen(

                                                activity:
                                                actItem,

                                              ),

                                        ),

                                      );


                                    },


                                    backgroundColor:
                                    Colors.blueGrey,


                                    foregroundColor:
                                    Colors.white,


                                    icon:
                                    Icons.edit,


                                    label:
                                    'Edit',

                                  ),


                                ],


                              ),




                              child: Card(

                                margin:
                                const EdgeInsets.symmetric(
                                    vertical: 6
                                ),



                                child: ListTile(


                                  title:
                                  Text(

                                    actItem.title,

                                    style:
                                    const TextStyle(

                                      fontWeight:
                                      FontWeight.bold,

                                    ),

                                  ),



                                  subtitle:
                                  Text(

                                    actItem.desc,

                                    maxLines: 1,

                                    overflow:
                                    TextOverflow.ellipsis,

                                  ),



                                ),


                              ),


                            );


                          },


                        );


                      },


                    ),


                  ),



                ],


              ),


            ),


          ),


        ),


      ),





      floatingActionButton:

      FloatingActionButton(

        child:
        const Icon(
            Icons.add
        ),


        onPressed: () {


          Navigator.push(

            context,

            MaterialPageRoute(

              builder:
                  (context) =>

                  const ActivityFormScreen(),

            ),

          );


        },

      ),



    );


  }


}