///Text Editing
class TextEditing {
  ///Capitalize First Letter
  static String capitalizeFirstLetter({required String input}) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
