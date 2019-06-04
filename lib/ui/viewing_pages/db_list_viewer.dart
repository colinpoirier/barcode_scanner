import 'package:barcode_scanner/ui/edit_pages/edit_db_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbListViewer extends StatefulWidget {
  DbListViewer({Key key}) : super(key: key);

  @override
  _DbListViewerState createState() => _DbListViewerState();
}

class _DbListViewerState extends State<DbListViewer> {
  TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.addListener(() => setState(() {}));
  }

  Widget _dbListItem(DocumentSnapshot data, BuildContext context) {
    return Column(
      children: <Widget>[
        Text(data['barcode']),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data['imageThumb']),
          ),
          title: Text(data['name']),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(data['brand']),
              Text(data['price'].toString()),
              Text(data['count'].toString()),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _showRemoveAlert(data, context);
            },
          ),
          onLongPress: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditDbData(
                        dbData: data,
                      ),
                ),
              ),
        ),
      ],
    );
  }

  Future<void> _showRemoveAlert(
      DocumentSnapshot data, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove from Database?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: const Text('Remove'),
              onPressed: () async {
                await Firestore.instance
                    .collection('products')
                    .document(data.documentID)
                    .delete();
                Navigator.of(context).pop();
              },
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
        title: Text('Database'),
        actions: <Widget>[
          Container(
            width: 150,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.black),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                  )),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final tempData = snapshot.data.documents
                .where((document) => document.data['image'] != null)
                .toList();
            List<DocumentSnapshot> data = controller.text == null
                ? tempData
                : tempData
                    .where((document) => document.data.values
                        .toList()
                        .toString()
                        .replaceAll(document.data['image'], '')
                        .replaceAll(document.data['imageThumb'], '')
                        .toLowerCase()
                        .contains(controller.text.toLowerCase()))
                    .toList();
            return ListView.separated(
              separatorBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(10),
                    height: 1,
                    color: Colors.grey,
                  ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return _dbListItem(data[index], context);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
