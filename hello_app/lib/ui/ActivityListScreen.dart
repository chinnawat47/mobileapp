import 'package:flutter/material.dart';
import 'package:hello_app/models/Activity.dart';
import 'package:hello_app/services/ActivityDBHelper.dart';
import 'package:hello_app/ui/ActivityFormScreen.dart';


class ActivityListScreen extends StatelessWidget {

  const ActivityListScreen({super.key});



  // DELETE FUNCTION
  Future<void> deleteActivity(
      BuildContext context,
      String id
      ) async {


    try {

      await ActivityDBHelper.deleteActivity(id);


      if(context.mounted){

        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text(
              'Activity deleted'
            ),
          ),

        );

      }


    } catch(e){


      if(context.mounted){

        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
              'Delete error: $e'
            ),
          ),

        );

      }

    }

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


          padding:
          const EdgeInsets.fromLTRB(
              16,
              24,
              16,
              16
          ),




          child: Card(


            elevation:6,


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





                children:[




                  Row(


                    children:[


                      Container(


                        padding:
                        const EdgeInsets.all(10),


                        decoration:
                        BoxDecoration(


                          color:
                          Colors.blueGrey.shade50,


                          shape:
                          BoxShape.circle,


                        ),



                        child:
                        const Icon(

                          Icons.list_alt,

                          size:28,

                          color:Colors.blueGrey,

                        ),


                      ),




                      const SizedBox(
                          width:12
                      ),




                      const Expanded(


                        child:Text(


                          'Activities',


                          style:TextStyle(


                            fontSize:20,


                            fontWeight:
                            FontWeight.bold,


                          ),


                        ),


                      ),



                    ],


                  ),






                  const SizedBox(
                      height:12
                  ),




                  const Text(

                    'Browse and manage activities',

                    style:
                    TextStyle(

                      color:Colors.black54,

                    ),

                  ),






                  const SizedBox(
                      height:12
                  ),





                  Expanded(


                    child:
                    StreamBuilder<List<Activity>>(



                      stream:
                      ActivityDBHelper
                          .getActivitiesStream(),




                      builder:
                          (context,snapshot){



                        if(snapshot.connectionState ==
                            ConnectionState.waiting){


                          return const Center(

                            child:
                            CircularProgressIndicator(),

                          );


                        }




                        if(snapshot.hasError){


                          return Center(

                            child:
                            Text(
                              'Error: ${snapshot.error}'
                            ),

                          );


                        }





                        if(!snapshot.hasData ||
                            snapshot.data!.isEmpty){


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
                              (context,index){



                            final actItem =
                                actlist[index];




                            return Dismissible(



                              key:
                              ValueKey(
                                  actItem.id
                              ),




                              direction:
                              DismissDirection.endToStart,





                              background:
                              Container(


                                color:
                                Colors.red,


                                alignment:
                                Alignment.centerRight,


                                padding:
                                const EdgeInsets.only(
                                    right:20
                                ),



                                child:
                                const Icon(

                                  Icons.delete,

                                  color:
                                  Colors.white,

                                ),



                              ),





                              confirmDismiss:
                                  (direction) async{



                                return await showDialog<bool>(


                                  context:context,


                                  builder:
                                      (context){



                                    return AlertDialog(


                                      title:
                                      const Text(
                                          'Delete activity?'
                                      ),



                                      content:
                                      const Text(
                                          'Confirm delete this activity'
                                      ),




                                      actions:[



                                        TextButton(

                                          onPressed:(){

                                            Navigator.pop(
                                                context,
                                                false
                                            );

                                          },

                                          child:
                                          const Text(
                                              'Cancel'
                                          ),

                                        ),





                                        TextButton(

                                          onPressed:(){

                                            Navigator.pop(
                                                context,
                                                true
                                            );

                                          },


                                          child:
                                          const Text(
                                              'Delete'
                                          ),

                                        ),



                                      ],


                                    );


                                      },


                                );


                              },





                              onDismissed:(direction){


                                deleteActivity(
                                  context,
                                  actItem.id,
                                );


                              },






                              child:Card(



                                margin:
                                const EdgeInsets.symmetric(
                                    vertical:6
                                ),





                                child:ListTile(



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

                                    maxLines:1,

                                    overflow:
                                    TextOverflow.ellipsis,

                                  ),




                                  trailing:
                                  IconButton(


                                    icon:
                                    const Icon(

                                      Icons.edit,

                                      color:
                                      Colors.blueGrey,

                                    ),



                                    onPressed:(){



                                      Navigator.push(


                                        context,


                                        MaterialPageRoute(


                                          builder:
                                              (context)=>

                                              ActivityFormScreen(

                                                activity:
                                                actItem,

                                              ),



                                        ),



                                      );


                                    },


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






      // CREATE FEATURE
      floatingActionButton:
      FloatingActionButton(


        child:
        const Icon(
            Icons.add
        ),



        onPressed:(){



          Navigator.push(


            context,


            MaterialPageRoute(


              builder:
                  (context)=>

                  const ActivityFormScreen(),



            ),



          );



        },


      ),



    );

  }

}