# Step 01 — 개발 환경 및 프로젝트 조사 결과

조사일: 2026-10-28~29 (Asia/Seoul)

> 후속 상태: 2026-10-29 SDK 설치와 도구 보완을 진행했다. 이 문서 아래는 최초 조사 기록이며, 최신 결과와 실행 방법은 [개발 환경 보완 결과](environment-remediation.md)를 따른다.

## 1. 판정

환경 조사를 수행했다. Flutter/Dart를 현재 PATH와 조사한 일반 설치 경로에서 찾지 못하여 Flutter SDK 버전 확정, `flutter doctor -v`, 앱 실행 및 빌드 검증은 아직 수행할 수 없다. **조사 결과는 확보했으나 Step 01의 SDK 확정 항목은 미완료**다.

Android SDK와 Xcode는 설치되어 있다. Android 연결 기기는 없고 기본 SDK 경로에 에뮬레이터가 없다. iOS 시뮬레이터와 페어링된 실제 iPhone은 조회할 수 있다. 플랫폼 도구가 존재한다는 사실은 Flutter 앱 빌드 성공을 의미하지 않는다.

이번 작업에서는 환경 조회와 문서 작성만 수행했다. SDK 설치, 전역 Xcode 경로 변경, 프로젝트 생성, Git 초기화, 앱 설치·실행은 수행하지 않았다. 기기 조회 중 ADB 서버가 시작되었다.

## 2. 프로젝트 상태

작업 경로: `/Users/peter/workSpace/DreamBank`

조사 시작 시 파일:

```text
docs/
  development-prompt.md
  development-technical-spec.md
  development-plan.md
```

- Flutter 프로젝트, `pubspec.yaml`, 플랫폼 프로젝트 및 앱 소스 없음.
- `git status --short`: `fatal: not a git repository` — Git 저장소 미초기화.
- 조사한 프로젝트 파일 목록에서 `AGENTS.md` 발견되지 않음.
- 기존 앱 구조나 의존성에 의한 제약은 확인되지 않음.

## 3. 로컬 도구 확인 결과

| 항목 | 실제 확인 결과 | 의미 및 조치 |
|---|---|---|
| 호스트 | macOS 26.6.2, build 25G83, arm64 | Apple Silicon용 Flutter SDK 사용 |
| Flutter | `command -v flutter` 미발견, `flutter --version` 실행 불가 | SDK 설치 또는 기존 경로 탐색 필요 |
| Dart | `command -v dart` 미발견, `dart --version` 실행 불가 | Flutter에 포함된 Dart 사용 예정 |
| Java | OpenJDK 21.0.11 | 실제 Gradle 조합 호환성은 프로젝트 생성 후 검증 |
| Git | 2.54.0 | 도구는 사용 가능, 프로젝트 저장소는 없음 |
| Android SDK | `/Users/peter/Library/Android/sdk` | SDK 경로를 Flutter에 명시할 예정 |
| Android platform | 디렉터리 `android-37.0`, 속성 `AndroidVersion.ApiLevel=37.0` | 생성 프로젝트의 compileSdk와 대응 확인 필요 |
| Build Tools | 36.0.0, 37.0.0 | 설치 확인, 실제 사용 버전 미확정 |
| ADB | 1.0.41, 배포 버전 37.0.1-15733141 | 절대 경로로 실행 가능, PATH에는 없음 |
| sdkmanager | `/opt/homebrew/bin/sdkmanager` | 표준 SDK의 `cmdline-tools` 디렉터리는 없음; Flutter doctor로 인식 확인 필요 |
| Android emulator | 기본 SDK 경로에 없음 | 실행 검증용 에뮬레이터 설치 또는 실기기 연결 필요 |
| Android AVD | `~/.android/avd` 없음 | 기본 위치에 가상 기기 없음 |
| 활성 개발 경로 | `/Library/Developer/CommandLineTools` | 기본 `xcodebuild -version` 실패 |
| Xcode 앱 | `/Applications/Xcode.app`, Xcode 27.1, build 27A9275 | 명령에 `DEVELOPER_DIR`를 지정하면 버전 조회 성공 |
| CocoaPods | 1.17.0 | 설치 확인, pod 설치는 미수행 |

Flutter 추가 조사 경로: `~/development/flutter`, `~/Development/flutter`, `~/flutter`, `~/workSpace/flutter`, `/opt/flutter`, `/opt/homebrew/share/flutter`, `/opt/homebrew/Caskroom/flutter`. 모두 해당 경로가 없었다. 전체 디스크를 검색하지 않았으므로 다른 위치의 설치 가능성은 배제하지 않는다.

