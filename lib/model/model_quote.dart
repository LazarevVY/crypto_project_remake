class ModelQuoteData {
  // "price": 446022.7284582002,
  // "volume_24h": 319007246257.4999,
  // "percent_change_1h": 0.057,
  // "percent_change_24h": 4.9421,
  // "percent_change_7d": -3.5347,
  // "market_cap": 7676240716425.219,
  // "last_updated": "2018-08-15T06:45:10.000Z"

  num? price;
  num? percentHour;
  num? percentDay;
  num? percentWeek;
  num? marketCap;
  num? volumeDay;
  String? lastUpdated;

  ModelQuoteData({
    required this.price,
    required this.percentHour,
    required this.percentDay,
    required this.percentWeek,
    required this.volumeDay,
    required this.marketCap,
    required this.lastUpdated
  });

  factory ModelQuoteData.fromJSON ( Map<String,dynamic> json ){
    return ModelQuoteData(
        price       : json[ "price"              ],
        percentHour : json[ "percent_change_1h"  ],
        percentDay  : json[ "percent_change_24h" ],
        percentWeek : json[ "percent_change_7d"  ],
        volumeDay   : json[ "volume_24h"         ],
        marketCap   : json[ "market_cap"         ],
        lastUpdated : json[ "last_updated"       ]);
  }
}