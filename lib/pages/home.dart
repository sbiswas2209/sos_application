import 'package:flutter/material.dart';
import 'package:sos_application/services/contacts_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await ContactsService().addContacts();
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.person_add))
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: ContactsService().getAllContacts(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                      trailing: IconButton(
                          onPressed: () async {
                            await ContactsService()
                                .removeContact(snapshot.data![index]);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete)),
                    );
                  },
                  itemCount: snapshot.data!.length,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onHelpButtonPressed,
        label: const Text("Help Required"),
        icon: const Icon(Icons.sos),
      ),
    );
  }

  void _onHelpButtonPressed() async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Sending message")));
    ContactsService().sendSosMessage().then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Message sent"),
            ),
          ),
        );
  }
}
