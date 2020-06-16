class User {
  final String uid;
  bool isEmailVerified = false;
  final String creationTimeStamp;
  final String lastSignInTimeStamp;

  User({
    this.uid,
    this.isEmailVerified,
    this.creationTimeStamp,
    this.lastSignInTimeStamp
  });
}


class UserData {
  final String uid;
  final String email;
  final String nickname;
  final String location;
  final int age;
  final String gender;
  final String occupation;
  final String about;
  final bool yodeling;
  final bool shopping;
  final bool makingBalloonAnimals;
  final bool cooking;
  final bool painting;
  final bool movies;
  final bool sports;
  final bool writing;
  final bool drinking;
  final int matches;
  final String imgUrl;
  final String matchID;
  final String chatID;
  final String bed;
  final String reviews;
  final String foreverEat;
  final String bestForLast;
  final String aliens;
  final String genderPreference;
  final double highAge;
  final double lowAge;

  UserData(
      {this.uid,
      this.email,
      this.nickname,
      this.location,
      this.age,
      this.gender,
      this.occupation,
      this.about,
      this.yodeling,
      this.shopping,
      this.makingBalloonAnimals,
      this.cooking,
      this.painting,
      this.movies,
      this.sports,
      this.writing,
      this.drinking,
      this.matches,
      this.imgUrl,
      this.matchID,
      this.chatID,
      this.bed,
      this.reviews,
      this.foreverEat,
      this.bestForLast,
      this.aliens,
        this.genderPreference,
        this.highAge,
        this.lowAge,
      });
}

class UserImg {
  final String imgUrl;

  UserImg({
    this.imgUrl,
  });
}

class Preferences {
  double lowValue;
  double highValue;
  String genderPreference;

  Preferences({
    this.lowValue,
    this.highValue,
    this.genderPreference
});
}

class Answers {
  String bed;
  String reviews;
  String foreverEat;
  String bestForLast;
  String aliens;

  Answers({
    this.bed,
    this.reviews,
    this.foreverEat,
    this.bestForLast,
    this.aliens
});
}
