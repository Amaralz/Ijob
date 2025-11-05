class Stringreplacer {
  static String toUrl(String old) {
    String newString = old.replaceAll(" ", "+");
    return newString;
  }

  static String fromUrl(String old) {
    String newString = old.replaceAll("+", " ");
    return newString;
  }
}
