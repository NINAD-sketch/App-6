// screens/quote_joke_screen.dart - UPDATED VERSION
import 'package:flutter/material.dart';
import 'package:multi_api_flutter_app/models/joke_model.dart';
import 'package:multi_api_flutter_app/models/qoute_model.dart';
import 'package:multi_api_flutter_app/services/joke_service.dart';
import 'package:multi_api_flutter_app/services/qoute_service.dart';

class QuoteJokeScreen extends StatefulWidget {
  const QuoteJokeScreen({super.key});

  @override
  _QuoteJokeScreenState createState() => _QuoteJokeScreenState();
}

class _QuoteJokeScreenState extends State<QuoteJokeScreen>
    with SingleTickerProviderStateMixin {
  final QuoteService _quoteService = QuoteService();
  final JokeService _jokeService = JokeService();

  Quote? currentQuote;
  Joke? currentJoke;
  bool isLoadingQuote = false;
  bool isLoadingJoke = false;
  String quoteError = '';
  String jokeError = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Test API connection first, then fetch data
    _testApiAndFetch();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Test API connection first, then fetch data
  Future<void> _testApiAndFetch() async {
    print('Testing API connection...');
    final isConnected = await _quoteService.testApiConnection();
    print('API Connection Test Result: $isConnected');

    _fetchQuote();
    _fetchJoke();
  }

  Future<void> _fetchQuote() async {
    print('Starting to fetch quote...');
    setState(() {
      isLoadingQuote = true;
      quoteError = '';
    });

    try {
      final quote = await _quoteService.getRandomQuote();
      print('Quote fetched successfully: ${quote.content}');
      setState(() {
        currentQuote = quote;
        isLoadingQuote = false;
      });
    } catch (e) {
      print('Error fetching quote: $e');
      setState(() {
        quoteError = 'Error loading quote: ${e.toString()}';
        isLoadingQuote = false;
      });
    }
  }

  Future<void> _fetchJoke() async {
    setState(() {
      isLoadingJoke = true;
      jokeError = '';
    });

    try {
      final joke = await _jokeService.getRandomJoke();
      setState(() {
        currentJoke = joke;
        isLoadingJoke = false;
      });
    } catch (e) {
      setState(() {
        jokeError = e.toString();
        isLoadingJoke = false;
      });
    }
  }

  Future<void> _refreshBoth() async {
    await Future.wait([_fetchQuote(), _fetchJoke()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshBoth,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildQuoteSection(),
                const SizedBox(height: 30),
                _buildJokeSection(),
                const SizedBox(height: 30),
                _buildActionButtons(),
                // Add debug section
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteSection() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.purple[400]!, Colors.purple[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quote of the Day',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _fetchQuote,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isLoadingQuote)
                  SizedBox(
                    height: 100,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                else if (quoteError.isNotEmpty)
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.white70, size: 30),
                          const SizedBox(height: 8),
                          Text(
                            quoteError,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _fetchQuote,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.purple,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (currentQuote != null)
                  _buildQuoteContent()
                else
                  SizedBox(
                    height: 100,
                    child: const Center(
                      child: Text(
                        'No quote available',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuoteContent() {
    return Column(
      children: [
        const Icon(
          Icons.format_quote,
          size: 40,
          color: Colors.white70,
        ),
        const SizedBox(height: 16),
        Text(
          currentQuote!.content,
          style: const TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            color: Colors.white,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '- ${currentQuote!.author}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        // Updated to show category instead of tags
        if (currentQuote!.category.isNotEmpty) ...[
          const SizedBox(height: 16),
          Chip(
            label: Text(
              currentQuote!.category.toUpperCase(),
              style: TextStyle(fontSize: 12, color: Colors.purple[700]),
            ),
            backgroundColor: Colors.white.withOpacity(0.9),
          ),
        ],
      ],
    );
  }

  // Add debug section to help troubleshoot

  Widget _buildJokeSection() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.orange[400]!, Colors.orange[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Random Joke',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: _fetchJoke,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (isLoadingJoke)
                  SizedBox(
                    height: 100,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                else if (jokeError.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        jokeError,
                        style: const TextStyle(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else if (currentJoke != null)
                  _buildJokeContent()
                else
                  SizedBox(
                    height: 100,
                    child: const Center(
                      child: Text(
                        'No joke available',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJokeContent() {
    return Column(
      children: [
        const Icon(
          Icons.sentiment_very_satisfied,
          size: 40,
          color: Colors.white70,
        ),
        const SizedBox(height: 16),
        if (currentJoke!.type == 'single')
          Text(
            currentJoke!.joke,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          )
        else
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentJoke!.setup,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentJoke!.delivery,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Category: ${currentJoke!.category}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _fetchQuote,
            icon: const Icon(Icons.format_quote),
            label: const Text('New Quote'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _fetchJoke,
            icon: const Icon(Icons.sentiment_very_satisfied),
            label: const Text('New Joke'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
