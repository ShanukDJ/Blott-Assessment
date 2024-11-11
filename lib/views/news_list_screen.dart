import 'package:blott_mobile_assessment/providers/auth_provider.dart';
import 'package:blott_mobile_assessment/utills/image.dart';
import 'package:flutter/material.dart';
import '../models/news_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/news_list_service.dart';
import '../utills/widgets/custom_text.dart';
import '../utills/widgets/shimmer_loading.dart';


// Enum to handle different data states
enum DataState { loading, success, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<NewsModel> _newsList = [];
  DataState _dataState = DataState.loading;
  final String _errorMessage = "Something went wrong. Please try again later.";

  @override
  void initState() {
    super.initState();
    _loadData(isFirstTime : true);
  }

  Future<void> _loadData({bool isFirstTime = false}) async {
    if(isFirstTime){
      setState(() {
        _dataState = DataState.loading;
      });
    }
    try {
      final List<NewsModel> fetchedData = await NewsService().fetchNews();
      setState(() {
        _newsList = fetchedData;
        _dataState = DataState.success;
      });
    } catch (error) {
      setState(() {
        _dataState = DataState.error;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData(isFirstTime : false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.onSurface,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header section with user name and error message
            _buildHeaderSection(),
            // News list
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  // Header section widget
  Widget _buildHeaderSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          height: 181,
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
                    text: "Hey ${authProvider.firstName}",
                    fontSize: 32,
                  ),
                ),
                if (_dataState == DataState.error)
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
      },
    );
  }

  // Build content based on data state
  Widget _buildContent() {
    switch (_dataState) {
      case DataState.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: ShimmerLoadingList(),
        );
      case DataState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 60),
              const SizedBox(height: 10),
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      case DataState.success:
        return _buildNewsList();
    }
  }

  // Build news list
  Widget _buildNewsList() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _newsList.length,
        itemBuilder: (context, index) {
          final doc = _newsList[index];
          return _buildListItem(doc);
        },
      ),
    );
  }

  // Build each news item
  Widget _buildListItem(NewsModel doc) {
    return InkWell(
      onTap: () => urlLaunch(doc.url ?? ""),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CustomImage(
              imageUrl: doc.image ?? "",
              width: 100,
              height: 100,
              placeholder: const Center(child: CircularProgressIndicator()),
              errorWidget: const Icon(Icons.error, color: Colors.red),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only( bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          color: Colors.white.withOpacity(0.7),
                          isSmall: true,
                          text: doc.source ?? "",
                          fontSize: 14,
                        ),
                        CustomText(
                          color: Colors.white.withOpacity(0.7),
                          isSmall: true,
                          text: doc.formattedDate.toString(),
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    doc.headline ?? "",
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
      ),
    );
  }

  Future<void> urlLaunch(String link) async {
    final uri = Uri.parse(link);
    if (await launch(link)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      return;
    }
  }




}
