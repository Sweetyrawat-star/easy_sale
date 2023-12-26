import 'dart:async';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/models/routing/routing.dart';
import 'package:boilerplate/ui/routing/detail_routing.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/search_header_widget.dart';

class ListRoutingScreen extends StatefulWidget {
  final TabController? tabController;
  const ListRoutingScreen({Key? key, this.tabController});
  @override
  State<StatefulWidget> createState() => _ListRoutingScreenState();
}

class _ListRoutingScreenState extends State<ListRoutingScreen> {
  final Repository _repository = getIt<Repository>();
  late PagewiseLoadController<Routing> _pagewiseLoadController;
  late String searchKey = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pagewiseLoadController = PagewiseLoadController<Routing>(
        pageSize: 10,
        pageFuture: (pageIndex) => _repository.getRoutings({
              "page": (pageIndex ?? 0) + 1,
              "item_per_page": 10,
              "keyword": searchKey
            }));
    _pagewiseLoadController.addListener(() {
      if (this._pagewiseLoadController.hasMoreItems == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No data!'),
          backgroundColor: AppColors.green[500],
        ));
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SearchHeaderWidget(
            hintText: "Search",
            onPlus: () {
              showDialog(
                  context: context,
                  builder: (_) => ConfirmDialogWidget(
                    titleText: "Guidance",
                    contentText:
                    'You need to pick stores on "Stores" tab first and then create Routing',
                    confirmText: "Pick now",
                    cancelText: "Later",
                    onConfirmed: () {
                      widget.tabController?.animateTo(0);
                    },
                  ));
            },
            onSearch: (keyword) {
              if (_debounce?.isActive ?? false) _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 500), () {
                setState(() {
                  searchKey = keyword;
                });
                _pagewiseLoadController.reset();
              });
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height - 323,
            child: _buildMainContent(),
          )
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return RefreshIndicator(
        onRefresh: () async {
          _pagewiseLoadController.reset();
          await Future.value({});
        },
        child: PagewiseListView<Routing>(
          itemBuilder: _buildListItem,
          pageLoadController: _pagewiseLoadController,
          errorBuilder: (context, error) {
            print('error: $error');
            return Text('Error: $error');
          },
          showRetry: false,
        ));
  }

  Widget _buildListItem(context, Routing note, _) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyLabelWidget(
                text: note.title,
                style: AppStyles.textStyle20RegularBold),
            SizedBox(height: 5,),
            MyLabelWidget(
                text: new DateFormat('dd/MM/yyyy')
                    .format(DateTime.fromMicrosecondsSinceEpoch(note.createdAt)),
                style: AppStyles.textStyle16Regular400
                    .merge(TextStyle(color: AppColors.greyPrice)))
          ],
        ),
        onTap: () {
          NavigationService.push(context, DetailRoutingScreen(routingId: note.id));
        },
      ),
    );
  }
}
