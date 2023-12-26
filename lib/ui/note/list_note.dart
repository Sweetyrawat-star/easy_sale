import 'dart:async';

import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/data/repository.dart';
import 'package:boilerplate/di/components/service_locator.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagewise/flutter_pagewise.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';
import '../../models/note/note.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/search_header_widget.dart';
import 'create_note.dart';

class ListNoteScreen extends StatefulWidget {
  const ListNoteScreen();
  @override
  State<StatefulWidget> createState() => _ListNoteScreenState();
}

class _ListNoteScreenState extends State<ListNoteScreen> {
  final Repository _repository = getIt<Repository>();
  late PagewiseLoadController<Note> _pagewiseLoadController;
  late String searchKey = "";
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _pagewiseLoadController = PagewiseLoadController<Note>(
        pageSize: 10,
        pageFuture: (pageIndex) => _repository.getNotes({
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
              NavigationService.push(context, CreateNoteScreen()).then((_) {
                if (_ == true) _pagewiseLoadController.reset();
              });
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
        child: PagewiseListView<Note>(
          itemBuilder: _buildListItem,
          pageLoadController: _pagewiseLoadController,
          errorBuilder: (context, error) {
            print('error: $error');
            return Text('Error: $error');
          },
          showRetry: false,
        ));
  }

  Widget _buildListItem(context, Note note, _) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyLabelWidget(
              text: new DateFormat('HH:mm:ss dd-MM-yyyy')
                  .format(DateTime.fromMicrosecondsSinceEpoch(note.createdAt)),
              style: AppStyles.textStyle20RegularBold),
          MyLabelWidget(
              text: note.content,
              style: AppStyles.textStyle16Regular400
                  .merge(TextStyle(color: AppColors.textGreyColor)))
        ],
      ),
    );
  }
}
