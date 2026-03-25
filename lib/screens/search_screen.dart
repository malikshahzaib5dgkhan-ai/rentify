import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../config/app_colors.dart';
import '../providers/property_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  double _minPrice = 0;
  double _maxPrice = 10000;
  String _propertyType = 'all';
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final propertyProvider = context.watch<PropertyProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 40,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'Search Properties',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              // Search bar
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  context.read<PropertyProvider>().searchProperties(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search by location or property type...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<PropertyProvider>().searchProperties('');
                          },
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 20),

              // Filter toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Results: ${propertyProvider.properties.length}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isMobile)
                    IconButton(
                      icon: Icon(
                        _showFilters ? Icons.filter_list : Icons.tune,
                        color: _showFilters ? AppColors.primary : AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() => _showFilters = !_showFilters);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 20),

              // Filters and Results
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showFilters) ...[
                      _FilterPanel(
                        minPrice: _minPrice,
                        maxPrice: _maxPrice,
                        propertyType: _propertyType,
                        onPriceChanged: (min, max) {
                          setState(() {
                            _minPrice = min;
                            _maxPrice = max;
                          });
                          context.read<PropertyProvider>().filterByPrice(min, max);
                        },
                        onPropertyTypeChanged: (value) {
                          setState(() => _propertyType = value ?? 'all');
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                    _PropertyList(properties: propertyProvider.properties),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Filters (desktop)
                    Expanded(
                      flex: 1,
                      child: _FilterPanel(
                        minPrice: _minPrice,
                        maxPrice: _maxPrice,
                        propertyType: _propertyType,
                        onPriceChanged: (min, max) {
                          setState(() {
                            _minPrice = min;
                            _maxPrice = max;
                          });
                          context.read<PropertyProvider>().filterByPrice(min, max);
                        },
                        onPropertyTypeChanged: (value) {
                          setState(() => _propertyType = value ?? 'all');
                        },
                      ),
                    ),
                    const SizedBox(width: 30),
                    // Properties grid
                    Expanded(
                      flex: 2,
                      child: _PropertyList(properties: propertyProvider.properties),
                    ),
                  ],
                ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}

class _FilterPanel extends StatefulWidget {
  final double minPrice;
  final double maxPrice;
  final String propertyType;
  final Function(double, double) onPriceChanged;
  final Function(String?) onPropertyTypeChanged;

  const _FilterPanel({
    required this.minPrice,
    required this.maxPrice,
    required this.propertyType,
    required this.onPriceChanged,
    required this.onPropertyTypeChanged,
  });

  @override
  State<_FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<_FilterPanel> {
  late double _tempMinPrice;
  late double _tempMaxPrice;

  @override
  void initState() {
    super.initState();
    _tempMinPrice = widget.minPrice;
    _tempMaxPrice = widget.maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filters',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            // Price Range
            Text(
              'Price Range',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${_tempMinPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '\$${_tempMaxPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            RangeSlider(
              values: RangeValues(_tempMinPrice, _tempMaxPrice),
              min: 0,
              max: 10000,
              onChanged: (RangeValues values) {
                setState(() {
                  _tempMinPrice = values.start;
                  _tempMaxPrice = values.end;
                });
                widget.onPriceChanged(values.start, values.end);
              },
            ),
            const SizedBox(height: 20),

            // Property Type
            Text(
              'Property Type',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['all', 'apartment', 'house', 'studio', 'penthouse']
                  .map((type) => FilterChip(
                selected: widget.propertyType == type,
                label: Text(type[0].toUpperCase() + type.substring(1)),
                onSelected: (selected) {
                  widget.onPropertyTypeChanged(selected ? type : 'all');
                },
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),

            // Reset button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _tempMinPrice = 0;
                    _tempMaxPrice = 10000;
                  });
                  context.read<PropertyProvider>().resetFilters();
                  widget.onPriceChanged(0, 10000);
                  widget.onPropertyTypeChanged('all');
                },
                child: const Text('Reset Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyList extends StatelessWidget {
  final List properties;

  const _PropertyList({required this.properties});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (properties.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 80,
                color: AppColors.primary.withOpacity(0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No properties found',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: properties.length,
      itemBuilder: (context, index) {
        return PropertyCard(property: properties[index]);
      },
    );
  }
}

class PropertyCard extends StatelessWidget {
  final dynamic property;

  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/property/${property.id}'),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    color: AppColors.divider,
                  ),
                  child: Image.network(
                    property.imageUrls.first,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(
                          Icons.home,
                          size: 60,
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Available',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${property.price.toStringAsFixed(0)}/month',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      property.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property.location,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.bed,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property.bedrooms.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.bathtub,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              property.bathrooms.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Icon(
                              Icons.aspect_ratio,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${property.area}m²',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
