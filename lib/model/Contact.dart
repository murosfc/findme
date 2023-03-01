class Contact {
  final int idGoogle;
  final String name;
  final String email;
  final String pictureURL;

  Contact(this.idGoogle, this.name, this.email, this.pictureURL);

  String getFirstNameLetter() {
    return name[0];
  }
}
