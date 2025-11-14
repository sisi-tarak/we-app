import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../providers/subscription_provider.dart';
import '../subscription/widgets/over_limit_alert_dialog.dart';
import '../subscription/subscription_selection_screen.dart';
import './widgets/category_selection_widget.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/location_selection_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/task_requirements_widget.dart';

class TaskPostingScreen extends StatefulWidget {
  const TaskPostingScreen({Key? key}) : super(key: key);

  @override
  State<TaskPostingScreen> createState() => _TaskPostingScreenState();
}

class _TaskPostingScreenState extends State<TaskPostingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _paymentController = TextEditingController();

  String? _selectedCategory;
  String? _selectedLocation;
  DateTime? _selectedDateTime;
  bool _isASAP = true;
  List<XFile> _selectedImages = [];
  bool _requirementsExpanded = false;
  Map<String, dynamic> _requirements = {};
  bool _hasUnsavedChanges = false;
  bool _isPosting = false;

  final int _maxTitleLength = 80;
  final SubscriptionProvider _subscriptionProvider = SubscriptionProvider();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onFormChanged);
    _descriptionController.addListener(_onFormChanged);
    _paymentController.addListener(_onFormChanged);
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    // Mock user ID - in production, get from auth context
    final userId = '1'; // Replace with actual user ID
    await _subscriptionProvider.fetchSubscriptionStatus(userId);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _paymentController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(),
                  SizedBox(height: 4.h),
                  _buildTitleField(),
                  SizedBox(height: 4.h),
                  _buildCategorySection(),
                  SizedBox(height: 4.h),
                  _buildDescriptionField(),
                  SizedBox(height: 4.h),
                  _buildLocationSection(),
                  SizedBox(height: 4.h),
                  _buildDateTimeSection(),
                  SizedBox(height: 4.h),
                  _buildPaymentSection(),
                  SizedBox(height: 4.h),
                  _buildPhotoSection(),
                  SizedBox(height: 4.h),
                  _buildRequirementsSection(),
                  SizedBox(height: 6.h),
                  _buildActionButtons(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Post a Task',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      leading: IconButton(
        onPressed: () => _onWillPop().then((shouldPop) {
          if (shouldPop) Navigator.pop(context);
        }),
        icon: CustomIconWidget(
          iconName: 'close',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      actions: [
        if (_hasUnsavedChanges)
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: Center(
              child: Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What do you need help with?',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Describe your task and connect with local helpers in your community.',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Task Title',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Text(
              ' *',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _titleController,
          maxLength: _maxTitleLength,
          decoration: InputDecoration(
            hintText: 'e.g., Help me move furniture to my new apartment',
            counterText: '${_titleController.text.length}/$_maxTitleLength',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task title';
            }
            if (value.trim().length < 10) {
              return 'Title must be at least 10 characters';
            }
            return null;
          },
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Category',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Text(
              ' *',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        CategorySelectionWidget(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) {
            setState(() {
              _selectedCategory = category;
              _hasUnsavedChanges = true;
            });
            _suggestPricing(category);
          },
        ),
        if (_selectedCategory == null && _hasUnsavedChanges)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'Please select a category',
              style: AppTheme.lightTheme.inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Description',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Text(
              ' *',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Provide clear details about what you need done',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText:
                'Describe your task in detail...\n\n• What needs to be done?\n• Any specific requirements?\n• What should helpers bring?',
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide a description';
            }
            if (value.trim().length < 20) {
              return 'Description must be at least 20 characters';
            }
            return null;
          },
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Location',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Text(
              ' *',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        LocationSelectionWidget(
          selectedLocation: _selectedLocation,
          onLocationSelected: (location) {
            setState(() {
              _selectedLocation = location;
              _hasUnsavedChanges = true;
            });
          },
        ),
        if (_selectedLocation == null && _hasUnsavedChanges)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'Please select a location',
              style: AppTheme.lightTheme.inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timing',
          style: AppTheme.lightTheme.textTheme.titleSmall,
        ),
        SizedBox(height: 2.h),
        DateTimePickerWidget(
          selectedDateTime: _selectedDateTime,
          isASAP: _isASAP,
          onDateTimeSelected: (dateTime) {
            setState(() {
              _selectedDateTime = dateTime;
              _hasUnsavedChanges = true;
            });
          },
          onASAPChanged: (isASAP) {
            setState(() {
              _isASAP = isASAP;
              _hasUnsavedChanges = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Payment Amount',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            Text(
              ' *',
              style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'This amount will be held in escrow until task completion',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        TextFormField(
          controller: _paymentController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: '\$ ',
            hintText: '0.00',
            suffixIcon: _selectedCategory != null
                ? IconButton(
                    onPressed: () => _suggestPricing(_selectedCategory!),
                    icon: CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  )
                : null,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a payment amount';
            }
            final double? amount = double.tryParse(value);
            if (amount == null || amount <= 0) {
              return 'Please enter a valid amount';
            }
            if (amount < 5) {
              return 'Minimum amount is \$5.00';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return PhotoUploadWidget(
      selectedImages: _selectedImages,
      onImagesChanged: (images) {
        setState(() {
          _selectedImages = images;
          _hasUnsavedChanges = true;
        });
      },
    );
  }

  Widget _buildRequirementsSection() {
    return TaskRequirementsWidget(
      isExpanded: _requirementsExpanded,
      onToggle: (expanded) {
        setState(() {
          _requirementsExpanded = expanded;
        });
      },
      requirements: _requirements,
      onRequirementsChanged: (requirements) {
        setState(() {
          _requirements = requirements;
          _hasUnsavedChanges = true;
        });
      },
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Preview Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _showPreview,
            icon: CustomIconWidget(
              iconName: 'preview',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            label: Text('Preview Task'),
          ),
        ),
        SizedBox(height: 2.h),

        // Post Task Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isPosting ? null : _postTask,
            child: _isPosting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text('Posting Task...'),
                    ],
                  )
                : Text('Post Task'),
          ),
        ),
      ],
    );
  }

  void _suggestPricing(String category) {
    final Map<String, String> suggestedPrices = {
      'Home & Garden': '25.00',
      'Delivery & Moving': '30.00',
      'Handyman Services': '40.00',
      'Cleaning': '35.00',
      'Pet Care': '20.00',
      'Personal Assistant': '25.00',
      'Tech Support': '45.00',
      'Tutoring': '30.00',
      'Event Help': '25.00',
      'Shopping': '15.00',
      'Photography': '50.00',
      'Other': '25.00',
    };

    final String? suggestedPrice = suggestedPrices[category];
    if (suggestedPrice != null && _paymentController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Suggested Pricing'),
          content: Text(
            'Based on the "$category" category, we suggest \$$suggestedPrice for this type of task. Would you like to use this amount?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No, thanks'),
            ),
            ElevatedButton(
              onPressed: () {
                _paymentController.text = suggestedPrice;
                Navigator.pop(context);
              },
              child: Text('Use \$$suggestedPrice'),
            ),
          ],
        ),
      );
    }
  }

  void _showPreview() {
    if (!_validateForm()) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Task Preview',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _buildPreviewContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Category
            Text(
              _titleController.text,
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _selectedCategory ?? '',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 3.h),

            // Payment
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'attach_money',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  '\$${_paymentController.text}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),

            // Description
            Text(
              'Description',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 1.h),
            Text(
              _descriptionController.text,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 3.h),

            // Location
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _selectedLocation ?? '',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Timing
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  _isASAP ? 'ASAP' : _formatDateTime(_selectedDateTime!),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),

            if (_selectedImages.isNotEmpty) ...[
              SizedBox(height: 3.h),
              Text(
                'Photos (${_selectedImages.length})',
                style: AppTheme.lightTheme.textTheme.titleSmall,
              ),
              SizedBox(height: 1.h),
              Text(
                'Photos will be displayed to helpers',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    if (_selectedCategory == null) {
      isValid = false;
    }

    if (_selectedLocation == null) {
      isValid = false;
    }

    return isValid;
  }

  Future<void> _postTask() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all required fields'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    // Parse task cost
    final taskCostString = _paymentController.text.trim();
    final taskCost = int.tryParse(taskCostString) ?? 0;
    
    if (taskCost <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid payment amount'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    // Check subscription limit
    final subscriptionStatus = _subscriptionProvider.subscriptionStatus;
    if (subscriptionStatus != null) {
      if (subscriptionStatus.isLimitExceeded(taskCost)) {
        // Show over-limit alert
        await showOverLimitAlert(
          context: context,
          subscriptionStatus: subscriptionStatus,
          taskCost: taskCost,
          onUpgrade: () async {
            // Navigate to upgrade screen
            final userId = '1'; // Replace with actual user ID
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubscriptionSelectionScreen(
                  userId: userId,
                ),
              ),
            );
            // Reload subscription status after potential upgrade
            await _loadSubscriptionStatus();
            // Retry posting if user upgraded
            if (_subscriptionProvider.subscriptionStatus != null &&
                !_subscriptionProvider.subscriptionStatus!.isLimitExceeded(taskCost)) {
              _postTask(); // Retry posting
            }
          },
          onContinueWithCommission: () async {
            // Continue with commission
            final commission = subscriptionStatus.calculateCommission(taskCost);
            final totalCost = subscriptionStatus.calculateTotalWithCommission(taskCost);
            
            // Show commission confirmation
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Confirm with Commission',
                  style: AppTheme.lightTheme.textTheme.titleLarge,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Task Cost: ₹${taskCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Platform Commission (6%): ₹${commission.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Divider(),
                    SizedBox(height: 1.h),
                    Text(
                      'Total: ₹${totalCost.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              // Proceed with posting including commission
              await _proceedWithTaskPosting(taskCost: totalCost.toInt());
            }
          },
        );
        return;
      }
    }

    setState(() {
      _isPosting = true;
    });

    try {
      // Show confirmation dialog
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Task Posting'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are about to post this task:'),
              SizedBox(height: 2.h),
              Text(
                '• Payment: \$${_paymentController.text}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '• This amount will be held in escrow',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              Text(
                '• Funds released when task is completed',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              Text(
                'Estimated completion: ${_isASAP ? "Within 24 hours" : "By selected date"}',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Post Task'),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        setState(() {
          _isPosting = false;
        });
        return;
      }

      // Proceed with normal posting
      await _proceedWithTaskPosting(taskCost: taskCost);
    } catch (e) {
      setState(() {
        _isPosting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error posting task: ${e.toString()}'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _proceedWithTaskPosting({required int taskCost}) async {
    try {
      // Simulate posting delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success animation
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 60,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Task Posted Successfully!',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Your task is now live and helpers can start applying.',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushReplacementNamed(context, '/home-dashboard');
                },
                child: const Text('View My Tasks'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to post task. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final bool? shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Unsaved Changes'),
        content:
            Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Leave',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  String _formatDateTime(DateTime dateTime) {
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final String month = months[dateTime.month - 1];
    final String day = dateTime.day.toString();
    final String year = dateTime.year.toString();

    final String hour = dateTime.hour > 12
        ? (dateTime.hour - 12).toString()
        : (dateTime.hour == 0 ? 12 : dateTime.hour).toString();
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    final String period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, $year at $hour:$minute $period';
  }
}
