import 'package:boilerplate/constants/styles.dart';
import 'package:boilerplate/ui/mcp/reg_job.dart';
import 'package:boilerplate/ui/note/list_note.dart';
import 'package:boilerplate/ui/routing/list_routing.dart';
import 'package:boilerplate/ui/store/list_store.dart';
import 'package:boilerplate/widgets/my_label_widget.dart';
import 'package:boilerplate/widgets/secondary_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../../constants/colors.dart';
import '../../constants/dimens.dart';
import '../../stores/user/user_store.dart';
import '../../utils/shared/nav_service.dart';
import '../../widgets/register_required_screen_widget.dart';

class McpScreen extends StatefulWidget {
  const McpScreen();
  @override
  State<StatefulWidget> createState() => _McpScreenState();
}

class _McpScreenState extends State<McpScreen>
    with SingleTickerProviderStateMixin {
  TabController? _controller;
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SecondaryAppBar(),
        body: Observer(builder: (_) => _userStore.jobRegistered ? SingleChildScrollView(
          child: Column(
            children: [
              new Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: AppColors.green[200],
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.green[200]!.withOpacity(0.5),
                        AppColors.green[200]!.withOpacity(0.3),
                      ],
                    )),
                child: new TabBar(
                  isScrollable: true,
                  controller: _controller,
                  tabs: [
                    new Tab(
                      child: MyLabelWidget(
                        text: 'Stores',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),
                    new Tab(
                      child: MyLabelWidget(
                        text: 'Routing',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),
                    new Tab(
                      child: MyLabelWidget(
                        text: 'Daily Notices',
                        style: AppStyles.textStyle15Regular,
                      ),
                    ),
                  ],
                  indicatorColor: Theme.of(context).primaryColor,
                ),
              ),
              new Container(
                height: MediaQuery.of(context).size.height - 123,
                child: new TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    ListStoreScreen(tabController: _controller,),
                    ListRoutingScreen(tabController: _controller,),
                    ListNoteScreen(),
                  ],
                ),
              ),
            ],
          ),
        ): RegisterRequiredScreenWidget(
          height: MediaQuery.of(context).size.height - AppDimens.primaryAppBarHeight,
          width: MediaQuery.of(context).size.width,
          onPressed: () {
            NavigationService.push(context, RegisterJobScreen());
          },
        )
    ));
  }
}
