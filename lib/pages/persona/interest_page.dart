// interest_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:symphia/controller/user_controller.dart';
import 'package:symphia/models/user_profile.dart';
import 'package:symphia/services/database_service.dart';

class InterestPage extends StatefulWidget {
  const InterestPage({super.key});

  @override
  _InterestPageState createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  final List<String> sports = [
    'Athletics',
    'Badminton',
    'Baseball',
    'Basketball',
    'Bouldering',
    'Bowling',
    'Boxing',
    'Crew',
    'Cricket',
    'Cycling',
    'Football',
    'Go karting',
    'Golf',
    'Gym',
    'Gymnastics',
    'Handball',
    'Hockey',
    'Horse riding',
    'Martial arts',
    'Meditation',
    'Netball',
    'Pilates',
    'Ping pong',
    'Rugby',
    'Running',
    'Skateboarding',
    'Skiing'
  ];

  final List<String> passion = [
    'Travel',
    'Cooking',
    'Gardening',
    'Hiking',
    'Camping',
    'Volunteering',
    'Entrepreneurship',
    'Gaming',
    'Fishing',
    'Collecting',
    'Woodworking',
    'Painting',
    'Sculpting',
    'Knitting',
    'Sewing',
    'Calligraphy'
  ];

  final List<String> creativity = [
    'Painting',
    'Drawing',
    'Sculpting',
    'Pottery',
    'Graphic Design',
    'Illustration',
    'Photography',
    'Filmmaking',
    'Creative Writing',
    'Poetry',
    'Songwriting',
    'Composing',
    'Dance',
    'Theater',
    'Improv',
    'Coding',
    'Web Development'
  ];

  final List<String> interestsAndHobbies = [
    'Photography',
    'Art',
    'Crafts',
    'Dancing',
    'Design',
    'Make-up',
    'Making videos',
    'Singing',
    'Writing'
  ];

  final List<String> musicGenre = [
    'Rock',
    'Pop',
    'Hip Hop',
    'R&B',
    'Country',
    'Jazz',
    'Classical',
    'Blues',
    'Reggae',
    'Electronic',
    'Metal',
    'Indie',
    'Folk',
    'Punk',
    'Rap',
    'Soul'
  ];

  final List<String> bookGenre = [
    'Fiction',
    'Non-Fiction',
    'Mystery',
    'Romance',
    'Sci-Fi',
    'Fantasy',
    'Thriller',
    'Historical Fiction',
    'Biography',
    'Self-Help',
    'Poetry',
    'Classics',
    'Horror',
    'Young Adult',
    'Autobiography',
    'Memoir'
  ];

  final List<String> movieGenre = [
    'Action',
    'Adventure',
    'Comedy',
    'Drama',
    'Romance',
    'Horror',
    'Sci-Fi',
    'Fantasy',
    'Thriller',
    'Documentary',
    'Animation',
    'Crime',
    'War',
    'Western',
    'Mystery',
    'Musical'
  ];

  final List<String> relationshipStatus = [
    'Single',
    'In a Relationship',
    'Married',
    'Divorced',
    'Widowed',
    'It\'s Complicated'
  ];

  final List<String> preferredCommunicationStyle = [
    'Formal',
    'Casual',
    'Humorous'
  ];

  final selectedInterests = {
    'Sports':
        Get.find<UserController>().selectedInterests.obs.value['Sports'] ?? {},
    'Interests and Hobbies': Get.find<UserController>()
            .selectedInterests
            .obs
            .value['Interests and Hobbies'] ??
        {},
    'Preferred Communication Style': Get.find<UserController>()
            .selectedInterests
            .obs
            .value['Preferred Communication Style'] ??
        {},
    'Passion':
        Get.find<UserController>().selectedInterests.obs.value['Passion'] ?? {},
    'Creativity':
        Get.find<UserController>().selectedInterests.obs.value['Creativity'] ??
            {},
    'Music Genre':
        Get.find<UserController>().selectedInterests.obs.value['Music Genre'] ??
            {},
    'Book Genre':
        Get.find<UserController>().selectedInterests.obs.value['Book Genre'] ??
            {},
    'Movie Genre':
        Get.find<UserController>().selectedInterests.obs.value['Movie Genre'] ??
            {},
    'Relationship Status': Get.find<UserController>()
            .selectedInterests
            .obs
            .value['Relationship Status'] ??
        {},
  };

  final Map<String, bool> showMore = {
    'Sports': false,
    'Interests and Hobbies': false,
    'Preferred Communication Style': false,
    'Passion': false,
    'Creativity': false,
    'Music Genre': false,
    'Book Genre': false,
    'Movie Genre': false,
    'Relationship Status': false,
  };

  static const totalChipCount = 10;

  Widget buildInterestSection(String title, List<String> interests) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: interests
                .asMap()
                .entries
                .where((entry) =>
                    (showMore[title] ?? false) || entry.key < totalChipCount)
                .map((entry) {
              String interest = entry.value;
              return ChoiceChip(
                label: Text(interest),
                selected: selectedInterests[title]?.contains(interest) ?? false,
                showCheckmark: false,
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedInterests[title]?.add(interest);
                    } else {
                      selectedInterests[title]?.remove(interest);
                    }
                  });
                  Get.find<UserController>().selectedInterests.value =
                      selectedInterests;
                },
              );
            }).toList(),
          ),
        ),
        if (interests.length > totalChipCount)
          TextButton(
            child: Center(
              child:
                  Text((showMore[title] ?? false) ? 'Show less' : 'Show more'),
            ),
            onPressed: () {
              setState(() {
                showMore[title] = !(showMore[title] ?? false);
              });
            },
          )
        else
          TextButton(
            child: const Center(
              child: Text(''),
            ),
            onPressed: () {},
          ),
        // const Divider(color: Colors.grey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 16, 30, 16),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'About Me',
                        style: TextStyle(fontSize: 50.0),
                      ),
                    ),
                    buildInterestSection('Preferred Communication Style',
                        preferredCommunicationStyle),
                    buildInterestSection(
                        'Interests and Hobbies', interestsAndHobbies),
                    buildInterestSection('Sports', sports),
                    buildInterestSection('Passion', passion),
                    buildInterestSection('Creativity', creativity),
                    buildInterestSection('Music Genre', musicGenre),
                    buildInterestSection('Book Genre', bookGenre),
                    buildInterestSection('Movie Genre', movieGenre),
                    buildInterestSection(
                        'Relationship Status', relationshipStatus),
                    const SizedBox(
                      height: 60,
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      height: 50.0,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.purple,
                            Colors.deepPurple,
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            UserController userController =
                                Get.find<UserController>();
                            DatabaseService databaseService =
                                Get.find<DatabaseService>();

                            UserProfile userProfile = UserProfile(
                              uid: databaseService.currentUid!,
                              name: userController.name.value,
                              birthday:
                                  DateTime.parse(userController.birthday.value),
                              preferences: userController.selectedInterests.map(
                                  (key, value) =>
                                      MapEntry(key, value.toList())),
                            );

                            await databaseService.createUser(userProfile);

                            Get.offAllNamed('/main');
                          },
                          child: Center(
                            child: Center(
                              child: Text(
                                selectedInterests.values
                                        .any((set) => set.isNotEmpty)
                                    ? 'CONTINUE'
                                    : 'SKIP',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
