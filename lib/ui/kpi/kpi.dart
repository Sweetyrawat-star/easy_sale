import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/stores/user/user_store.dart';
import 'package:boilerplate/ui/kpi/widgets/kpi_item_card_widget.dart';
import 'package:boilerplate/ui/mcp/reg_job.dart';
import 'package:boilerplate/utils/shared/nav_service.dart';
import 'package:boilerplate/widgets/register_required_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../data/repository.dart';
import '../../di/components/service_locator.dart';
import '../../utils/shared/text_format.dart';
import '../../widgets/primary_app_bar_widget.dart';
import '../../widgets/progress_indicator_widget.dart';

class KpiDataModel {
  int totalSKU;
  int totalOrder;
  int totalShop;
  int totalPrice;

  KpiDataModel({
    this.totalSKU = 0,
    this.totalOrder = 0,
    this.totalShop = 0,
    required this.totalPrice
  });
}

class KpiScreen extends StatefulWidget {
  const KpiScreen();
  @override
  State<StatefulWidget> createState() => _KpiScreenState();
}

class _KpiScreenState extends State<KpiScreen> {
  final Repository _repository = getIt<Repository>();
  late UserStore _userStore;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _userStore = Provider.of<UserStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PrimaryAppBar(),
        body: Observer(builder: (_) => _userStore.jobRegistered
            ? _body()
            : RegisterRequiredScreenWidget(
                height: MediaQuery.of(context).size.height -
                    AppDimens.primaryAppBarHeight,
                width: MediaQuery.of(context).size.width,
                onPressed: () {
                  NavigationService.push(context, RegisterJobScreen());
                },
              )
        )
    );
  }

  Widget _body() {
    return Container(
      child: FutureBuilder(
        future: _repository.getKpis(),
        builder: ((context, AsyncSnapshot<Map<String, num>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildKpi(snapshot.data ?? {});
            } else {
              return Container(
                height: 200,
                child: CustomProgressIndicatorWidget(),
              );
            }
          } else {
            return Container(
              height: 200,
              child: CustomProgressIndicatorWidget(),
            );
          }
        }),
      ),
    );
  }

  Widget _buildKpi(Map<String, num> data) {
    List<KpiItemModel> arr = [
        KpiItemModel(
            bgColor: Color(0xFFC8E8D8),
            title: "Awaiting\ndelivery",
            desc: "Total order value",
            resultValue: CurrencyFormat.usd(data["totalPriceWaiting"].toString()),
            totalValue: ""),
        KpiItemModel(
            bgColor: Color(0xFFE3D6F9),
            title: "AOV",
            desc: "Average order value",
            resultValue: CurrencyFormat.usd('${(data["totalPrice"] ?? 0) ~/ (data["totalOrder"] == 0 ? 1 : (data["totalOrder"] ?? 1))}'),
            totalValue: ""),
        KpiItemModel(
            bgColor: Color(0xFF6BBB9F),
            title: "Successful\ndelivery",
            desc: "Total order value",
            resultValue: CurrencyFormat.usd(data["totalPriceDelivered"].toString()),
            totalValue: ""),
        KpiItemModel(
            bgColor: Color(0xFFFACCB4),
            title: "ASO",
            desc: "Average number of SKUs per order",
            resultValue: '${(data["totalSKU"] ?? 0) ~/ (data["totalOrder"] == 0 ? 1 : (data["totalOrder"] ?? 1))}',
            totalValue: ""),
        KpiItemModel(
            bgColor: Color(0xFF9DD5C3),
            title: "",
            desc: "",
            resultValue: "",
            totalValue: ""),
        KpiItemModel(
            bgColor: Color(0xFFF4E8CC),
            title: "AOBO",
            desc: "Average order frequency",
            resultValue: '${(data["totalOrder"] ?? 0) ~/ (data["totalShop"] == 0 ? 1 : (data["totalShop"] ?? 1))}',
            totalValue: "")
    ];

    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: AlignedGridView.count(
        itemCount: arr.length,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemBuilder: (context, index) {
          KpiItemModel item = arr.elementAt(index);
          return KpiItemCardWidget(
            data: item,
          );
        },
      ),
    );
  }
}
