# Step 04 — 로컬 저장소 및 Repository 구현 결과

작업일: 2026-10-29 (Asia/Seoul)

## 1. 결과

계좌·마음 기록·꿈·편지용 Drift DB v1과 Repository, shared_preferences 설정 저장소, Riverpod 연결을 구현했다. 앱 시작 시 실제 DB를 열고 기본 계좌를 보장하며, 실패하면 기록을 초기화하지 않고 오류·재시도 화면을 제공한다.

이번 단계는 데이터 기반 구현이다. 홈 잔고 표시와 마음 선택 UI 연결은 Step 05에서, 꿈·편지 편집 화면은 Step 07·08에서 구현한다. 현재 화면은 기존의 준비 상태를 유지한다.

## 2. 생성·변경한 구조

| 파일·디렉터리 | 책임 |
|---|---|
| `lib/data/database/tables.dart` | 4개 테이블, null·기본값·CHECK 제약, 3개 복합 인덱스 |
| `lib/data/database/app_database.dart` 및 `.g.dart` | Drift DB v1, 타입 안전 모델·쿼리, 트랜잭션 생성, 미지원 스키마 거부 |
| `lib/data/database/open_database.dart` | Application Support의 `dreambank.sqlite`, 비동기 네이티브 연결 |
| `lib/data/repositories/` | 계좌 초기화·수정·조회, 마음 추가·최신 조회, 꿈·편지 CRUD, 설정 읽기·안내 확인 저장 |
| `lib/data/storage_providers.dart` | DB 수명, 주입 가능한 시계, Repository·초기화·조회 스트림·설정 Provider |
| `lib/app/storage_gate.dart` | 초기화 대기, 안전한 오류 안내, DB 연결 재생성 후 재시도 |
| `lib/core/errors/storage_failure.dart` | 입력·대상 없음·조회·쓰기·호환성 오류 분리, 원문 예외 노출 방지 |
| `lib/core/utils/input_validation.dart` | 공백 정리, 한 줄·문자 길이·금액·시각 검증 |
| `lib/features/mood/domain/mood_type.dart` | 네 가지 마음 enum |
| `lib/features/letters/domain/letter_date.dart` | 유효한 달력 날짜·공개일 판정 |
| `build.yaml`, `drift_schemas/` | 코드 생성 설정과 최초 v1 스냅샷 |
| `test/unit/`, `test/widget/`, `integration_test/` | 저장소·Provider·오류 UI·실제 플랫폼 저장 검증 |

## 3. 저장 규칙과 안전성

- 기본 계좌는 ID 1, `나의 여유 계좌`, `1000000000`, `KRW`다. 초기화 트랜잭션에서 PK 충돌 시 아무것도 변경하지 않는다. replace 방식으로 기존 기록을 덮어쓰지 않는다.
- 별칭만 수정하거나 잔고만 수정할 때 변경한 필드만 갱신한다. 최초 작성일은 유지한다.
- 금액은 0~999999999999 정수 원이며 비용 NULL과 0원을 구분한다. 꿈 비용과 계좌 잔고는 독립적이다.
- 시각은 UTC epoch milliseconds, 공개일은 유효한 `YYYY-MM-DD` 문자열이다. 공개 여부는 현재 현지 날짜로 계산하고 DB에 저장하지 않는다.
- 목록은 수정 시각 DESC, ID DESC로 정렬한다. 같은 방향의 복합 인덱스를 역방향 탐색한다. 마음 기록은 생성 시각 DESC, ID DESC로 최신 항목을 조회한다.
- 꿈·편지의 없는 ID 수정·삭제는 notFound로 처리한다. 계좌 삭제 API와 마음 이력 편집 UI는 추가하지 않았다.
- 저장은 실제 DB 작업 성공 후 완료된다. 조회 스트림의 오류도 안전한 StorageFailure로 변환한다. SQL·바인딩 값·개인 텍스트를 로깅하거나 사용자 오류 문구에 포함하지 않는다.
- 기본 계좌가 준비되기 전 앱 화면을 열지 않는다. 초기화 실패는 자동 재시도 루프 대신 사용자가 재시도하도록 한다. 큰 글자·작은 화면에서도 오류 안내와 재시도 버튼을 스크롤로 읽을 수 있다.
- 설정은 SharedPreferencesAsync로 DB와 분리한다. 설정 읽기 실패는 다크 테마·안내 미확인 기본값과 readFailed 상태로 반환한다. 설정 쓰기 실패는 성공으로 처리하지 않는다. 설정 실패가 DB 초기화를 차단하지 않는다.
- DB v1보다 높은 버전을 만나면 호환성 오류를 반환한다. 실제 파일을 사용한 테스트에서 기존 데이터와 버전이 유지됨을 확인했다.
- DB 파일을 Git에서 제외했다. 현재 DB는 암호화하지 않으며 별도 백업·서버·로그인·동기화는 구현하지 않았다. OS 자동 백업 정책은 아직 조정·검증하지 않았으며 후속 플랫폼 검증 때 확인해야 한다.

## 4. 의존성

실제 잠금 파일에 Drift 2.35.3, drift_flutter 0.3.1, shared_preferences 2.5.6, path_provider 2.1.6, characters 1.4.1을 추가했다. 개발 도구는 drift_dev 2.35.2, build_runner 2.17.1, SDK 제공 integration_test를 사용한다.

