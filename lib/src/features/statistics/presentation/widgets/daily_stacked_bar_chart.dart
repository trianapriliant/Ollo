import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_text_styles.dart';
import '../../../settings/presentation/currency_provider.dart';
import '../statistics_provider.dart';
import 'package:ollo/src/localization/generated/app_localizations.dart';

class DailyStackedBarChart extends StatefulWidget {
  final List<DailyData> data;
  final Currency currency;
  final double avgIncome;
  final double avgExpense;
  final double avgSavings;
  final DateTime selectedDate;

  const DailyStackedBarChart({
    super.key,
    required this.data,
    required this.currency,
    required this.avgIncome,
    required this.avgExpense,
    required this.avgSavings,
    required this.selectedDate,
  });

  @override
  State<DailyStackedBarChart> createState() => _DailyStackedBarChartState();
}

class _DailyStackedBarChartState extends State<DailyStackedBarChart> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToDay());
  }

  @override
  void didUpdateWidget(covariant DailyStackedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate || oldWidget.data != widget.data) {
       WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToDay());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToDay() {
    if (!_scrollController.hasClients) return;

    final now = DateTime.now();
    final isCurrentMonth = widget.selectedDate.year == now.year && widget.selectedDate.month == now.month;

    double targetOffset = 0.0;

    if (isCurrentMonth) {
      // Find index of today in data
      // Assuming data is sorted by day, but safety first: find entry with day == now.day
      int index = widget.data.indexWhere((element) => element.day == now.day);
      
      // If today not found (e.g. no transaction yet?), default to day index logic roughly
      if (index == -1) {
         index = now.day - 1; // 0-based index approximation
      }
      
      // Since data might be sparse if specific days are missing, logic depends on if data contains ALL days or just days with transactions.
      // Based on provider, it seems to return data for days with transactions? 
      // Actually checking statistics_provider.dart would allow to verify if it fills empty days.
      // Assuming it might be sparse or full. 
      // If sparse, indexWhere is correct.
      // If full (1..31), indexWhere is also correct.
      
      // Calculation:
      // Item width is fixed at 50.0 (from build method logic below)
      const double itemWidth = 50.0;
      final double viewportWidth = _scrollController.position.viewportDimension;
      final double maxScroll = _scrollController.position.maxScrollExtent;

      // Center the item: (index * itemWidth) - (half viewport) + (half item)
      double calculatedOffset = (index * itemWidth) - (viewportWidth / 2) + (itemWidth / 2);
      
      // Clamp
      targetOffset = calculatedOffset.clamp(0.0, maxScroll);
    } 
    
    // Animate to offset
    _scrollController.animateTo(
      targetOffset, 
      duration: const Duration(milliseconds: 500), 
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate width based on number of days to ensure bars are readable
    // 3 bars per day * 8px width + spacing
    final double chartWidth = widget.data.length * 50.0; 
    
    // Find max value for Y-axis scaling
    double maxY = 0;
    for (var item in widget.data) {
      if (item.income > maxY) maxY = item.income;
      if (item.expense > maxY) maxY = item.expense;
      if (item.savings > maxY) maxY = item.savings;
    }
    
    // Add some buffer
    maxY = maxY * 1.2;
    if (maxY == 0) maxY = 100;


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.dailyOverview, style: AppTextStyles.h3),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Text(
                    'Avg Inc: ${widget.currency.format(widget.avgIncome)}',
                    style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF4ADE80), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                   Text(
                    'Avg Exp: ${widget.currency.format(widget.avgExpense)}',
                    style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFF87171), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                   Text(
                    'Avg Sav: ${widget.currency.format(widget.avgSavings)}',
                    style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF60A5FA), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Container(
            width: chartWidth < MediaQuery.of(context).size.width ? MediaQuery.of(context).size.width : chartWidth,
            height: 220,
            padding: const EdgeInsets.only(top: 20), // Space for top tooltips
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                maxY: maxY,
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: widget.avgIncome,
                      color: const Color(0xFF4ADE80).withOpacity(0.8),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 5, bottom: 5),
                        style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF4ADE80), fontSize: 10),
                        labelResolver: (line) => 'Avg Inc: ${widget.currency.format(line.y)}',
                      ),
                    ),
                    HorizontalLine(
                      y: widget.avgExpense,
                      color: const Color(0xFFF87171).withOpacity(0.8),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 5, bottom: 20), // Stagger labels
                        style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFF87171), fontSize: 10),
                        labelResolver: (line) => 'Avg Exp: ${widget.currency.format(line.y)}',
                      ),
                    ),
                    HorizontalLine(
                      y: widget.avgSavings,
                      color: const Color(0xFF60A5FA).withOpacity(0.8),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                      label: HorizontalLineLabel(
                        show: true,
                        alignment: Alignment.topRight,
                        padding: const EdgeInsets.only(right: 5, bottom: 35), // Stagger labels
                        style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF60A5FA), fontSize: 10),
                        labelResolver: (line) => 'Avg Sav: ${widget.currency.format(line.y)}',
                      ),
                    ),
                  ],
                ),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.blueGrey,
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final dayData = widget.data[group.x.toInt() - 1];
                      String label;
                      double value;
                      Color color;
                      
                      if (rodIndex == 0) {
                        label = AppLocalizations.of(context)!.income;
                        value = dayData.income;
                        color = const Color(0xFF4ADE80);
                      } else if (rodIndex == 1) {
                        label = AppLocalizations.of(context)!.expense;
                        value = dayData.expense;
                        color = const Color(0xFFF87171);
                      } else {
                        label = AppLocalizations.of(context)!.savings;
                        value = dayData.savings;
                        color = const Color(0xFF60A5FA);
                      }

                      return BarTooltipItem(
                        '$label\n',
                        TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.currency.format(value),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            day.toString(),
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: widget.data.map((item) {
                  return BarChartGroupData(
                    x: item.day,
                    barsSpace: 4, // Space between bars in a group
                    barRods: [
                      // Income Bar
                      BarChartRodData(
                        toY: item.income,
                        width: 8,
                        color: const Color(0xFF4ADE80), // Green
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Expense Bar
                      BarChartRodData(
                        toY: item.expense,
                        width: 8,
                        color: const Color(0xFFF87171), // Red
                        borderRadius: BorderRadius.circular(4),
                      ),
                      // Savings Bar
                      BarChartRodData(
                        toY: item.savings,
                        width: 8,
                        color: const Color(0xFF60A5FA), // Blue
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(const Color(0xFF4ADE80), AppLocalizations.of(context)!.income),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFFF87171), AppLocalizations.of(context)!.expense),
            const SizedBox(width: 16),
            _buildLegendItem(const Color(0xFF60A5FA), AppLocalizations.of(context)!.savings),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
