# Google·Apple 로그인 작업 결과

작성일: 2026-10-31

후속 변경: 앱 시작 시 로그인 필수 흐름은 [auth-startup-report.md](auth-startup-report.md)를 참고한다.

## 결과

- 내 계좌 관리에 DreamBank 계정 진입점과 `/account/login` 화면 추가.
- Firebase Auth + Google Sign-In 네이티브 ID 토큰 인증, Apple 공급자 인증 구현.
- 사용자 이름, 제공된 이메일, UID 표시 및 로그아웃 구현.
- SDK 인증 스트림으로 재실행 시 저장된 세션을 화면에 반영하는 구조 구현.
- 진행 중 버튼 비활성화, 중복 요청 방지, 취소·오류 처리, 설정 미완료 안내 추가.
- 인증 계정으로 로컬 DB를 교체하거나 데이터를 초기화하지 않음.
- Android Google Services 조건부 적용·인터넷 권한, iOS Apple 로그인 entitlement 추가.

## 검증

- `flutter analyze`: 문제 없음.
- `flutter test`: 44개 통과.
- Android 에뮬레이터 `auth_entry_test.dart`: 계정 화면 진입, 설정 미완료 재시도,
  시스템 뒤로가기, 기존 로컬 계좌 동일성 검증 통과.
- Android debug APK 빌드 통과.
- iOS simulator debug 빌드 통과.
- `git diff --check`: 통과.
- 로그: [auth-evidence](auth-evidence/).

처음 선택한 Firebase Core 5.1.0/Auth 7.0.1 조합은 iOS에서 Google Sign-In 7.2.0의
네이티브 GTMSessionFetcher 버전 요구와 충돌했다. Core 4.15.2/Auth 6.7.1,
Google Sign-In 7.2.0으로 조정하여 양쪽 빌드를 검증했다.
Android 패키지 버전 변경 후 남은 플러그인 컴파일 캐시도 정리했다.
해결된 패키지는 pubspec.lock 및 SwiftPM Package.resolved에 기록되어 있다.
현재 Flutter/AGP 조합에서 Firebase 플러그인의 기존 Kotlin 플러그인 사용에 대한
향후 호환성 경고는 남지만 현재 빌드는 통과한다.

## 외부 설정이 필요한 부분

Firebase 프로젝트 설정 파일과 Google OAuth, Apple Developer 설정이 없으므로
실제 계정 로그인 성공과 네이티브 인증 세션 복원은 아직 검증하지 못했다.
기본 빌드는 로그인 준비 안내를 표시하며 로컬 앱으로 동작한다.
완료된 것으로 간주할 수 있는 범위는 인증 코드·화면·플랫폼 기반 및 빌드 검증까지다.

다음 단계는 [auth-setup.md](auth-setup.md)에 따라 실제 Firebase 프로젝트를 연결하고
Google·Apple 로그인을 실계정으로 검증하는 것이다. 그 뒤 랭킹의 UID 연결을 진행할 수 있다.
Apple private key나 서비스 계정 키를 앱 또는 저장소에 추가하지 않는다.