Android SDK에 `licenses`, `cmake`, `ndk` 디렉터리도 존재한다. 라이선스 수락 상태와 세부 도구 호환성은 아직 검증하지 않았다.

## 4. 기기 및 플랫폼별 준비 상태

| 플랫폼 | 조회 결과 | 현재 가능한 범위 | 남은 검증 |
|---|---|---|---|
| Android | `adb devices -l` 성공, 연결 기기 0개 | SDK·ADB 설치 확인 | Flutter doctor, Android 도구·라이선스, Gradle 빌드, 기기 실행 |
| iOS 시뮬레이터 | iOS 27.1에 가상 기기 2개, 모두 Shutdown | Xcode 경로 지정 후 기기 조회 | Flutter 지원 여부, 시뮬레이터 빌드·실행 |
| iOS 실기기 | iPhone 15 Pro, available (paired) | 연결 기기 조회 | 개발자 모드·서명·앱 설치·실행 |

조회된 시뮬레이터 이름은 `Finish Coach iPhone`, `iPhone Duo`다. 기존 다른 프로젝트용 기기를 수정하지 않았다. DreamBank 실행 때 별도 가상 기기 사용 여부를 결정한다. 실기기 식별자는 문서에 복제하지 않는다.

최초 ADB 및 CoreSimulator 조회는 샌드박스 제한으로 실패했다. 권한을 요청해 동일 조회를 샌드박스 밖에서 다시 수행한 결과 성공했다. 따라서 최초 오류를 도구 미설치나 시뮬레이터 손상으로 판단하지 않는다.

## 5. 기술 선택 및 의존성 후보

