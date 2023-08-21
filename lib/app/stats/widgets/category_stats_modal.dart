import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:monekin/app/stats/widgets/chart_by_categories.dart';
import 'package:monekin/core/database/services/exchange-rate/exchange_rate_service.dart';
import 'package:monekin/core/models/supported-icon/supported_icon.dart';
import 'package:monekin/core/presentation/widgets/animated_progress_bar.dart';
import 'package:monekin/core/presentation/widgets/number_ui_formatters/currency_displayer.dart';
import 'package:monekin/core/utils/color_utils.dart';
import 'package:monekin/i18n/translations.g.dart';

class CategoryStatsModal extends StatelessWidget {
  const CategoryStatsModal(
      {super.key,
      required this.categoryData,
      required this.dateRangeDisplayName});

  final ChartByCategoriesDataItem categoryData;
  final String dateRangeDisplayName;

  Future<List<Map<String, dynamic>>> getSubcategoriesData(
      BuildContext context) async {
    final t = Translations.of(context);

    List<Map<String, dynamic>> subcategories = [];

    for (final transaction in categoryData.transactions) {
      final notBelongToAnySubcatName = t.categories.select.without_subcategory;

      final categoryToEdit = subcategories.firstWhereOrNull((x) =>
          x['name'] == transaction.category!.name ||
          x['name'] == notBelongToAnySubcatName);

      final trValue = await ExchangeRateService.instance
          .calculateExchangeRateToPreferredCurrency(
              fromCurrency: transaction.account.currencyId,
              amount: transaction.value.abs())
          .first;

      if (categoryToEdit != null) {
        categoryToEdit['value'] += trValue;
      } else {
        subcategories.add({
          'name': transaction.category!.name == categoryData.category.name
              ? notBelongToAnySubcatName
              : transaction.category!.name,
          'value': trValue,
          'icon': transaction.category!.icon,
        });
      }
    }

    return subcategories.sorted((a, b) => b['value'].compareTo(a['value']));
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  categoryData.category.icon.displayFilled(
                      color: ColorHex.get(categoryData.category.color),
                      size: 34),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        categoryData.category.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        '${categoryData.transactions.length} ${categoryData.transactions.length == 1 ? t.general.transaction : t.general.transactions}'
                            .toLowerCase(),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateRangeDisplayName,
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  CurrencyDisplayer(
                    amountToConvert: categoryData.value,
                    textStyle: Theme.of(context).textTheme.titleLarge!,
                  )
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        FutureBuilder(
            future: getSubcategoriesData(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LinearProgressIndicator();
              }

              final subcategories = snapshot.data!;

              return Column(
                children: List.generate(subcategories.length, (index) {
                  final subcategoryData = subcategories[index];

                  return ListTile(
                    leading: (subcategoryData['icon'] as SupportedIcon)
                        .displayFilled(
                      color: ColorHex.get(categoryData.category.color),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(subcategoryData['name']),
                        CurrencyDisplayer(
                            amountToConvert: subcategoryData['value'])
                      ],
                    ),
                    subtitle: AnimatedProgressBar(
                      value: subcategoryData['value'] / categoryData.value,
                      color: ColorHex.get(categoryData.category.color),
                    ),
                  );
                }),
              );
            })
      ],
    );
  }
}
