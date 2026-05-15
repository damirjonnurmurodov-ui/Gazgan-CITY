import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/data/repository_result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_state_card.dart';
import '../../../core/widgets/data_status_banner.dart';

class ServiceCatalogScaffold<T> extends StatefulWidget {
  const ServiceCatalogScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.loadingTitle,
    required this.loadingMessage,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.loadItems,
    required this.itemBuilder,
  });

  final String title;
  final String subtitle;
  final String loadingTitle;
  final String loadingMessage;
  final String emptyTitle;
  final String emptyMessage;
  final Future<RepositoryResult<List<T>>> Function() loadItems;
  final Widget Function(BuildContext context, T item) itemBuilder;

  @override
  State<ServiceCatalogScaffold<T>> createState() =>
      _ServiceCatalogScaffoldState<T>();
}

class _ServiceCatalogScaffoldState<T> extends State<ServiceCatalogScaffold<T>> {
  late Future<RepositoryResult<List<T>>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.loadItems();
  }

  void _retry() {
    setState(() {
      _future = widget.loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: FutureBuilder<RepositoryResult<List<T>>>(
          future: _future,
          builder: (context, snapshot) {
            final result = snapshot.data;
            final items = result?.data ?? List<T>.empty();
            final isLoading =
                snapshot.connectionState == ConnectionState.waiting &&
                result == null;

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              children: <Widget>[
                _Header(title: widget.title),
                const SizedBox(height: 6),
                Text(
                  widget.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMuted,
                ),
                const SizedBox(height: 18),
                if (isLoading)
                  AppStateCard(
                    title: widget.loadingTitle,
                    message: widget.loadingMessage,
                    icon: LucideIcons.loader,
                    isLoading: true,
                  )
                else ...<Widget>[
                  if (result != null && result.isFallback) ...<Widget>[
                    DataStatusBanner(message: result.message!),
                    const SizedBox(height: 14),
                  ],
                  if (items.isEmpty)
                    AppStateCard(
                      title: result?.isFallback ?? false
                          ? 'Ma\'lumot vaqtincha mavjud emas'
                          : widget.emptyTitle,
                      message: result?.isFallback ?? false
                          ? 'Supabase javobi vaqtincha olinmadi. Birozdan so\'ng qayta urinib ko\'ring.'
                          : widget.emptyMessage,
                      icon: result?.isFallback ?? false
                          ? LucideIcons.wifiOff
                          : LucideIcons.searchX,
                      actionLabel: 'Qayta urinish',
                      onActionTap: _retry,
                    )
                  else
                    ...List<Widget>.generate(items.length, (index) {
                      final item = items[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index < items.length - 1 ? 12 : 0,
                        ),
                        child: widget.itemBuilder(context, item),
                      );
                    }),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AppButton(
          label: 'Ortga',
          icon: LucideIcons.chevronLeft,
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.screenTitle,
          ),
        ),
      ],
    );
  }
}
