import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/brand_mark.dart';
import 'auth_service.dart';
import 'guest_session.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({this.startup = false, super.key});
  final bool startup;
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _run(Future<void> Function(AuthService) operation) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await operation(await ref.read(authServiceProvider.future));
    } catch (error) {
      if (mounted && !(error is LoginFailure && error.cancelled)) {
        setState(
          () => _error = error is LoginFailure
              ? error.message
              : '요청을 완료하지 못했어요. 다시 시도해 주세요.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = ref.watch(authServiceProvider);
    final profile = ref.watch(loginProfileProvider);
    final user = profile.asData?.value;
    final isGuest = ref.watch(guestSessionProvider) && user == null;
    return Scaffold(
      appBar: widget.startup ? null : AppBar(title: const Text('DreamBank 계정')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (widget.startup) ...[
              const SizedBox(height: 24),
              const BrandWordmark(),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  'assets/images/home_serenity.jpg',
                  height: 144,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ] else
              const Icon(Icons.account_circle_outlined, size: 64),
            const SizedBox(height: 24),
            Text(
              user == null
                  ? (widget.startup
                        ? '마음의 여유를 시작하세요'
                        : (isGuest ? '게스트로 이용 중이에요' : '당신의 DreamBank와 연결하세요'))
                  : '${user.name}님, 반가워요',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              widget.startup ? '계정으로 로그인하거나 게스트로 나만의 여유를 만나보세요.' : '계정은 나를 구분하는 ID로 사용해요. 잔고와 꿈, 편지는 현재 기기에 저장되며 아직 다른 기기와 동기화되지 않아요.',
            ),
            const SizedBox(height: 32),
            if (service.isLoading || (service.hasValue && profile.isLoading))
              const Center(child: CircularProgressIndicator()),
            if (user == null) ...[
              OutlinedButton(
                onPressed:
                    (_busy ||
                        service.isLoading ||
                        (service.hasValue && profile.isLoading))
                    ? null
                    : () => _run((s) => s.signIn(LoginMethod.google)),
                child: const Text('Google로 계속하기'),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed:
                    (_busy ||
                        service.isLoading ||
                        (service.hasValue && profile.isLoading))
                    ? null
                    : () => _run((s) => s.signIn(LoginMethod.apple)),
                icon: const Icon(Icons.apple),
                label: const Text('Apple로 계속하기'),
              ),
            ],
            if (widget.startup && user == null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _busy
                    ? null
                    : () => ref.read(guestSessionProvider.notifier).start(),
                icon: const Icon(Icons.person_outline),
                label: const Text('게스트로 시작하기'),
              ),
            ],
            if (isGuest && !widget.startup) ...[
              const SizedBox(height: 16),
              const Text('게스트는 이 기기에서만 이용해요. 계정 ID와 온라인 랭킹은 제공되지 않아요.'),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => ref.read(guestSessionProvider.notifier).end(),
                child: const Text('게스트 이용 종료'),
              ),
            ],
            if (widget.startup) ...[
              const SizedBox(height: 16),
              const Text('잔고와 기록은 이 기기에 저장돼요. 다른 기기와는 아직 동기화되지 않아요.'),
            ],
            if (service.hasError) ...[
              Text(
                service.error is LoginFailure
                    ? (service.error as LoginFailure).message
                    : '지금은 계정을 연결할 수 없어요.',
              ),
              TextButton(
                onPressed: () {
                  ref.invalidate(authServiceProvider);
                },
                child: const Text('다시 시도'),
              ),
            ],
            if (service.hasValue && profile.hasError) ...[
              const Text('계정 상태를 불러오지 못했어요.'),
              TextButton(
                onPressed: () => ref.invalidate(loginProfileProvider),
                child: const Text('다시 불러오기'),
              ),
            ],
            if (user != null) ...[
              if (user.email != null) Text(user.email!),
              const SizedBox(height: 12),
              const Text('내 계정 ID'),
              SelectableText(user.uid),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: _busy ? null : () => _run((s) => s.signOut()),
                child: const Text('로그아웃'),
              ),
              const Text('로그아웃해도 이 기기에 저장한 기록은 유지돼요.'),
            ],
            if (_busy)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: '계정 연결 처리 중',
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Semantics(liveRegion: true, child: Text(_error!)),
              ),
          ],
        ),
      ),
    );
  }
}
