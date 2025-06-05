import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patcharaphorn_final_app/components/movieslist_card.dart';

class MovieListPage extends StatelessWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Reference to the Firestore collection
    final movieCollection = FirebaseFirestore.instance.collection('patcharaphorn_movies');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Movies / Series List"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: movieCollection.snapshots(), // Stream data from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }

          // Data fetched from Firestore
          final movies = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index].data() as Map<String, dynamic>;

              return MovieCard(
                title: movie['title'] ?? 'No Title',
                genre: List<String>.from(movie['genre'] ?? []),
                length: movie['length'] ?? '',
                source: movie['source'] ?? 'No Source',
                imageUrl: movie['imageUrl'] ?? '',
                synopsis: movie['synopsis'] ?? '',
              );
            },
          );
        },
      ),
    );
  }
}
