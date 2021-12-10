import 'package:doctor_app/models/client.dart';
import 'package:doctor_app/providers/clients_provider.dart';
import 'package:doctor_app/screens/add_client.dart';
import 'package:doctor_app/screens/client_details.dart';
import 'package:doctor_app/widget/client_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class Clients_Overview extends StatefulWidget {
  const Clients_Overview({Key? key}) : super(key: key);

  @override
  State<Clients_Overview> createState() => _Clients_OverviewState();
}

class _Clients_OverviewState extends State<Clients_Overview> {
  bool isGrid = false;
  int clientsCount = 10;
  void loadMore(int i) {
    setState(() {
      clientsCount = 10;
    });

    if (clientsCount >= i) {
      return;
    }
    if (i % 10 == 0) {
      setState(() {
        clientsCount += 10;
      });
    } else {
      setState(() {
        clientsCount += (i % 10);
      });
    }
  }

  bool isSearch = false;

  var controller = TextEditingController();

  @override
  void initState() {
    Provider.of<Clients_Provider>(context, listen: false).getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Client> clients = isSearch
        ? Provider.of<Clients_Provider>(context).Search(controller.text)
        : Provider.of<Clients_Provider>(context).items;
    Icon customIcon =
        !isSearch ? const Icon(Icons.search) : const Icon(Icons.cancel);
    Widget searchbar = !isSearch
        ? const Text(
            "DR Z Clinic",
            style: TextStyle(fontFamily: 'KaushanScript'),
          )
        : ListTile(
            leading: const Icon(Icons.search),
            title: Container(
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                autofocus: true,
                controller: controller,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    fillColor: Colors.white,
                    focusColor: Colors.black,
                    //icon: Icon(Icons.search),

                    hintText: "Search for a client..",
                    hintStyle: TextStyle(color: Colors.white)),
                onChanged: (val) {
                  Provider.of<Clients_Provider>(context, listen: false)
                      .getData();
                  setState(() {});
                },
              ),
            ));

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0,
        title: searchbar,
        actions: [
          if (!isSearch)
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(Add_Client.routename);
                },
                icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  isSearch = !isSearch;
                  controller.clear();
                });
              },
              icon: customIcon),
          PopupMenuButton(onSelected: (int value) {
            if (value == 0) {
              setState(() {
                isGrid = true;
              });
            } else {
              setState(() {
                isGrid = false;
              });
            }
          }, itemBuilder: (context) {
            return [
              const PopupMenuItem(
                child: Text("gridview"),
                value: 0,
              ),
              const PopupMenuItem(
                child: Text("List View"),
                value: 1,
              )
            ];
          })
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            Provider.of<Clients_Provider>(context, listen: false).getData(),
        child: Container(
          child: clients.isEmpty
              ? const Center(child: Text("Try adding some Clients"))
              : LazyLoadScrollView(
                  onEndOfPage: () {
                    loadMore(clients.length);
                  },
                  child: isGrid
                      ? GridView.builder(
                          itemCount: clients.length > 10
                              ? clientsCount
                              : clients.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 3 / 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemBuilder: (BuildContext context, i) {
                            return ChangeNotifierProvider(
                              create: (context) {
                                clients[i];
                              },
                              child: CLient_Widget(
                                  clients,
                                  clients[i].name,
                                  clients[i].image!,
                                  clients[i].age,
                                  clients[i].gender,
                                  clients[i].id!),
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: clients.length,
                          itemBuilder: (context, index) {
                            return ChangeNotifierProvider(
                              create: (context) {
                                clients[index];
                              },
                              child: Dismissible(
                                confirmDismiss: (_) {
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Are you sure?"),
                                          content: const Text(
                                              "Do you want to delete this item from the cart?"),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Item successfully dismissed")));
                                                },
                                                child: const Text("Yes")),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text("No")),
                                          ],
                                        );
                                      });
                                },
                                key: ValueKey(clients[index].id),
                                onDismissed: (_) {
                                  Provider.of<Clients_Provider>(context,
                                          listen: false)
                                      .delete(clients[index].id!);
                                },
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  padding: const EdgeInsets.all(20),
                                  alignment: Alignment.centerRight,
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        Client_Details_Screen.routename,
                                        arguments: clients[index].id);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListTile(
                                      trailing: Text(
                                        "Age : ${clients[index].age}",
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      leading: Hero(
                                        tag: clients[index].id!,
                                        child: CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              FileImage(clients[index].image!),
                                        ),
                                      ),
                                      title: Text(
                                        clients[index].name,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                ),
        ),
      ),
    );
  }
}
