import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:one_person_twitter/features/tweet/tweet_page_controller.dart';
import 'package:intl/intl.dart';

class TweetPage extends StatelessWidget {
  final TweetPageController _tweetPageController =
      Get.put(TweetPageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: FaIcon(FontAwesomeIcons.signOutAlt),
              onPressed: _tweetPageController.onSignout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //  Text(user.user.email),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _tweetPageController.formKey,
              child: TextFormField(
                //  key: _tweetPageController.formKey,
                controller: _tweetPageController.tweetTextController,
                minLines: 5,
                maxLines: 5,
                enableSuggestions: false,
                maxLength: 280,
                onSaved: (value) => _tweetPageController.tweetText = value,
                validator: (String value) {
                  if (value.isEmpty) return 'Please enter some tweet';
                  return null;
                },
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                        onPressed: _tweetPageController.onCreateOrUpdateTweet,
                        icon: Icon(Icons.send),
                        label: Text(_tweetPageController.editTweet.value == null
                            ? 'POST'
                            : 'UPDATE')),
                    SizedBox(
                      width: 20,
                    ),
                    if (_tweetPageController.editTweet.value != null)
                      TextButton(
                          onPressed: _tweetPageController.onCancelTweetUpdate,
                          child: Text('Cancel'))
                  ],
                )),

            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _tweetPageController.tweets,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.twitter,
                                      color: Color(0xFF01A3F5),
                                      size: 60,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _tweetPageController.getDisplayName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          snapshot.data.docs[index]
                                              .data()['tweet_content'],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat.yMd().add_jm().format(snapshot
                                          .data.docs[index]
                                          .data()['post_date']
                                          .toDate()),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        icon: FaIcon(FontAwesomeIcons.trash),
                                        onPressed: () =>
                                            _tweetPageController.onDeleteTweet(
                                                snapshot.data.docs[index])),
                                    IconButton(
                                        icon:
                                            FaIcon(FontAwesomeIcons.solidEdit),
                                        onPressed: () =>
                                            _tweetPageController.onEditTweet(
                                                snapshot.data.docs[index])),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
