import 'model_quote.dart';

class ModelCrypto {
  int id;
  String name;
  String symbol;
  String? lastUpdated;
  num? totalSupply;
  ModelQuoteData quoteData;

  ModelCrypto({
    required this.id,
    required this.name,
    required this.symbol,
    required this.totalSupply,
    required this.lastUpdated,
    required this.quoteData
  });

  factory ModelCrypto.fromJSON( Map<String,dynamic> json ) {
    return ModelCrypto(
        id         : json[ "id"           ],
        name       : json[ "name"         ],
        symbol     : json[ "symbol"       ],
        totalSupply: json[ "total_supply" ],
        lastUpdated: json[ "last_updated" ],
        quoteData  : ModelQuoteData.fromJSON ( json [ "quote" ]["USD"] )
    );
  }

}