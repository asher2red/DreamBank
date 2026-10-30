# Step 03 — Flutter 프로젝트와 앱 기반 구성 결과

작업일: 2026-10-29 (Asia/Seoul)

## 1. 결과와 범위

Android·iOS Flutter 프로젝트를 생성하고 4개 탭, Riverpod 진입점, go_router 라우팅과 공통 테마를 구현했다. 현재 단계는 앱 기반 구성이다. 실제 가상 계좌 저장·마음 선택·꿈과 편지 CRUD·카드 공유는 구현하지 않았고 준비 상태를 안내한다. 사용하지 않는 저장 버튼이나 가짜 계좌 데이터를 노출하지 않는다.

## 2. 구현 결과물

| 영역 | 파일 및 동작 |
|---|---|
| 프로젝트 | `pubspec.yaml`, `pubspec.lock`, Android·iOS 플랫폼 파일, Git main 초기화 |
| 앱 | `lib/main.dart`, `lib/app/app.dart` — ProviderScope, 한국어, Material 3 다크 테마 |
| 상태·라우팅 | `lib/app/router.dart` — Riverpod Provider에서 router 수명 관리, StatefulShellRoute로 탭별 화면 유지 |
| 디자인 | `lib/app/theme/` — 네이비·골드·아이보리 색상, 타이포그래피, 간격·반경·모션 토큰 |
| 공통 UI | `lib/core/widgets/` — 공통 카드, 화면 폭 제한·스크롤, 제목, 상태 안내, 별 로고, 하단 탭 |
| 화면 | 홈, 꿈 보관함, 미래의 편지, 내 계좌 및 앱 소개 |
| 플랫폼 브랜드 | 표시 이름 DreamBank, Android·iOS 앱 아이콘, 어두운 시작 배경 |
| 아이콘 생성 | `scripts/generate_app_icons.py` — 외부 의존성 없이 기하학적 별 아이콘 20개 항목 생성 |
| 검증 | `test/widget_test.dart`, 이 문서와 `step03-evidence/` |
| 실행 안내 | 루트 README |

기반 의존성은 Riverpod 3.4.3, go_router 18.1.1, SDK 제공 flutter_localizations, flutter_test 및 flutter_lints 6.0.0이다. 아직 사용하지 않는 DB·공유 패키지는 실제 구현 단계에 추가한다. Flutter 기본 템플릿의 사용하지 않는 cupertino_icons 의존성은 제거했다.

영속 저장소가 없는 현재 단계에서는 실제 초기화 로직을 모방하지 않는다. 홈은 준비 상태와 정적인 위로 문구를 제공한다. 데이터·Repository·Domain 계층은 Step 04부터 실제 책임에 맞춰 추가한다.

## 3. 화면 동작

- 홈 / 꿈 보관함 / 미래의 편지 / 내 계좌를 하단 탭으로 이동한다.
- 탭 전환 후 홈의 스크롤 위치를 유지한다.
- 홈의 꿈 보관함 진입 버튼으로 해당 탭을 연다.
- 내 계좌 → DreamBank 소개는 루트 Navigator 위에 열어 하단 탭을 숨긴다. 뒤로가기 시 내 계좌로 복귀한다.
- 앱 소개에서 가상 금융·로컬 저장 계획·편지 공개 규칙과 오픈소스 라이선스를 확인한다.
- 잘못된 경로는 오류 안내와 홈 이동 버튼을 제공한다.
- SafeArea와 세로 스크롤, 최대 콘텐츠 폭 600을 적용했다. 강제 고정 높이의 콘텐츠 카드는 사용하지 않는다.

## 4. 검증 결과

| 항목 | 실제 결과 |
|---|---|
| 정적 분석 | `sh scripts/flutterw analyze` — No issues found |
| 위젯 테스트 | `sh scripts/flutterw test` — 11개 통과 |
| 탭·상세·오류 경로 | 탭 이동, 소개 진입·뒤로가기, 잘못된 경로 복구 검증 |
| 스크롤 유지 | 홈 스크롤 후 다른 탭 왕복 시 동일 위치 검증 |
| 화면 조합 | 폭 320·430·800 × 글자 배율 1.0·1.3·2.0, 전체 탭 및 홈 진입 버튼 접근 검증 |
| Android debug 빌드 | APK 생성 성공 |
| Android 실행 | API 36 ARM64 에뮬레이터 설치 Success, MainActivity 실행 Status: ok (COLD 1740ms) |
| iOS 시뮬레이터 debug 빌드 | Runner.app 생성 성공 |
| iOS 실행 | iOS 27.1 iPhone Duo 시뮬레이터 설치·launch 성공, 홈 렌더링 확인 |

첫 테스트에서 Flutter 테스트 도우미 `pageBack()`이 한국어 뒤로가기 버튼을 찾지 못했다. 소개 화면의 BackButton을 명시하고 테스트는 해당 버튼을 직접 탭하도록 변경했다. 변경 후 전체 테스트가 통과했다.

iPhone Duo의 기본 화면 캡처 대상이 비활성 디스플레이여서 검은 이미지가 나왔다. `simctl io ... screenshot --display=1`로 활성 디스플레이를 지정해 홈 렌더링을 확인했다.

증거 파일:

- [정적 분석](step03-evidence/analyze.txt)
- [위젯 테스트](step03-evidence/tests.txt)
- [Android 빌드](step03-evidence/android-build.txt)
- [iOS 빌드](step03-evidence/ios-build.txt)
- [Android 홈 화면](step03-evidence/android-home.png)
- [iOS 홈 화면](step03-evidence/ios-home.png)

스크린샷은 홈 렌더링의 증거이며 모든 기능의 수동 검증을 의미하지 않는다. 양 플랫폼 실기기·릴리스·스토어 서명은 이 단계에서 검증하지 않았다. 접근성 읽기 순서와 색 대비의 전체 감사는 후속 검증 단계에 남아 있다.

## 5. 플랫폼 설정 및 다음 단계

개발용 Android applicationId와 iOS Bundle Identifier는 `dev.dreambank.dreambank`다. 최종 출시 식별자가 아니다. Flutter가 자동 감지한 개인 iOS 개발 팀 설정은 프로젝트에서 제거했다. 서명 키·비밀번호는 추가하지 않았다. Git 저장소는 초기화했으며 커밋·원격 연결·푸시는 수행하지 않았다.

Step 03 완료 조건인 앱 실행, 4개 탭 이동, 공통 구조·테마, 정적 분석과 기본 위젯 검증을 충족했다. 다음 Step 04에서는 Drift 스키마와 기본 계좌의 멱등 초기화, Repository·설정 저장소·Provider를 구현하고 파일 DB 재연결 테스트를 수행한다.
