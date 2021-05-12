import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:internshipapp/models/message.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
class MessagingRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;
  String uuid = Uuid().v4();

  MessagingRepository({FirebaseStorage firebaseStorage, FirebaseFirestore firestore})
      : _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future sendMessage({Message message}) async {
    DocumentReference messageRef = _firestore.collection('messages').doc();
    CollectionReference senderRef;
    senderRef = _firestore.collection('users').doc(message.senderId).collection('chats').doc(message.selectedUserId).collection('messages');

    CollectionReference sendUserRef = _firestore
        .collection('users')
        .doc(message.selectedUserId)
        .collection('chats')
        .doc(message.senderId)
        .collection('messages');

    if (message.photo != null) {
      firebase_storage.Reference  photoRef=await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('messages')
          .child(messageRef.id)
          .child(uuid);

      //storageUploadTask = photoRef.putFile(message.photo);

      await photoRef.putFile(message.photo).whenComplete(() async {
        await photoRef.getDownloadURL().then((url) async {
          await messageRef.set({
            'senderName': message.senderName,
            'senderId': message.senderId,
            'text': null,
            'photoUrl': url,
            'timestamp': DateTime.now(),
          });
        });
      });

      senderRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      sendUserRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
    if (message.text != null) {
      await messageRef.set({
        'senderName': message.senderName,
        'senderId': message.senderId,
        'text': message.text,
        'photoUrl': null,
        'timestamp': DateTime.now(),
      });

      senderRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      sendUserRef
          .doc(messageRef.id)
          .set({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.senderId)
          .collection('chats')
          .doc(message.selectedUserId)
          .update({'timestamp': DateTime.now()});

      await _firestore
          .collection('users')
          .doc(message.selectedUserId)
          .collection('chats')
          .doc(message.senderId)
          .update({'timestamp': DateTime.now()});
    }
  }

  Stream<QuerySnapshot> getMessages({currentUserId, selectedUserId}) {
    return _firestore
        .collection('users')
        .doc(currentUserId)
        .collection('chats')
        .doc(selectedUserId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<Message> getMessageDetail({messageId}) async {
    Message _message = Message();

    await _firestore
        .collection('messages')
        .doc(messageId)
        .get()
        .then((message) {
      _message.senderId = message.data()['senderId'];
      _message.senderName = message.data()['senderName'];
      _message.timestamp = message.data()['timestamp'];
      _message.text = message.data()['text'];
      _message.photoUrl = message.data()['photoUrl'];
    });

    return _message;
  }
}