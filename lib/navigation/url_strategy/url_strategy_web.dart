import 'package:flutter_web_plugins/url_strategy.dart';

void setUrlStrategyTo(String strategyName) {
  UrlStrategy strategy;

  switch (strategyName) {
    case 'hash':
      strategy = const HashUrlStrategy();
      break;
    case 'path':
      strategy = PathUrlStrategy();
      break;
    default:
      throw Exception('Unknown URL strategy: $strategyName');
  }

  setUrlStrategy(strategy);
}
