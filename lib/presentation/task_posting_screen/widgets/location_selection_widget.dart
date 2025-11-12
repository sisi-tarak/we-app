import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSelectionWidget extends StatefulWidget {
  final String? selectedLocation;
  final Function(String) onLocationSelected;

  const LocationSelectionWidget({
    Key? key,
    this.selectedLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  bool _isLoadingLocation = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
        color: AppTheme.lightTheme.colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Task Location',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (widget.selectedLocation != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'place',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      widget.selectedLocation!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onPrimaryContainer,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isLoadingLocation ? null : _useCurrentLocation,
                  icon: _isLoadingLocation
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'my_location',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                  label: Text(
                    _isLoadingLocation ? 'Getting Location...' : 'Use Current',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _chooseDifferentLocation,
                  icon: CustomIconWidget(
                    iconName: 'map',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text(
                    'Choose Different',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Simulate getting current location
      await Future.delayed(const Duration(seconds: 2));

      // Mock current location
      const mockLocation = "123 Main Street, Downtown, New York, NY 10001";
      widget.onLocationSelected(mockLocation);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to get current location. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  void _chooseDifferentLocation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Choose Location',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for an address...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: _mockLocations.length,
                itemBuilder: (context, index) {
                  final location = _mockLocations[index];
                  return ListTile(
                    leading: CustomIconWidget(
                      iconName: 'place',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    title: Text(
                      location['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    subtitle: Text(
                      location['address'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                    onTap: () {
                      widget.onLocationSelected(
                          '${location['name']}, ${location['address']}');
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Map<String, String>> _mockLocations = [
    {
      'name': 'Central Park',
      'address': '59th St to 110th St, New York, NY',
    },
    {
      'name': 'Times Square',
      'address': 'Broadway & 7th Ave, New York, NY 10036',
    },
    {
      'name': 'Brooklyn Bridge',
      'address': 'Brooklyn Bridge, New York, NY 10038',
    },
    {
      'name': 'Empire State Building',
      'address': '350 5th Ave, New York, NY 10118',
    },
    {
      'name': 'Statue of Liberty',
      'address': 'Liberty Island, New York, NY 10004',
    },
  ];
}