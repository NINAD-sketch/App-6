// screens/crypto_screen.dart
import 'package:flutter/material.dart';
import 'package:multi_api_flutter_app/Widgets.dart';
import 'dart:async';
import '../services/crypto_service.dart';
import '../models/crypto_model.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  _CryptoScreenState createState() => _CryptoScreenState();
}

class _CryptoScreenState extends State<CryptoScreen> {
  final CryptoService _cryptoService = CryptoService();
  List<Crypto> cryptos = [];
  bool isLoading = false;
  String error = '';
  Timer? _refreshTimer;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _fetchCryptos();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _fetchCryptos();
      }
    });
  }

  Future<void> _fetchCryptos() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final fetchedCryptos = await _cryptoService.getCryptos();
      setState(() {
        cryptos = fetchedCryptos;
        isLoading = false;
        _lastUpdated = DateTime.now();
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          if (error.isNotEmpty)
            ErrorBanner(
              message: error,
              color: Colors.red,
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchCryptos,
              child: _buildCryptoList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchCryptos,
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[400]!, Colors.green[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Live Crypto Prices',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_lastUpdated != null)
            Text(
              'Updated: ${_formatTime(_lastUpdated!)}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildCryptoList() {
    if (isLoading && cryptos.isEmpty) {
      return const LoadingWidget();
    }

    if (cryptos.isEmpty && error.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.currency_bitcoin, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No crypto data available',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemCount: cryptos.length,
      itemBuilder: (context, index) {
        return _buildCryptoCard(cryptos[index]);
      },
    );
  }

  Widget _buildCryptoCard(Crypto crypto) {
    final isPositive = crypto.priceChangePercentage24h >= 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[100],
          child: crypto.image.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    crypto.image,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.currency_bitcoin,
                          color: Colors.orange);
                    },
                  ),
                )
              : const Icon(Icons.currency_bitcoin, color: Colors.orange),
        ),
        title: Text(
          crypto.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              crypto.symbol.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${crypto.currentPrice.toStringAsFixed(crypto.currentPrice < 1 ? 6 : 2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPositive ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isPositive ? Colors.green[200]! : Colors.red[200]!,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green[700] : Colors.red[700],
                size: 20,
              ),
              Text(
                '${isPositive ? '+' : ''}${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: isPositive ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        onTap: () => _showCryptoDetails(crypto),
      ),
    );
  }

  void _showCryptoDetails(Crypto crypto) {
    final isPositive = crypto.priceChangePercentage24h >= 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              if (crypto.image.isNotEmpty)
                Image.network(
                  crypto.image,
                  width: 30,
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.currency_bitcoin);
                  },
                ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${crypto.name} (${crypto.symbol.toUpperCase()})',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                'Current Price',
                '\$${crypto.currentPrice.toStringAsFixed(crypto.currentPrice < 1 ? 6 : 2)}',
                Icons.attach_money,
              ),
              _buildDetailRow(
                '24h Change',
                '${isPositive ? '+' : ''}${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
              ),
              _buildDetailRow(
                'Market Cap',
                '\$${_formatLargeNumber(crypto.marketCap)}',
                Icons.show_chart,
              ),
              _buildDetailRow(
                'Rank',
                '#${crypto.marketCapRank}',
                Icons.leaderboard,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  String _formatLargeNumber(double number) {
    if (number >= 1e12) {
      return '${(number / 1e12).toStringAsFixed(2)}T';
    } else if (number >= 1e9) {
      return '${(number / 1e9).toStringAsFixed(2)}B';
    } else if (number >= 1e6) {
      return '${(number / 1e6).toStringAsFixed(2)}M';
    } else if (number >= 1e3) {
      return '${(number / 1e3).toStringAsFixed(2)}K';
    } else {
      return number.toStringAsFixed(2);
    }
  }
}
