import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vpost_2/utils/colors.dart';
import 'package:vpost_2/widgets/post_card.dart';

import '../utils/dimensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List searchResult = [];

  void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('posts')
        .where('title', arrayContains: query)
        .get();

    final resultTags = await FirebaseFirestore.instance
        .collection('posts')
        .where(
          'tags', // Search in 'tags' field
          arrayContains: query,
        )
        .get();

    final resultLocation = await FirebaseFirestore.instance
        .collection('posts')
        .where(
          'location', // Search in 'location' field
          arrayContains: query,
        )
        .get();

    final List<DocumentSnapshot> combinedResults = [
      ...result.docs,
      ...resultTags.docs,
      ...resultLocation.docs,
    ];

    setState(() {
      searchResult = combinedResults.map((e) => e.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: mobileBackgroundColor,
          flexibleSpace: Container(),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onChanged: (query) {
                        searchFromFirebase(query);
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: primaryColor,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: webBackgroundColor,
                        contentPadding: const EdgeInsets.only(top: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                          borderSide: BorderSide(
                            color: secondaryColor,
                            width: 1,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(
                              color: secondaryColor,
                              width: 1.5,
                            )),
                        hintText: 'Search Opportunities',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true) // Order by timestamp in descending order (most recent first)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<DocumentSnapshot> filteredPosts = snapshot.data!.docs.where((doc) {
            final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            final String title = data['title'].toString().toLowerCase();
            final dynamic tagsData = data['tags'];
            final List<dynamic> tags = (tagsData is String) ? [tagsData] : (tagsData ?? []); // Handle String or List
            final String location = data['location'].toString().toLowerCase();
            final String query = _searchController.text.toLowerCase();

            // Check if any of the fields (title, tags, or location) contain the query
            return title.contains(query) ||
                tags.any((tag) => tag.toString().toLowerCase().contains(query)) ||
                location.contains(query);
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: filteredPosts.length,
              itemBuilder: (ctx, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 0,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: PostCard(
                    snap: filteredPosts[index].data(),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
