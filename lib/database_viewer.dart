import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseViewer extends StatelessWidget {
  DatabaseViewer({Key key}) : super(key: key);

  Widget _dataBuilder(DocumentSnapshot data, BuildContext context) {
    return Column(
      children: <Widget>[
        Text(data['barcode']),
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(data['images']),
          ),
          title: Text(data['productName']),
          subtitle: Text(data['brand']),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _showRemoveAlert(data, context);
            }
          ),
        )
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
            title: Text('Remove from list?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Remove'),
                onPressed: () {
                  Firestore.instance
                      .collection('products')
                      .document(data.documentID)
                      .delete();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemCount: snapshot.data.documents.lenght,
            itemBuilder: (context, index) {
              return _dataBuilder(snapshot.data.documents[index], context);
            },
          );
        },
      ),
    );
  }
}
