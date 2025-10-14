import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service.dart';
import '../services/api_service.dart';

class ServicesScreen extends StatefulWidget {
  final String? category;

  const ServicesScreen({super.key, this.category});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  final ApiService _apiService = ApiService();
  List<Service> _services = [];
  bool _isLoading = true;
  late TabController _tabController;
  String _selectedCategory = '';

  final List<String> _categories = [
    'transport',
    'housing',
    'procedures',
    'health',
  ];

  final Map<String, String> _categoryNames = {
    'transport': 'Transport',
    'housing': 'Logement',
    'procedures': 'Démarches',
    'health': 'Santé',
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category ?? 'transport';
    _tabController = TabController(
      length: _categories.length,
      vsync: this,
      initialIndex: _categories.indexOf(_selectedCategory),
    );
    _tabController.addListener(_onTabChanged);
    _loadServices();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
      _loadServices();
    }
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _apiService.getServicesByCategory(_selectedCategory);
      setState(() {
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Services rapides',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.orange[600],
          labelColor: Colors.orange[600],
          unselectedLabelColor: Colors.grey[600],
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
          tabs: _categories.map((category) => Tab(text: _categoryNames[category]!)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _services.isEmpty
              ? _buildEmptyState()
              : _buildServicesList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getCategoryIcon(_selectedCategory),
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun service trouvé',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Veuillez réessayer plus tard',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(service);
      },
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getCategoryColor(service.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(service.category),
                  color: _getCategoryColor(service.category),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.red[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${service.location.city}, ${service.location.district}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                '${service.price.amount.toStringAsFixed(0)} ${service.price.currency}',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            service.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (service.rating > 0) ...[
                Icon(Icons.star, size: 16, color: Colors.orange[600]),
                const SizedBox(width: 4),
                Text(
                  service.rating.toStringAsFixed(1),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  _showServiceDetails(service);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Voir détails',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showServiceDetails(Service service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          service.name,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Catégorie: ${_categoryNames[service.category] ?? service.category}',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'Localisation: ${service.location.city}, ${service.location.district}',
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 8),
              Text(
                'Adresse: ${service.location.address}',
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 8),
              Text(
                'Prix: ${service.price.amount.toStringAsFixed(0)} ${service.price.currency}',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              if (service.contact.phone.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Téléphone: ${service.contact.phone}',
                  style: GoogleFonts.inter(),
                ),
              ],
              if (service.contact.email.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Email: ${service.contact.email}',
                  style: GoogleFonts.inter(),
                ),
              ],
              if (service.contact.website.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Site web: ${service.contact.website}',
                  style: GoogleFonts.inter(),
                ),
              ],
              const SizedBox(height: 12),
              Text(
                'Description:',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                service.description,
                style: GoogleFonts.inter(),
              ),
              if (service.features.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Caractéristiques:',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                ...service.features.map((feature) => Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Text(
                    '• $feature',
                    style: GoogleFonts.inter(),
                  ),
                )),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Fermer',
              style: GoogleFonts.inter(color: Colors.orange[600]),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'transport':
        return Icons.directions_car;
      case 'housing':
        return Icons.home;
      case 'procedures':
        return Icons.description;
      case 'health':
        return Icons.medical_services;
      default:
        return Icons.help;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'transport':
        return Colors.blue[600]!;
      case 'housing':
        return Colors.green[600]!;
      case 'procedures':
        return Colors.orange[600]!;
      case 'health':
        return Colors.red[600]!;
      default:
        return Colors.grey[600]!;
    }
  }
}
