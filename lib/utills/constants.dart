import 'package:flutter_dotenv/flutter_dotenv.dart';

final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
final String apiKey = dotenv.env['API_KEY'] ?? '';