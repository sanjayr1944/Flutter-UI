import 'package:flutter/material.dart';


class DismissableScreen extends StatefulWidget {
  const DismissableScreen({super.key});

  @override
  State<DismissableScreen> createState() => _DismissableScreenState();
}

class _DismissableScreenState extends State<DismissableScreen> {


  final List<String> tasks =
  [
    "Learning Flutter",
    "API Integration",
    "Firebase Authentication",
    "Bloc Statemanagement"
  ];

  final List<String> archiveTasks =
  [

  ];

  //ON ARCHIVE
  void archiveTask(String task)
  {
    setState(()
    {
      tasks.remove(task); //Removing the Content from Common screen
      archiveTasks.add(task); //it will only visible at Archive Screen
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$task Archived!"),)
    );


  }

  //ON DELETE
  void deleteingTask(String task)
  {
    setState(()
    {
      tasks.remove(task); //Deleting the task, it will only visible at Common Screen
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$task Deleted!"),)
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dismissable Screen"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.archive))
        ],
      ),
      body: tasks.isEmpty ? Center(child: Text("No Tasks"),)
          : ListView.builder(
        itemCount: tasks.length,
          itemBuilder:(context,index)
          {
            final task = tasks[index];

            return Dismissible(
                key: ValueKey(task),
                direction: DismissDirection.horizontal,

                //Archive

                background: Container(
                  color: Colors.blue,
                  alignment: .centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.archive,color: Colors.white,),
                ),

                //Delete

                secondaryBackground: Container(
                  color: Colors.red,
                  alignment: .centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete,color: Colors.white,),
                ),

                confirmDismiss: (direction)
                async{
                  if(direction == DismissDirection.startToEnd)
                  {
                    archiveTask(task);
                    return false;
                  }
                  else
                  {
                    return await
                    showDialog<bool>
                      (
                      context: context,
                      builder: (dialogContext)
                      {
                        return AlertDialog(
                          title: Text("Are you sure?"),
                          content: Text("Do you want to delete $task?"),

                          actions: [
                            TextButton(onPressed: ()
                            {
                              Navigator.of(dialogContext).pop(false);
                            },
                                child: Text("Cancel"),
                            ),
                            TextButton(onPressed: ()
                            {
                              Navigator.of(dialogContext).pop(true);
                            },
                                child: Text("Delete"),
                            ),
                          ],
                        ) ;
                      },
                    ) ?? false;
                  }
                },

                onDismissed: (direction)
                {
                  if(direction == DismissDirection.endToStart)
                  {
                    deleteingTask(task);
                  }
                },

                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Icon(Icons.task,
                    color: Colors.deepPurpleAccent,),
                    title: Text(task),
                    subtitle: Text("Swipe Right to Archive - Left to Delete"),
                  )
                ),
            );
          },
      ),
    );
  }
}
