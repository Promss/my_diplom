import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_diplom/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DirectioView extends StatefulWidget {
  final Stream<QuerySnapshot> directionStream;
  final Function(String) onDeleteDirection;
  final Function(DocumentSnapshot) onEditDirection;

  const DirectioView({
    Key? key,
    required this.directionStream,
    required this.onDeleteDirection,
    required this.onEditDirection,
  }) : super(key: key);

  @override
  State<DirectioView> createState() => _DirectioViewState();
}

class _DirectioViewState extends State<DirectioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(103, 80, 165, 1),
          onPressed: () {
            // ignore: avoid_print
            print('Добавление');
            context.go('/addScreens/direction');
          },
          child: Icon(
            Icons.add,
            color: Color.fromRGBO(227, 227, 227, 1),
          ),
        ),
        backgroundColor: const Color.fromRGBO(227, 227, 227, 1),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // ignore: avoid_print
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainScreen(),
                ),
              );
            },
          ),
          title: const Text('Направления'),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildDirectionList(),
            ),
          ],
        ));
  }

  Widget _buildDirectionList() {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.directionStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data!.docs[index];
            return _buildDirectionTile(ds);
          },
        );
      },
    );
  }

  Widget _buildDirectionTile(DocumentSnapshot ds) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  ds['Direction'],
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.green),
                      onPressed: () => widget.onEditDirection(ds),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => widget.onDeleteDirection(ds.id),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
