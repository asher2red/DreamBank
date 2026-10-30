# DreamBank

A little escape from money worries.

실제 금융 서비스가 아닌, 잠시 마음의 여유를 위한 가상 은행 앱입니다.
현재 Step 05 P0 기능 구현을 완료했습니다. 실제 로컬 계좌의 잔고 표시·별칭 및 잔고 편집·마음 기록·기분별 위로 메시지·첫 안내 확인을 사용할 수 있습니다. 꿈·편지 편집과 카드 공유는 후속 단계에서 연결합니다.

## 개발 환경과 실행

Flutter 3.47.8 stable / Dart 3.13.7. Android와 iOS를 지원합니다.
현재 Mac의 Xcode·Android SDK 연결은 프로젝트 실행 스크립트로 관리합니다.

```sh
sh scripts/flutterw pub get
sh scripts/flutterw devices
sh scripts/flutterw run -d emulator-5554
# iOS는 devices에 표시된 부팅된 시뮬레이터 ID 사용
sh scripts/flutterw run -d <simulator-id>
```

다른 컴퓨터에서는 `scripts/flutterw`의 경로를 조정하거나 정상 구성된 Flutter CLI를 사용하세요.
Xcode의 전역 선택 경로가 CommandLineTools인 현재 환경에서는 프로젝트 스크립트를 사용해야 합니다.
자세한 내용은 [환경 보완 결과](docs/environment-remediation.md)를 참고하세요.

## 검증과 빌드

```sh
/opt/homebrew/bin/dart format --output=none --set-exit-if-changed lib test
sh scripts/flutterw analyze
sh scripts/flutterw test
sh scripts/flutterw build apk --debug
sh scripts/flutterw build ios --simulator --debug
```

Android APK: `build/app/outputs/flutter-apk/app-debug.apk`

iOS 시뮬레이터 앱: `build/ios/iphonesimulator/Runner.app`

플랫폼 식별자 `dev.dreambank.dreambank`는 개발용입니다. 출시 전 소유 도메인 기준으로 확정해야 합니다.
iOS 개발 팀과 출시 서명은 미설정이며 Android 릴리스 템플릿의 디버그 서명은 출시 전에 교체해야 합니다.

## 구조

```text
lib/
  main.dart                     # ProviderScope 진입점
  app/                          # 앱·라우터·디자인 토큰
  core/widgets/                 # 페이지·카드·상태 안내·브랜드·탭 셸
  features/
    home/presentation/
    dream_vault/presentation/
    letters/presentation/
    account/presentation/
test/widget_test.dart           # 이동·뒤로가기·스크롤·화면 배율 검증
scripts/                        # 개발 도구 연결 및 앱 아이콘 생성
```

`lib/data/database/`는 Drift 테이블·연결·스키마를, `lib/data/repositories/`는 계좌·마음·꿈·편지·설정 접근을 관리합니다. `lib/data/storage_providers.dart`에서 Riverpod에 연결하고 `lib/app/storage_gate.dart`에서 초기화와 오류 재시도를 처리합니다.

DB 생성 코드와 스키마 스냅샷은 저장소에 포함합니다. 스키마 수정 시 다음 명령을 실행하고 버전 간 데이터 보존 테스트를 추가하세요.

```sh
sh scripts/flutterw pub run build_runner build
sh scripts/flutterw pub run drift_dev make-migrations
sh scripts/flutterw test integration_test/storage_smoke_test.dart -d <device-id>
```

통합 테스트는 테스트 기기에서 실행하세요. 검증용 꿈·편지를 생성 후 삭제하고 온보딩 설정을 원래 값으로 복원합니다. 기본 계좌가 없으면 정상 초기화 과정에서 생성합니다.
아이콘은 `python3 scripts/generate_app_icons.py`로 생성 마스터에서 다시 내보낼 수 있습니다. 화면 이미지는 `python3 scripts/prepare_image_assets.py`로 최적화합니다. 두 스크립트는 macOS의 sips를 사용합니다.

## 개발 문서

- [개발 계획](docs/development-plan.md)
- [화면 설계](docs/mvp-design.md)
- [데이터 모델](docs/data-model.md)
- [인수 조건](docs/acceptance-criteria.md)
- [Step 03 결과](docs/step03-report.md)

- [Step 04 결과](docs/step04-report.md)

- [Step 05 결과](docs/step05-report.md)

- [이미지 적용 결과 및 화면](docs/artwork-integration-report.md)
