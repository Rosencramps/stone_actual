final List<Profile> demoProfiles = [
  new Profile(
    photos: [
      'images/GodT3.png',
      'images/GodT1.jpg',
      'images/GodT2.jpg',
    ],
    name: 'God Tongue',
  ),
];

class Profile {
  final List<String> photos;
  final String name;

  Profile({
    this.photos,
    this.name
  });
}