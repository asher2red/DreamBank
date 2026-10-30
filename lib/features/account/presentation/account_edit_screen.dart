import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/input_validation.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_state_view.dart';
import '../../../data/database/app_database.dart';
import '../../../data/storage_providers.dart';
import '../application/account_editor.dart';

class AccountEditScreen extends ConsumerWidget {
  const AccountEditScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(accountProvider)
      .when(
        loading: () => Scaffold(
          appBar: AppBar(title: const Text('계좌 설정')),
          body: const Center(child: CircularProgressIndicator()),
        ),
        error: (_, _) => Scaffold(
          appBar: AppBar(
            title: const Text('계좌 설정'),
            leading: BackButton(onPressed: () => context.pop()),
          ),
          body: AppPage(
            storageKey: 'edit-error',
            children: [
              AppStateView(
                icon: Icons.error_outline,
                title: '계좌를 불러오지 못했어요',
                message: '잠시 후 다시 시도해 주세요.',
                actionLabel: '다시 불러오기',
                onAction: () => ref.invalidate(accountProvider),
              ),
            ],
          ),
        ),
        data: (account) => _AccountForm(account: account),
      );
}

class _AccountForm extends ConsumerStatefulWidget {
  const _AccountForm({required this.account});
  final AccountSettings account;
  @override
  ConsumerState<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<_AccountForm> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nickname;
  late final TextEditingController _balance;
  bool _allowPop = false;
  bool _confirming = false;
  bool get _dirty =>
      _nickname.text != widget.account.accountNickname ||
      _balance.text != widget.account.virtualBalance.toString();
  @override
  void initState() {
    super.initState();
    _nickname = TextEditingController(text: widget.account.accountNickname)
      ..addListener(_changed);
    _balance = TextEditingController(
      text: widget.account.virtualBalance.toString(),
    )..addListener(_changed);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _nickname.dispose();
    _balance.dispose();
    super.dispose();
  }

  Future<void> _leave() async {
    if (_confirming || ref.read(accountEditorProvider).isLoading) return;
    _confirming = true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('작성을 그만둘까요?'),
        content: const Text('저장하지 않은 변경 내용은 사라져요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('계속 작성'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('버리기'),
          ),
        ],
      ),
    );
    _confirming = false;
    if (!mounted || discard != true) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (mounted) context.pop();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final saved = await ref
        .read(accountEditorProvider.notifier)
        .save(nickname: _nickname.text, balance: parseWon(_balance.text));
    if (!mounted || !saved) return;
    setState(() => _allowPop = true);
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    context.pop();
    messenger.showSnackBar(const SnackBar(content: Text('계좌 설정을 저장했어요.')));
  }

  @override
  Widget build(BuildContext context) {
    final saving = ref.watch(accountEditorProvider).isLoading;
    return PopScope(
      canPop: _allowPop || (!_dirty && !saving),
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('계좌 설정'),
          leading: BackButton(
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: SafeArea(
          top: false,
          child: AppPage(
            storageKey: 'account-edit',
            children: [
              Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('상상 속 여유를 원하는 만큼 담아보세요. 실제 금융 자산에는 영향을 주지 않아요.'),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      key: const ValueKey('nickname-input'),
                      controller: _nickname,
                      enabled: !saving,
                      decoration: const InputDecoration(
                        labelText: '계좌 별칭',
                        helperText: '1~30자',
                      ),
                      validator: (value) {
                        try {
                          validatedText(value ?? '', max: 30, singleLine: true);
                          return null;
                        } catch (_) {
                          return '계좌 이름을 1~30자로 입력해 주세요.';
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    TextFormField(
                      key: const ValueKey('balance-input'),
                      controller: _balance,
                      enabled: !saving,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: '가상 잔고 (원)',
                        helperText: '0~999,999,999,999원',
                      ),
                      validator: (value) {
                        try {
                          parseWon(value ?? '');
                          return null;
                        } catch (_) {
                          return '0~999,999,999,999원 사이의 정수를 입력해 주세요.';
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (ref.watch(accountEditorProvider).hasError)
                      const Text('계좌 설정을 저장하지 못했어요. 입력 내용을 확인하고 다시 시도해 주세요.'),
                    FilledButton(
                      onPressed: saving ? null : _save,
                      child: Text(saving ? '저장 중…' : '계좌 설정 저장'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
