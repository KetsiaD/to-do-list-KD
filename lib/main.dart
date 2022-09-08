// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';


List<String> nametodo = [];
final _itemSet = <Item>{};

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Item To Add'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: yesStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: noStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(valueText); 
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('OK'),
                  );
                },
              ),
            ],
          );
        });
  }

  String valueText = "";

  final List<Item> items = [const Item(name: "add more todos")];

  

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);

      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item =  Item(name: itemText);
      items.insert(0, item);
      nametodo.add(item.name);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
          actions: [
            const PrToDo(),
            IconButton(
              key: const Key('addButton'),
              icon: const Icon(Icons.search),
              onPressed: () {
                print("loading search screen");
                showSearch(
                  context: context,
                  delegate: MySearchDelegate(),
                  useRootNavigator: true,
                );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
        
  }
}
class MySearchDelegate extends SearchDelegate{
  List<String> searchResults = nametodo;

  @override
  Widget? buildLeading (BuildContext context) => IconButton(
    key: const Key('addButton3'),
    icon: const Icon(Icons.arrow_back),
    onPressed: ()=> close(context, null),
  );
  @override
  List<Widget>?buildActions(BuildContext context) => [
    IconButton(
      key: const Key('addButton2'),
      icon: const Icon(Icons.clear),
      onPressed: (){
        if (query.isEmpty){
          close(context, null);
        }else{
          query = '';
        }
      },

    ),

  ];
  @override
  Widget buildResults(BuildContext context) => Center(
    child: Text(
      key: Key('addText1'),
      query,
      style: const TextStyle(fontSize: 70, fontWeight: FontWeight.w700)
    )
  );
  @override
  Widget buildSuggestions(BuildContext context){
    List<String> suggestions = searchResults.where((searchResult){
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);

    }).toList();

     return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index){
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: (){
            query = suggestion;

            showResults(context); 
          },

        );
        
      },
     );
  }
}

class PrToDo extends StatefulWidget {
  const PrToDo({super.key});

  @override
  State createState() => _PrToDoState();
}

class _PrToDoState extends State<PrToDo>{
  get items => null;

  @override
  Widget build(BuildContext) {
    return IconButton(
      icon: Icon(Icons.delete),
        color: Colors.black,
        tooltip: 'Clear everything',
        iconSize: 30,
        onPressed: (){
        }
      ); 

  }

}


void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}
