import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:jin_reflex_new/screens/utils/comman_app_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HealthCampaignPdfScreen extends StatelessWidget {
  const HealthCampaignPdfScreen({
    super.key,
    this.initialYear = 2016,
    this.showTabs = true,
  });

  final int initialYear;
  final bool showTabs;

  static const List<_CampaignPdfItem> _campaignPdfs = [
    _CampaignPdfItem(
      year: 2015,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2015Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2016,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2016Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2017,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2017Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2018,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2018Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2019,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2019Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2020,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2020Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2021,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2021Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2022,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2022Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2023,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2023Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2024,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2024Glimpsesall.pdf',
    ),
    _CampaignPdfItem(
      year: 2025,
      url:
          'https://jinreflexology.in/wp-content/uploads/2026/01/2025glimpsesall.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final initialIndex = _campaignPdfs.indexWhere(
      (item) => item.year == initialYear,
    );
    final selectedIndex = initialIndex >= 0 ? initialIndex : 0;
    final selectedItem = _campaignPdfs[selectedIndex];

    if (!showTabs) {
      return Scaffold(
        appBar: CommonAppBar(title: "Health Awareness ${selectedItem.year}"),
        body: _CampaignPdfTab(item: selectedItem),
      );
    }

    return DefaultTabController(
      length: _campaignPdfs.length,
      initialIndex: selectedIndex,
      child: Scaffold(
        appBar: CommonAppBar(title: "Health Awareness Campaign"),
        body: Column(
          children: [
            Material(
              color: Colors.white,
              elevation: 2,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.blue.shade900,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.blue.shade900,
                tabAlignment: TabAlignment.start,
                tabs:
                    _campaignPdfs
                        .map((item) => Tab(text: item.year.toString()))
                        .toList(),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final item in _campaignPdfs)
                    _CampaignPdfTab(
                      key: PageStorageKey<String>('campaign_pdf_${item.year}'),
                      item: item,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignPdfViewer extends StatelessWidget {
  const CampaignPdfViewer({super.key, required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    final item = HealthCampaignPdfScreen._campaignPdfs.firstWhere(
      (pdf) => pdf.year == year,
      orElse: () => HealthCampaignPdfScreen._campaignPdfs.first,
    );

    return _CampaignPdfTab(
      key: PageStorageKey<String>('campaign_pdf_inline_${item.year}'),
      item: item,
    );
  }
}

class _CampaignPdfTab extends StatefulWidget {
  const _CampaignPdfTab({super.key, required this.item});

  final _CampaignPdfItem item;

  @override
  State<_CampaignPdfTab> createState() => _CampaignPdfTabState();
}

class _CampaignPdfTabState extends State<_CampaignPdfTab>
    with AutomaticKeepAliveClientMixin<_CampaignPdfTab> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  bool get wantKeepAlive => true;

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      _pdfViewerController.previousPage();
    }
  }

  void _goToNextPage() {
    if (_totalPages > 0 && _currentPage < _totalPages) {
      _pdfViewerController.nextPage();
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SfPdfViewer.network(
      widget.item.url,
      controller: _pdfViewerController,
      pageLayoutMode: PdfPageLayoutMode.single,
      scrollDirection: PdfScrollDirection.horizontal,
      canShowPaginationDialog: true,
      canShowScrollHead: true,
      enableDoubleTapZooming: true,

      onDocumentLoaded: (details) {
        if (!mounted) return;
        setState(() {
          _totalPages = details.document.pages.count;
        });
      },

      onPageChanged: (details) {
        if (!mounted) return;
        setState(() {
          _currentPage = details.newPageNumber;
        });
      },

      onDocumentLoadFailed: (details) {
        print("PDF Error: ${details.description}");
      },
    );
  }
}

class _CampaignPdfItem {
  const _CampaignPdfItem({required this.year, required this.url});

  final int year;
  final String url;
}
