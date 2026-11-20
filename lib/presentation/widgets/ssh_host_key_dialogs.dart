import 'dart:async';

import 'package:flutter/material.dart';

import '../../domain/entities/ssh_host_key.dart';
import '../../l10n/app_localizations.dart';

class SSHHostKeyDialogs implements SSHHostKeyConfirmation {
  final navigatorKey = GlobalKey<NavigatorState>();
  Future<void> _queue = Future.value();
  final _changes = <(String, String)>{};

  Future<T> _enqueue<T>(Future<T> Function() show) {
    final result = _queue.then((_) => show());
    _queue = result.then((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  @override
  Future<bool> trust(SSHHostKey key, Future<void> connectionEnded) async {
    var ended = false;
    unawaited(connectionEnded.then((_) => ended = true));
    return _enqueue(() async {
      final navigator = navigatorKey.currentState;
      final context = navigator?.overlay?.context;
      if (ended || navigator == null || context == null) return false;
      final l10n = AppLocalizations.of(context);
      final route = DialogRoute<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AlertDialog(
          icon: const Icon(Icons.security),
          title: Text(l10n.hostKeyUnknownTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.hostKeyUnknownBody),
                const SizedBox(height: 12),
                SelectableText(key.endpoint),
                const SizedBox(height: 8),
                _identity(key.identity),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.hostKeyTrust),
            ),
          ],
        ),
      );
      final result = navigator.push(route);
      unawaited(
        connectionEnded.then((_) {
          if (navigator.mounted && route.isActive) {
            navigator.removeRoute(route, false);
          }
        }),
      );
      return await result ?? false;
    });
  }

  @override
  Future<void> changed(
    SSHHostKey previous,
    SSHHostKey presented,
    Future<void> Function() replace,
  ) => _showChange(
    presented.endpoint,
    previous.identity,
    presented.identity,
    replace: replace,
  );

  @override
  void rekeyRejected(String endpoint, String previous, String presented) {
    unawaited(_showChange(endpoint, previous, presented));
  }

  Future<void> _showChange(
    String endpoint,
    String previous,
    String presented, {
    Future<void> Function()? replace,
  }) async {
    final change = (endpoint, presented);
    if (!_changes.add(change)) return;
    try {
      await _enqueue(() async {
        final context = navigatorKey.currentState?.overlay?.context;
        if (context == null) return;
        final l10n = AppLocalizations.of(context);
        final review = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            icon: Icon(
              Icons.gpp_bad,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(l10n.hostKeyChangedTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.hostKeyChangedBody),
                  const SizedBox(height: 12),
                  SelectableText(endpoint),
                  if (previous.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(l10n.hostKeyPrevious),
                    _identity(previous),
                  ],
                  if (presented.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(l10n.hostKeyPresented),
                    _identity(presented),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.close),
              ),
              if (replace != null)
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(l10n.hostKeyReview),
                ),
            ],
          ),
        );
        if (review != true || !context.mounted || replace == null) return;
        final approved = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.hostKeyReplace),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.hostKeyReplaceBody),
                  const SizedBox(height: 12),
                  SelectableText(endpoint),
                  _identity(presented),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(l10n.hostKeyReplace),
              ),
            ],
          ),
        );
        if (approved != true || !context.mounted) return;
        final String message;
        try {
          await replace();
          message = l10n.hostKeyReplaced;
        } catch (_) {
          if (context.mounted) {
            await _showMessage(context, l10n.hostKeyStorageError);
          }
          return;
        }
        if (context.mounted) await _showMessage(context, message);
      });
    } finally {
      _changes.remove(change);
    }
  }

  Future<void> _showMessage(BuildContext context, String message) => showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(AppLocalizations.of(dialogContext).close),
        ),
      ],
    ),
  );

  Widget _identity(String identity) => SelectableText(
    identity,
    style: const TextStyle(fontFamily: 'TerminalMono'),
  );
}
