import '../app/controllers/network/exception_handler.dart';
import '../models/news_model.dart';
import '../utills/constants.dart';
import 'package:http/http.dart' as http;

class NewsService {
  NewsService();

  Future<List<NewsModel>> fetchNews() async {
    final url = Uri.parse('$baseUrl/news?category=general&token=$apiKey');

    try {
      final data = await ApiExceptionHandler.handleApiCall(http.get(url));
      // Map the JSON response to NewsModel
      return (data as List).map((e) => NewsModel.fromJson(e)).toList();
    } on ApiException catch (e) {
      // Handle the ApiException by displaying the error message or logging it
      throw Exception(e.message);
    }
  }
}
