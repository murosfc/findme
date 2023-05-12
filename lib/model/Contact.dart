class Contact {
  final int id;
  final String name;
  final String familyName;
  final String pictureURL;

  Contact(this.id, this.name, this.familyName, this.pictureURL);

  String getFirstNamesLetters() {
    return name[0] + familyName[0];
  }
}
