# 개발 환경 보완 결과

작업일: 2026-10-29 (Asia/Seoul)

목적: Step 03 진입 전 [환경 조사](environment-report.md)에서 발견된 SDK·도구·실행 기기·의존성 문제를 순서대로 해결한다. 본 앱 생성은 아직 수행하지 않았고 검증용 앱은 `/tmp/dreambank-env-probe`에 분리했다.

## 1. Flutter SDK

`brew install --cask flutter`로 Apple Silicon stable SDK를 설치했다.

- Flutter 3.47.8, framework revision `737ba8f885`
- Dart 3.13.7, DevTools 2.60.0
- SDK 경로: `/opt/homebrew/share/flutter`
- 실행 명령: `/opt/homebrew/bin/flutter`, `/opt/homebrew/bin/dart`

## 2. 도구 연결과 진단

Android SDK에 `cmdline-tools;latest`, `platforms;android-36`, `emulator`, `system-images;android-36;google_apis;arm64-v8a`를 추가했다. SDK 설치에 필요한 라이선스 동의를 적용했다. 최종 doctor에서 Android toolchain과 라이선스가 통과했다. 이후 임시 앱 Android 빌드에서 요구한 NDK `28.2.13676358`과 `platforms;android-35`도 자동 설치되어 빌드에 사용됐다. 기존 도구는 유지했다.

Xcode의 전역 선택 경로는 여전히 CommandLineTools다. `sudo xcode-select --switch`는 관리자 암호가 없어 완료하지 못했다. 프로젝트 실행 스크립트에서 Xcode 경로를 명시하는 방법으로 해결했다.

일반적인 `DEVELOPER_DIR` 지정만으로 doctor는 통과했지만 iOS 네이티브 의존성 `objective_c`의 build hook에서 SDK 경로 조회가 실패했다. 설치된 `hooks_runner` 소스를 조사한 결과 build hook에 전달되는 환경변수에서 `DEVELOPER_DIR`가 제외되고 `PATH`는 유지됨을 확인했다. 따라서 프로젝트 전용 `xcrun` 래퍼가 해당 변수를 복원하도록 구성했다. SDK·패키지 캐시 소스를 수정하지 않았다.

- [Flutter 실행 스크립트](../scripts/flutterw): Xcode, Android SDK, JDK와 프로젝트 도구 경로 설정.
- [xcrun 래퍼](../scripts/toolchain/xcrun): `/usr/bin/xcrun` 실행 시 Xcode 경로 복원.
- 스크립트 셸 구문 검사 통과. `DEVELOPER_DIR`가 없는 상태의 래퍼 실행에서 iOS 시뮬레이터 SDK 경로 조회 성공.
- `sh scripts/flutterw doctor -v`: **No issues found!**
- JDK 21.0.11, Xcode 27.1, CocoaPods 1.17.0 확인.

이 컴퓨터에서는 `flutter` 단독 명령 대신 아래 실행 방식을 사용한다. 다른 컴퓨터에서는 스크립트의 도구 경로를 환경에 맞게 조정한다. `DEVELOPER_DIR`, `ANDROID_HOME`, `JAVA_HOME`은 외부에서 지정해 덮어쓸 수 있다.

```sh
sh scripts/flutterw --version
sh scripts/flutterw doctor -v
sh scripts/flutterw devices
```

## 3. Android 실행 기기

- AVD 이름: `DreamBank_API_36`
- 기기 프로필: Pixel 7
- 시스템: Android 16 / API 36, Google APIs, arm64-v8a
- emulator 37.2.12 설치 및 headless 부팅 성공.
- `adb shell getprop sys.boot_completed`: `1`
- Flutter 기기 조회: `emulator-5554`, android-arm64, Android 16 (API 36).

GUI 없이 검증하기 위해 다음 방식으로 실행했다. 이미 실행 중이면 같은 AVD를 중복 실행하지 않는다.

```sh
/Users/peter/Library/Android/sdk/emulator/emulator \
  -avd DreamBank_API_36 -no-window -no-audio -no-boot-anim \
  -gpu swiftshader_indirect
```

에뮬레이터 최초 실행에서 저장된 스냅샷이 없어 cold boot한다는 경고가 있었으나 부팅 완료와 Flutter 인식을 확인했다.

## 4. 의존성과 라이선스

임시 Android·iOS 프로젝트에서 아래 패키지를 실제로 해결했다. 이 조합을 Step 03의 시작점으로 사용하되 본 프로젝트의 잠금 파일은 프로젝트 생성 후 별도로 관리한다.

| 패키지 | 해결된 버전 | 라이선스·역할 |
|---|---|---|
| flutter_riverpod | 3.4.3 | MIT / 상태 관리 |
| go_router | 18.1.1 | BSD-3-Clause / 라우팅 |
| drift | 2.35.3 | MIT / DB |
| drift_flutter | 0.3.1 | MIT / Flutter DB 연결 |
| shared_preferences | 2.5.6 | BSD-3-Clause / 설정 |
| path_provider | 2.1.6 | BSD-3-Clause / 저장 경로 |
| share_plus | 13.3.1 | BSD-3-Clause / 공유 |
| drift_dev | 2.35.2 | MIT / 개발용 코드 생성 |
| build_runner | 2.17.1 | BSD-3-Clause / 개발용 코드 생성 실행 |

