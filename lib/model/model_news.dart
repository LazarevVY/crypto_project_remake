class ModelNews {
// ======= response format =======
// /* [ ] */ "id": "27724692",
// /* [+] */ "guid": "https://cointelegraph.com/news/elusive-bitcoin-etf-hester-perice-criticizes-lack-of-legal-clarity-for-crypto",
// /* [+] */ "published_on": 1655472180,
// /* [+] */ "imageurl": "https://images.cryptocompare.com/news/default/cointelegraph.png",
// /* [+] */ "title": "Elusive Bitcoin ETF: Hester Perice criticizes lack of legal clarity for crypto",
// /* [+] */ "url": "https://cointelegraph.com/news/elusive-bitcoin-etf-hester-perice-criticizes-lack-of-legal-clarity-for-crypto",
// /* [+] */ "source": "cointelegraph",
// /* [+] */ "body": "SEC Commissioner and Crypto Mom Hester Peirce criticized the SEC on its regulatory guidance, but noted that change is possible if investors and regulators work together.",
// /* [ ] */ "tags": "Cryptocurrencies|Investments|United States|Government|Bitcoin Regulation|Stablecoin|Decentralization|Decentralized Exchange|SEC|Law",
// /* [+] */ "categories": "Regulation|BTC|Business",
// /* [ ] */ "upvotes": "0",
// /* [ ] */ "downvotes": "0",
// /* [ ] */ "lang": "EN",
// /* [+] */ "source_info": {
// /* [+] */ "name": "CoinTelegraph",
// /* [ ] */ "lang": "EN",
// /* [+] */ "img": "https://images.cryptocompare.com/news/default/cointelegraph.png"
// }

  final String guid;
  final int    publishedOn;
  final String imageURL;
  final String title;
  final String url;
  final String source;
  final String body;
  final String categories;
  final SourceInfo sourceInfo;

  // Constructor
  ModelNews({
    required this.guid,
    required this.publishedOn,
    required this.imageURL,
    required this.title,
    required this.url,
    required this.source,
    required this.body,
    required this.categories,
    required this.sourceInfo
  });

  factory ModelNews.fromJSON (Map<String, dynamic> json) {
    return ModelNews(
        guid:        json[ "guid"         ] as String,
        publishedOn: json[ "published_on" ] as int,
        imageURL:    json[ "imageurl"     ] as String,
        title:       json[ "title"        ] as String,
        url:         json[ "url"          ] as String,
        source:      json[ "source"       ] as String,
        body:        json[ "body"         ] as String,
        categories:  json[ "categories"   ] as String,
        sourceInfo:  SourceInfo.fromJSON( json [ "source_info" ] )
    );
  }
}

class SourceInfo {
// /* [+] */ "name": "Sring",
// /* [ ] */ "lang": "EN",
// /* [+] */ "img": "URL"
  final String name;
  final String img;

  SourceInfo ({
    required this.name,
    required this.img
  });

  factory SourceInfo.fromJSON (Map<String, dynamic> json) {
    return SourceInfo(
        name: json[ "name" ] as String,
        img: json[ "img"  ] as String
    );
  }
}