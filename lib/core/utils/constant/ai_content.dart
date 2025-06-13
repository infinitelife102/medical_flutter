import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../cache/cache.dart';

class AiConstantsContent {
  const AiConstantsContent._();

  static List<Content> content = [
    Content.text(dotenv.env['TEXT_1']!),
    Content.text(dotenv.env['TEXT_2']!),
    Content.text(dotenv.env['TEXT_3']!),
    Content.text(dotenv.env['TEXT_4']!),
    Content.text(dotenv.env['TEXT_5']!),
    Content.text(dotenv.env['TEXT_6']!),
    Content.text(dotenv.env['TEXT_7']!),
    Content.text(dotenv.env['TEXT_8']!),
    Content.text(dotenv.env['TEXT_9']!),
    // Content.text(dotenv.env['TEXT_10']!),
    Content.text((CacheData.getMapData(key: "userData"))["name"] ??
        "User"),
  ];
}
