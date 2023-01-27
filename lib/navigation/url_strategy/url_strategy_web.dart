import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void setUrlStrategyTo(String strategy_name) {
  dynamic strategy;

  switch (strategy_name) {
    case 'hash':
      strategy = setHashUrlStrategy();
      break;
    case 'path':
      strategy = setPathUrlStrategy();
      break;
    default:
      throw Exception('Unknown URL strategy: $strategy');
  }

  setUrlStrategy(strategy);
}
