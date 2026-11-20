import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/command_result.dart';
import '../../l10n/app_localizations.dart';

class CommandOutputModal extends StatelessWidget {
  final CommandResult result;
  final VoidCallback? onRerun;
  final VoidCallback onClose;

  const CommandOutputModal({
    super.key,
    required this.result,
    this.onRerun,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSuccess = result.isSuccess;

    return Dialog(
      backgroundColor: AppTheme.darkSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Container(
        width: 850,
        height: 580,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.darkSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.darkBorder),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isSuccess ? AppTheme.success : AppTheme.error)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isSuccess
                          ? Icons.check_circle_outline
                          : Icons.error_outline,
                      color: isSuccess ? AppTheme.success : AppTheme.error,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.commandResultTitle,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.executedAt(
                            DateFormatter.formatDateTime(
                              result.executedAt,
                              l10n.localeName,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                    splashRadius: 20,
                    tooltip: l10n.close,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  // Badges
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (isSuccess ? AppTheme.success : AppTheme.error)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSuccess ? AppTheme.success : AppTheme.error,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isSuccess
                          ? l10n.exitCodeSuccess
                          : l10n.exitCodeError(result.exitCode),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSuccess ? AppTheme.success : AppTheme.error,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.primary, width: 1),
                    ),
                    child: Text(
                      DateFormatter.formatDuration(
                        result.durationMs,
                        l10n.localeName,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.accent,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(color: AppTheme.darkBorder),
              const SizedBox(height: 8),

              // Command preview banner
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.darkBorder),
                ),
                child: Row(
                  children: [
                    const Text(
                      '\$ ',
                      style: TextStyle(
                        color: AppTheme.accent,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        result.command,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Output actions
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      final content = l10n.commandOutputSummary(
                        result.command,
                        result.exitCode,
                        DateFormatter.formatDuration(
                          result.durationMs,
                          l10n.localeName,
                        ),
                        result.stdout,
                        result.stderr,
                      );
                      Clipboard.setData(ClipboardData(text: content));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.outputCopied),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: Text(l10n.copyOutput),
                  ),
                  if (onRerun != null) ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        onClose();
                        onRerun!();
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: Text(l10n.runAgain),
                    ),
                  ],
                  OutlinedButton(onPressed: onClose, child: Text(l10n.close)),
                ],
              ),
              const SizedBox(height: 12),

              // Output Terminal Container
              Container(
                constraints: const BoxConstraints(minHeight: 120),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.darkBorder),
                ),
                child: SelectionArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result.stdout.isNotEmpty)
                        Text(
                          result.stdout,
                          style: const TextStyle(
                            color: Color(0xFFE2E8F0),
                            fontFamily: 'monospace',
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      if (result.stderr.isNotEmpty) ...[
                        if (result.stdout.isNotEmpty) const SizedBox(height: 8),
                        Text(
                          result.stderr,
                          style: const TextStyle(
                            color: AppTheme.error,
                            fontFamily: 'monospace',
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                      if (result.stdout.isEmpty && result.stderr.isEmpty)
                        Text(
                          l10n.noCommandOutput,
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
