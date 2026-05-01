import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const AIDetectorApp());
}

class AIDetectorApp extends StatelessWidget {
  const AIDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detector de IA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      themeMode: ThemeMode.system,
      home: const AIDetectorScreen(),
    );
  }
}

class AIDetectorScreen extends StatefulWidget {
  const AIDetectorScreen({super.key});

  @override
  State<AIDetectorScreen> createState() => _AIDetectorScreenState();
}

class _AIDetectorScreenState extends State<AIDetectorScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isAnalyzing = false;
  bool _hasResult = false;
  
  // Resultados mock
  double _aiProbability = 0.0;
  double _perplexity = 0.0;
  double _burstiness = 0.0;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _analyzeText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa un texto para analizar.')),
      );
      return;
    }

    // Validación simple de longitud de palabras
    final wordCount = text.split(RegExp(r'\s+')).length;
    if (wordCount < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El texto es muy corto. Ingresa al menos 10 palabras.')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _hasResult = false;
    });

    // Simular un retraso en la red o análisis
    await Future.delayed(const Duration(seconds: 2));

    // Generar métricas simuladas realistas basadas en el texto (determinista)
    final random = Random(text.hashCode); 
    
    // Heurística simple: palabras repetitivas/formales aumentan la puntuación IA
    final aiKeywords = [
      'en conclusión', 'además', 'por lo tanto', 'es importante destacar', 
      'en resumen', 'en primer lugar', 'sin embargo', 'cabe destacar', 'del mismo modo'
    ];
    
    double baseScore = random.nextDouble() * 0.4 + 0.3; // Base aleatoria 30-70%
    
    int hits = 0;
    for (var kw in aiKeywords) {
      if (text.toLowerCase().contains(kw)) {
        baseScore += 0.12;
        hits++;
      }
    }
    
    // Si el texto es extremadamente largo sin "errores" humanos, penalizamos/premiamos acorde
    if (wordCount > 300 && hits > 2) baseScore += 0.1;

    // Asegurar que quede en el rango de 1% a 99%
    baseScore = baseScore.clamp(0.01, 0.99);
    
    setState(() {
      _aiProbability = baseScore;
      _perplexity = random.nextDouble() * 40 + 20; // 20 - 60
      _burstiness = random.nextDouble() * 50 + 10; // 10 - 60
      _isAnalyzing = false;
      _hasResult = true;
    });
  }

  void _clear() {
    _textController.clear();
    setState(() {
      _hasResult = false;
    });
  }

  Color _getResultColor(double probability) {
    if (probability > 0.7) return Colors.red.shade400;
    if (probability > 0.4) return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  String _getResultLabel(double probability) {
    if (probability > 0.7) return 'Altamente probable que sea IA';
    if (probability > 0.4) return 'Posible uso de IA parcial';
    return 'Altamente probable que sea Humano';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detector de Texto IA', style: TextStyle(fontWeight: FontWeight.w600)),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_hasResult || _textController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _clear,
              tooltip: 'Limpiar',
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Analiza textos para descubrir si fueron generados por IA (ChatGPT, Claude, etc.) o escritos por humanos.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Área de entrada de texto
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 10,
                  minLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Pega el artículo, ensayo o texto aquí para analizar su origen...',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  onChanged: (val) {
                    if (_hasResult) setState(() => _hasResult = false);
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botón de acción
              FilledButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeText,
                icon: _isAnalyzing 
                  ? Container(
                      width: 20, 
                      height: 20, 
                      margin: const EdgeInsets.only(right: 8),
                      child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.search),
                label: Text(
                  _isAnalyzing ? 'Analizando patrones...' : 'Analizar Texto',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Área de Resultados
              if (_hasResult) _buildResultsCard(colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCard(ColorScheme colorScheme) {
    final resultColor = _getResultColor(_aiProbability);
    
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: resultColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Resultado del Análisis',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          
          // Puntaje Radial
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: CircularProgressIndicator(
                  value: _aiProbability,
                  strokeWidth: 12,
                  backgroundColor: colorScheme.surfaceVariant,
                  color: resultColor,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(_aiProbability * 100).round()}%',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: resultColor,
                    ),
                  ),
                  Text(
                    'IA',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: resultColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              _getResultLabel(_aiProbability),
              style: TextStyle(
                color: resultColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          
          // Métricas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMetric(
                'Perplejidad', 
                _perplexity.toStringAsFixed(1), 
                'Previsibilidad del texto',
                Icons.psychology_outlined,
              ),
              Container(width: 1, height: 40, color: colorScheme.outlineVariant),
              _buildMetric(
                'Ráfaga', 
                _burstiness.toStringAsFixed(1), 
                'Variación en oraciones',
                Icons.analytics_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String value, String subtitle, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
