class AppStrings {
  final textScreenStartAppBarTitle = 'Kryptowährung beobachter';
  final urlNews = 'https://min-api.cryptocompare.com/data/v2/news/?lang=EN';
  final urlCoins = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=5000&convert=USD';
  final headersCoins = {'Accept' : 'application/json' , 'X-CMC_PRO_API_KEY' : ''};
  final urlSandBox = 'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest/?start=1&limit=1&convert=USD';//5000
  final headersSandBox = {'Accept' : 'application/json' , 'X-CMC_PRO_API_KEY' : 'b54bcf4d-1bca-4e8e-9a24-22ff2c3d462c'};
  final textScreenNewsNoAvailable = 'No News Available';
  final textScreenNewsButtonOpenURL = 'Weiter lesen';
}