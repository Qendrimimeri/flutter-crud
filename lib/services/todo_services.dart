import 'package:http/http.dart' as http;

class ToDoServices {
  static Future<bool> deleteItem(String id) async {
    final url = Uri.parse("https://api.nstack.in/v1/todos/$id");
    http.Response response = await http.delete(url);
    if (response == 200) {
      return true;
    } else {
      return false;
    }
  }
}