`characters`는 한글·이모지의 사용자 인식 문자 길이를 검사한다. `drift_flutter`와 path_provider는 앱 전용 경로와 네이티브 SQLite 연결을 제공한다. 실제 패키지 버전은 `pubspec.lock`을 기준으로 한다. 공유용 패키지는 아직 추가하지 않았다.

구현 시 [Drift 마이그레이션 지침](https://drift.simonbinder.eu/migrations/)과 [shared_preferences의 비동기 API 안내](https://pub.dev/packages/shared_preferences)를 확인했다. 현재 버전 간 변환은 없고 v1 생성과 미래 버전 거부를 검증했다. 이를 v1→v2 데이터 변환 검증 완료로 보고하지 않는다.

## 5. 검증 결과

| 항목 | 결과 및 근거 |
|---|---|
| Drift 코드 생성 | 성공, 생성 코드와 v1 JSON 스냅샷 보관 |
| 정적 분석 | No issues found |
| 단위·위젯 테스트 | **28개 통과** |
| Android 실제 저장 통합 테스트 | **1개 통과**, API 36 ARM64 에뮬레이터 |
| iOS 실제 저장 통합 테스트 | **1개 통과**, iOS 27.1 시뮬레이터 |
| 최종 Android debug 빌드 | APK 생성 성공 |
| 최종 iOS 시뮬레이터 debug 빌드 | Runner.app 생성 성공 |
| 실제 앱 시작 | Android·iOS에서 DB 초기화 후 홈 진입 확인 |
| Android 프로세스 종료·재실행 | SQLite v1 유지, 계좌 1개, 계좌 값과 작성 시각 동일 |

단위·위젯 검증 범위:

- 초기화 동시 요청 10개와 수정 후 재초기화에서 계좌 중복·초기화 없음.
- 부분 계좌 수정, 금액 경계, 가족 이모지 30자 길이, 빈 값·한 줄 위반 거부.
- 꿈·편지 CRUD, nullable 비용·공개일, 정렬, 작성일 유지, 없는 ID 오류.
- 계좌·마음·꿈·편지의 관찰 스트림에 commit 결과 전파.
- 실제 SQLite 제약·인덱스 생성과 트랜잭션 rollback 확인.
- 파일 DB를 닫고 다시 열어 계좌·마음·꿈·편지 및 삭제 결과 유지.
- 미지원 스키마 거부 후 새 버전으로 재연결했을 때 기록 보존.
- 닫힌 DB의 조회·쓰기·스트림 오류 분류, 설정 오류의 기본값·실패 반환.
- Provider의 초기화 순서·변경 전파·설정과 DB 실패 독립성.
- 시작 로딩·오류·재시도 복구, 호환성 오류 안내와 작은 화면 접근성.
- 기존 4개 탭·뒤로가기·스크롤 유지와 화면 폭·글자 배율 테스트 회귀 통과.

통합 테스트는 실제 플랫폼 DB 파일에 꿈·편지를 쓰고 연결 종료 후 재조회했다. 검증용 기록은 삭제했으며 온보딩 설정은 원래 값으로 복원했다. Android에서 꿈·편지 테스트 행이 남지 않았음도 파일 조회로 확인했다. 통합 테스트의 연결 재개방과 Android의 실제 프로세스 재시작은 구분해 검증했다.

개발 중 오류 주입 테스트에서 스트림 예외가 원문으로 전달되는 문제를 발견했다. `yield*` 대신 `await for`로 오류를 받아 안전한 오류로 변환하도록 수정한 뒤 통과했다. Provider 테스트는 실제 화면처럼 활성 구독을 유지해야 일시정지 없이 데이터를 받을 수 있어 구독 수명을 수정했다. 테스트용 별도 DB의 동시 생성을 피하도록 연결 정리도 보완했다.

## 6. 검증 증거와 재현

- [코드 생성](step04-evidence/codegen.txt), [스키마 스냅샷 생성](step04-evidence/schema.txt)
- [정적 분석](step04-evidence/analyze.txt), [단위·위젯 테스트](step04-evidence/tests.txt)
- [Android 통합 테스트](step04-evidence/android-integration.txt), [iOS 통합 테스트](step04-evidence/ios-integration.txt)
- [Android 빌드](step04-evidence/android-build.txt), [iOS 빌드](step04-evidence/ios-build.txt)
- [Android 재실행 확인](step04-evidence/android-restart.txt), [iOS 초기화 후 홈](step04-evidence/ios-initialized.png)
- [DB v1 스냅샷](../drift_schemas/app_database/drift_schema_v1.json)

```sh
sh scripts/flutterw pub get
sh scripts/flutterw pub run build_runner build
sh scripts/flutterw pub run drift_dev make-migrations
sh scripts/flutterw analyze
sh scripts/flutterw test
sh scripts/flutterw test integration_test/storage_smoke_test.dart -d <device-id>
sh scripts/flutterw build apk --debug
sh scripts/flutterw build ios --simulator --debug
```

실기기 저장 검증·릴리스 빌드·스토어 서명·OS 백업 동작은 이 단계에서 검증하지 않았다. 마이그레이션은 새 스키마를 도입할 때 이전 스냅샷에서의 변환과 데이터 보존 테스트를 추가한다.

## 7. 완료 판정과 다음 단계

Step 04의 기본 데이터 중복 방지, 파일 재연결 후 데이터 유지, Repository CRUD, 설정 저장 분리와 실패 전달 조건을 충족했다. 다음 Step 05에서 실제 계좌 데이터를 홈과 내 계좌에 표시하고 메시지 순환·마음 선택·계좌 편집·안내 확인 UI를 연결한다.
