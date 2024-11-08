import 'package:blott_mobile_assessment/utills/assets.dart';
import 'package:flutter/material.dart';
import '../models/list_data_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../services/auth_service.dart';
import '../services/data_list_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utills/widgets/custom_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<DataModel>> _documents;
  String? _name;
  bool _isError = false;
  Duration duration = const Duration(milliseconds: 500);
  final String _errorMessage = "Something went wrong. Please try again later.";

  @override
  void initState() {
    super.initState();
    _documents = DataListService().fetchDataList();
    _getCurrentUser();
  }

  Future _refreshData() async {
    _documents = DataListService().fetchDataList();
  }

  // Fetch the current user name
  Future<void> _getCurrentUser() async {
    _name = await AuthService().getUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Blue container with user name and error message
          _buildHeaderSection(_name),
          // list of data
          Expanded(
            child: Container(
              color: Colors.black,
              child: _buildDataList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(String? name) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.20,
      color: Theme.of(context).colorScheme.onSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                color: Colors.white,
                textAlign: TextAlign.left,
                isSmall: false,
                text: "Hey ${_name ?? 'there'}",
                fontSize: 32,
              ),
            ),
            if (_isError)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CustomText(
                    color: Colors.white,
                    isSmall: true,
                    textAlign: TextAlign.left,
                    text: _errorMessage,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Method to display the data list
  Widget _buildDataList() {
    return FutureBuilder<List<DataModel>>(
      future: _documents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.white,
              size: 50,
            ),
          );
        }

        if (snapshot.hasError) {
          _isError = true;
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available.'));
        }

        final documents = snapshot.data!;

        return AnimationLimiter(
          key: const ValueKey("20"),
          child: RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final doc = documents[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: duration,
                    child: SlideAnimation(
                        verticalOffset: 300, child: _buildListItem(doc, index)),
                  );
                },
              )),
        );
      },
    );
  }

  // Method to build a list item
  Widget _buildListItem(DataModel doc, int index) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Image for the list item
          Image.asset(
            height: 100,
            width: 100,
            index == 0
                ? AppImages.sampleImage1
                : index == 1
                    ? AppImages.sampleImage2
                    : index == 2
                        ? AppImages.sampleImage3
                        : index == 3
                            ? AppImages.sampleImage4
                            : AppImages.sampleImage1,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 50),
                      child: CustomText(
                        color: Colors.white.withOpacity(0.7),
                        isSmall: true,
                        text: doc.title,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: CustomText(
                        color: Colors.white.withOpacity(0.7),
                        isSmall: true,
                        text: doc.date,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                // Description
                Text(
                  doc.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