공식 [share_plus 라이선스](https://pub.dev/packages/share_plus/license) 원문에서 BSD-3-Clause를 확인했다. Drift의 연결 방식은 [공식 Flutter 설치 지침](https://drift.simonbinder.eu/setup/)에 따라 `drift_flutter`를 사용했다. 모두 Android·iOS 지원을 확인한 후보를 실제 SDK에서 의존성 해결했다.

임시 프로젝트의 외부 hosted 패키지 115개에서 라이선스 파일을 모두 발견했다. 라이선스 텍스트의 계열은 BSD 계열 99개, MIT 12개, Apache 계열 4개다. 이는 설치 패키지 원문의 확인과 분류이며 네이티브 도구·운영체제 전체 라이선스 감사는 아니다. 실제 배포 시 앱 라이선스 안내에 최종 의존성의 고지를 포함한다.

의존성 해결에서 일부 더 최신 버전이 존재하지만 현재 제약과 호환되지 않는다는 안내가 있었다. 최신 번호만을 목적으로 강제 업그레이드하거나 dependency override를 추가하지 않았다. `drift_flutter`의 전이 의존성에는 `sqlite3_flutter_libs`·`sqlcipher_flutter_libs`의 `+eol` 버전이 포함된다. 직접 암호화 기능을 도입한 것은 아니며 실제 앱에서는 생성된 연결 방식과 사용 플러그인을 확인한다.

검증 증거:

- [임시 pubspec](environment-evidence/probe-pubspec.yaml)
- [해결된 의존성 잠금 파일](environment-evidence/probe-pubspec.lock)
- [전체 패키지 라이선스 목록](environment-evidence/dependency-license-inventory.json)
- [doctor 결과](environment-evidence/flutter-doctor.txt)
- [Flutter 기기 목록](environment-evidence/flutter-devices.txt) — 실제 기기 ID 비식별화.

## 5. 검증용 앱

`dev.dreambank.dreambankEnvProbe`는 임시 검증 식별자이며 출시용 식별자가 아니다. 기본 카운터 앱에 위 의존성을 추가했으며 실제 DreamBank 기능을 구현하거나 테스트한 것으로 간주하지 않는다.

| 검사 | 결과 |
|---|---|
| Flutter 프로젝트 생성 | 성공 |
| 패키지 및 개발 도구 의존성 해결 | 성공 |
| 정적 분석 | No issues found |
| 기본 위젯 테스트 | 1개 통과 |
| iOS 시뮬레이터 debug 빌드 | 성공, `build/ios/iphonesimulator/Runner.app` |
| Android 에뮬레이터 부팅 및 Flutter 인식 | 성공 |
| Android debug 빌드 | 성공, `build/app/outputs/flutter-apk/app-debug.apk` |
| Android APK 설치·실행 | 설치 Success, `am start -W` Status: ok, MainActivity COLD 실행 1823ms |

[iOS 빌드 로그](environment-evidence/probe-ios-build.txt)와 [Android 빌드 로그](environment-evidence/probe-android-build.txt)를 보관했다. Android 최초 빌드는 도구 다운로드를 포함해 445.2초 걸렸다. SDK XML 버전 차이 경고가 있었으나 빌드·설치·실행은 성공했다. 해당 경고를 해결하기 위해 검증된 플러그인이나 SDK를 임의로 변경하지 않는다.

iOS는 시뮬레이터용 빌드까지 확인했고 이번 작업에서 해당 앱의 시뮬레이터 실행은 수행하지 않았다. 실기기 서명·스토어 배포·DreamBank 사용자 기능은 이번 환경 보완 검증에 포함하지 않는다.

## 6. 최종 판정 및 Step 03 진입

- [x] Flutter/Dart stable 설치·버전 확정
- [x] Android·Xcode 도구 연결과 doctor 전 항목 통과
- [x] Android 라이선스 확인과 실행 기기 준비·부팅
- [x] 의존성 실제 해결과 라이선스 파일 확인
- [x] 선택한 도구·패키지 조합으로 Android debug 및 iOS 시뮬레이터 debug 빌드
- [x] Android 임시 앱 설치·실행 확인
- [x] 실행 스크립트와 진단·의존성 증거 문서 저장

**Step 03 진입을 막던 환경 문제는 해결됐다.** 다음 단계에서는 위 스크립트를 사용해 작업 디렉터리에 실제 DreamBank 프로젝트를 생성하고 테마·Riverpod·4개 탭을 구성한다. 임시 앱 테스트 통과를 DreamBank 기능 테스트 통과로 간주하지 않는다. 최종 패키지 식별자·서명·실기기 검증은 계획된 단계에서 진행한다.
