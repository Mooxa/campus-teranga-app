import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/formation.dart';
import '../services/api_service.dart';

class FormationsScreen extends StatefulWidget {
  final String? type;

  const FormationsScreen({super.key, this.type});

  @override
  State<FormationsScreen> createState() => _FormationsScreenState();
}

class _FormationsScreenState extends State<FormationsScreen> {
  final ApiService _apiService = ApiService();
  List<Formation> _formations = [];
  bool _isLoading = true;
  String _selectedFilter = 'Toutes';

  @override
  void initState() {
    super.initState();
    _loadFormations();
  }

  Future<void> _loadFormations() async {
    try {
      final formations = await _apiService.getFormations(type: widget.type);
      setState(() {
        _formations = formations;
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
          'Formations',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _formations.isEmpty
                    ? _buildEmptyState()
                    : _buildFormationsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _buildFilterButton('Toutes', _selectedFilter == 'Toutes'),
          const SizedBox(width: 12),
          _buildFilterButton('Universités publiques', _selectedFilter == 'Universités publiques'),
          const SizedBox(width: 12),
          _buildFilterButton('Privées', _selectedFilter == 'Privées'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = text;
        });
        _filterFormations();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  void _filterFormations() {
    // In a real app, you would filter based on the selected filter
    // For now, we'll just reload all formations
    _loadFormations();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune formation trouvée',
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

  Widget _buildFormationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _formations.length,
      itemBuilder: (context, index) {
        final formation = _formations[index];
        return _buildFormationCard(formation);
      },
    );
  }

  Widget _buildFormationCard(Formation formation) {
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: formation.image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      formation.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.school,
                          color: Colors.grey[400],
                          size: 24,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.school,
                    color: Colors.grey[400],
                    size: 24,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formation.name,
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
                      '${formation.location.city}, ${formation.location.district}',
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
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _showFormationDetails(formation);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
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
    );
  }

  void _showFormationDetails(Formation formation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          formation.name,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Type: ${formation.type}',
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                'Localisation: ${formation.location.city}, ${formation.location.district}',
                style: GoogleFonts.inter(),
              ),
              const SizedBox(height: 8),
              Text(
                'Adresse: ${formation.location.address}',
                style: GoogleFonts.inter(),
              ),
              if (formation.phone.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Téléphone: ${formation.phone}',
                  style: GoogleFonts.inter(),
                ),
              ],
              if (formation.email.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Email: ${formation.email}',
                  style: GoogleFonts.inter(),
                ),
              ],
              if (formation.website.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Site web: ${formation.website}',
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
                formation.description,
                style: GoogleFonts.inter(),
              ),
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
}