기준 문서대로 Flutter/Dart와 Material 3 기반 UI를 사용한다. 단일 코드베이스, 로컬 데이터, 네이티브 공유 요구에 맞는다. SDK는 macOS arm64용 **stable 채널**을 선택한다. 공식 자료에서 stable 채널을 새 사용자와 운영 배포에 권장한다. 정확한 Flutter/Dart 번호는 실제 설치와 doctor 확인 후 확정한다. [Flutter 설치](https://docs.flutter.dev/install), [SDK 아카이브](https://docs.flutter.dev/install/archive)

아래 버전은 조사 시 공식 패키지 페이지에 표시된 후보이며 프로젝트에 확정하거나 설치한 버전이 아니다. 모두 Android·iOS 지원 표기가 있고 최근 릴리스가 확인된다. 최종 호환성은 SDK 설치 후 의존성 해결과 양 플랫폼 빌드로 확인한다.

| 패키지 | 조사 시 버전 | 용도 | 라이선스 | 판단 |
|---|---|---|---|---|
| [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) | 3.4.3 | 상태·비동기 데이터 관리 | MIT | 필수 후보, 별도 코드 생성 패키지는 우선 생략 |
| [go_router](https://pub.dev/packages/go_router) | 18.1.1 | 탭과 상세 화면 라우팅 | BSD-3-Clause | 필수 후보, 공식 설명상 안정성·버그 수정 중심 관리 |
| [drift](https://pub.dev/packages/drift) | 2.35.3 | SQLite 기반 영속 데이터 | MIT | 필수 후보, 생성 도구와 연결 방식은 도입 단계에서 검증 |
| [shared_preferences](https://pub.dev/packages/shared_preferences) | 2.5.6 | 간단한 사용자 설정 | BSD-3-Clause | 핵심 사용자 기록은 Drift에 저장 |
| [share_plus](https://pub.dev/packages/share_plus) | 13.3.1 | OS 공유 시트와 이미지 전달 | 라이선스 원문 추가 확인 필요 | P1 도입 전 요구 도구 버전 확인 |
| [path_provider](https://pub.dev/packages/path_provider) | 2.1.6 | DB·공유 이미지 저장 경로 | BSD-3-Clause | 파일 저장 구현 시 도입 |

각 링크의 게시 시점과 플랫폼·라이선스 정보를 조회했다. `share_plus` 라이선스 상세와 전체 전이 의존성 라이선스 확인은 도입 전에 보완한다. 최신 표시 버전을 무조건 채택하지 않는다.

`share_plus` 13.3.1의 명시 요구사항은 Flutter ≥3.38.1, Dart ≥3.10.0 <4.0.0, iOS ≥13.0, Java 17, Kotlin 2.2.0, AGP ≥8.12.1, Gradle ≥8.13이다. 현재 Java는 21이므로 이 조합의 동작은 아직 확인되지 않았다. Flutter가 선택하는 JDK와 생성 프로젝트의 Gradle 설정을 먼저 확인하고 필요하면 프로젝트별 도구 설정을 조정한다. [공식 요구사항](https://pub.dev/packages/share_plus#requirements)

`flutter_test`와 `integration_test`는 SDK 제공 도구를 사용하고, Drift 코드 생성에 필요한 `drift_dev`, `build_runner` 등은 실제 SDK와의 버전 해결 단계에서 조사한다. 이미지 렌더링은 Flutter 자체 기능을 우선 사용해 불필요한 캡처 패키지를 줄인다.

앱 패키지명·Bundle Identifier 및 출시용 서명은 아직 정하지 않았다. 프로젝트 생성 시 개발용 식별자와 최종 출시 식별자를 구분해 설정 파일에서 관리한다.

## 6. 수행 명령 및 결과

| 명령 또는 점검 | 결과 |
|---|---|
| `ls -la`, `rg --files ...`, `git status --short` | 문서만 존재, Git 저장소 없음 |
| `command -v flutter dart java adb sdkmanager xcodebuild xcrun pod` | Flutter/Dart/ADB는 PATH에서 미발견, 나머지 경로 확인 |
| `flutter --version`, `dart --version` | command not found |
| `java -version`, `pod --version`, `git --version` | 버전 확인 성공 |
| `uname -m`, `sw_vers` | OS와 아키텍처 확인 성공 |
| `xcode-select -p`, 기본 `xcodebuild -version` | CommandLineTools 선택 상태 확인, Xcode 버전 조회 실패 |
| `DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -version` | Xcode 버전 조회 성공 |
| SDK 디렉터리 및 플랫폼 `source.properties` 조회 | 설치된 SDK·Build Tools 확인 |
| ADB 절대 경로의 `version`, `devices -l` | 버전 확인 성공; 기기 조회는 권한 확보 후 성공 |
| Xcode 경로 지정 후 `xcrun simctl list devices available` | 권한 확보 후 시뮬레이터 조회 성공 |
| Xcode 경로 지정 후 `xcrun devicectl list devices` | 실기기 조회 성공 |
| `flutter doctor -v` | 미실행: Flutter 명령 사용 불가 |
| 의존성 해결·정적 분석·테스트·플랫폼 빌드 | 미실행: SDK 및 앱 프로젝트 없음 |

## 7. 환경 보완 및 다음 작업

| 순서 | 작업 | 완료 증거 |
|---|---|---|
| 1 | 기존 Flutter 설치가 별도 위치에 있는지 확인하거나 stable arm64 SDK 설치 | 절대 경로 `flutter --version`과 Dart 버전 |
| 2 | 명령별 `DEVELOPER_DIR`와 Android SDK 경로를 지정하고 `flutter doctor -v` 실행 | doctor 결과와 구체적인 수정 항목 |
| 3 | 선택 SDK에 맞춰 Android command-line tools·플랫폼·라이선스 보완 | doctor의 Android toolchain 점검, 필요한 패키지 목록 |
| 4 | Android 에뮬레이터/AVD 준비 또는 실제 기기 연결 | `flutter devices`에서 Android 기기 조회 |
| 5 | 의존성 최소 SDK·라이선스 확인과 버전 해결 | 확정 SDK 기록, 이후 `pubspec.yaml`·잠금 파일 |
| 6 | Step 02의 화면·데이터 설계 진행 | `mvp-design.md`, `data-model.md` |
| 7 | Step 03에서 앱 및 Git 초기화, 플랫폼별 첫 실행 | 프로젝트 파일과 실제 실행 결과 |

SDK 설치가 필요한 상태에서도 화면·데이터 설계는 진행할 수 있다. 다만 SDK 확정과 doctor 확인을 생략한 채 환경 준비 완료로 처리하지 않는다. 전역 Xcode 선택을 바꾸지 않고 명령별 `DEVELOPER_DIR` 지정으로 기존 프로젝트 영향을 줄인다.

## 8. Step 01 완료 조건 점검

- [x] 기존 프로젝트와 Git 상태 확인
- [x] 사용 가능한 도구 버전 및 경로 조사
- [x] Android·iOS 기기 조회와 플랫폼별 제약 기록
- [x] 기술 스택 방향, 의존성 후보 및 후속 조치 정리
- [ ] 실제 Flutter/Dart 버전 확정
- [ ] `flutter doctor -v` 실행과 도구 호환성 확인
- [ ] 패키지 도입 전 라이선스·버전 요구사항 최종 확인

**최종 상태: 환경 조사 결과 문서화 완료, 개발 환경 준비는 보완 필요. 앱 테스트와 Android·iOS 빌드는 아직 미검증.**
