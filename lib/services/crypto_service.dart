import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_model.dart';

class CryptoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  // Note: API key is not required for free tier, but can be added for pro tier
  // static const String _apiKey = 'CG-E188mzwFYpC7MHrGCZ234rUt';

  Future<List<Crypto>> getCryptos() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=false'),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'Flutter App',
          // API key not needed for free tier
          // 'x-api-key': _apiKey,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Crypto.fromJson(json)).toList();
      } else if (response.statusCode == 429) {
        // Rate limit exceeded, return demo data
        return _getDemoCryptos();
      } else {
        throw Exception(
            'API Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Crypto API Error: $e');
      // Return demo data if API fails
      return _getDemoCryptos();
    }
  }

  List<Crypto> _getDemoCryptos() {
    return [
      Crypto(
        id: 'bitcoin',
        name: 'Bitcoin',
        symbol: 'BTC',
        image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
        currentPrice: 45000.0,
        priceChangePercentage24h: 2.5,
        marketCap: 850000000000.0,
        marketCapRank: 1,
      ),
      Crypto(
        id: 'ethereum',
        name: 'Ethereum',
        symbol: 'ETH',
        image:
            'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
        currentPrice: 3200.0,
        priceChangePercentage24h: -1.8,
        marketCap: 380000000000.0,
        marketCapRank: 2,
      ),
      Crypto(
        id: 'binancecoin',
        name: 'BNB',
        symbol: 'BNB',
        image:
            'https://assets.coingecko.com/coins/images/825/large/bnb-icon2_2x.png',
        currentPrice: 320.0,
        priceChangePercentage24h: 1.2,
        marketCap: 48000000000.0,
        marketCapRank: 3,
      ),
      Crypto(
        id: 'solana',
        name: 'Solana',
        symbol: 'SOL',
        image:
            'https://assets.coingecko.com/coins/images/4128/large/solana.png',
        currentPrice: 180.0,
        priceChangePercentage24h: 4.8,
        marketCap: 42000000000.0,
        marketCapRank: 4,
      ),
      Crypto(
        id: 'ripple',
        name: 'XRP',
        symbol: 'XRP',
        image:
            'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png',
        currentPrice: 0.65,
        priceChangePercentage24h: -0.8,
        marketCap: 36000000000.0,
        marketCapRank: 5,
      ),
    ];
  }
}
