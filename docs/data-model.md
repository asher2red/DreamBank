# DreamBank 로컬 데이터 모델

작성일: 2026-10-29 (Asia/Seoul) · Step 02 설계

[화면 및 동작 규칙](mvp-design.md)과 함께 적용한다. 아래 스키마는 Step 04에서 구현했다. 실제 구현·초기화·재연결·호환성 검증 결과는 [4단계 결과](step04-report.md)를 따른다. 스키마는 현재 v1이며 버전 간 변환 마이그레이션은 아직 없다.

## 1. 공통 저장 원칙

- 앱 전용 Application Support 경로의 `dreambank.sqlite`를 Drift로 관리한다. 외부 공유 저장소에 DB를 두지 않는다.
- SQL 이름은 snake_case, Dart 모델은 camelCase를 사용한다. SQL 정수는 Dart `int`, SQL TEXT는 `String`으로 매핑한다.
- `created_at`, `updated_at`은 UTC Unix epoch milliseconds 정수다. 표시는 기기 현지 시각으로 변환한다. Repository에 주입한 시계로 생성한다.
- 날짜 전용 공개일은 UTC 시각으로 변환하지 않고 `YYYY-MM-DD` 문자열로 보관한다. 날짜 판정 시 구성 요소를 현지 달력 날짜끼리 비교한다.
- DB ID는 INTEGER PRIMARY KEY AUTOINCREMENT를 사용한다. 단일 계좌만 고정 ID 1을 사용한다. 제목을 식별자로 사용하지 않는다.
- 사용자 필드는 UI와 Repository에서 검증한다. DB에서도 null, 숫자 범위, enum, 빈 문자열 등을 방어한다. 사용자 인식 문자 길이 상한은 Dart에서 검증한다. SQLite `length`를 grapheme 길이로 간주하지 않는다.
- 원 단위 금액은 부동소수점 없이 0~999999999999의 정수다. KRW만 지원한다.
- 레코드 삭제는 하드 삭제다. 관계·거래 원장·서버 동기화 필드는 도입하지 않는다.

## 2. AccountSettings → account_settings

| Dart / SQL 필드 | SQL 타입 | null | 기본값 및 제약 |
|---|---|---|---|
| id / id | INTEGER PK | 불가 | 고정 1, CHECK id = 1 |
| accountNickname / account_nickname | TEXT | 불가 | 초기 `나의 여유 계좌`, trim 후 1~30자 |
| virtualBalance / virtual_balance | INTEGER | 불가 | DEFAULT 1000000000, CHECK 0~999999999999 |
| currencyCode / currency_code | TEXT | 불가 | DEFAULT `KRW`, CHECK currency_code = 'KRW' |
| createdAt / created_at | INTEGER | 불가 | 초기 생성 시 주입 시각 |
| updatedAt / updated_at | INTEGER | 불가 | 생성 시 createdAt과 동일, 이후 성공한 변경 시 갱신 |

별칭은 DB에서 trim 후 비어 있지 않음을 확인한다. 시각에는 음수가 아닌 값 제약을 적용한다. PK 외 추가 인덱스는 필요 없다. 삭제 API는 제공하지 않는다. 별칭·잔고 편집은 한 UPDATE로 저장한다.

## 3. MoodEntry → mood_entries

| Dart / SQL 필드 | SQL 타입 | null | 기본값 및 제약 |
|---|---|---|---|
| id / id | INTEGER PK AUTOINCREMENT | 불가 | DB 생성 |
| moodType / mood_type | TEXT | 불가 | tired / neutral / okay / happy 중 하나 |
| createdAt / created_at | INTEGER | 불가 | 선택 저장 시 UTC milliseconds, 음수 불가 |

사용자가 다른 마음을 선택할 때 append한다. 같은 선택의 반복 탭은 UI/Controller에서 차단한다. 일자별 unique 제약은 없으며 날짜 변경 후 같은 마음 선택은 새 기록이다. 최신 기록은 `created_at DESC, id DESC LIMIT 1`로 읽는다. 해당 순서의 복합 인덱스를 생성한다. 오늘의 선택은 최신 기록의 시각을 현재 기기 시간대로 변환해 날짜를 비교한다. 시간대 변경 시 오늘의 판정이 달라질 수 있다. 기록 조회·추가만 MVP API로 제공하며 이력 화면은 추가하지 않는다.

## 4. DreamItem → dream_items

| Dart / SQL 필드 | SQL 타입 | null | 기본값 및 제약 |
|---|---|---|---|
| id / id | INTEGER PK AUTOINCREMENT | 불가 | DB 생성 |
| title / title | TEXT | 불가 | trim 후 1~80자, DB에서 빈 문자열 거부 |
| description / description | TEXT | 불가 | DEFAULT '', trim 후 0~2000자 |
| estimatedCost / estimated_cost | INTEGER | 허용 | DEFAULT NULL, 값이 있으면 0~999999999999 |
| createdAt / created_at | INTEGER | 불가 | 생성 시 주입 시각, 음수 불가 |
| updatedAt / updated_at | INTEGER | 불가 | 생성 시 createdAt, 이후 수정 시 갱신, 음수 불가 |

목록 순서는 `updated_at DESC, id DESC`이며 대응 복합 인덱스를 생성한다. 비용 단위는 계좌와 동일한 KRW 고정이며 계좌 잔고와 연결하지 않는다. 별도 FK는 없다.

## 5. FutureLetter → future_letters

| Dart / SQL 필드 | SQL 타입 | null | 기본값 및 제약 |
|---|---|---|---|
| id / id | INTEGER PK AUTOINCREMENT | 불가 | DB 생성 |
| title / title | TEXT | 불가 | trim 후 1~80자, DB에서 빈 문자열 거부 |
| content / content | TEXT | 불가 | trim 후 1~10000자, DB에서 빈 문자열 거부 |
| createdAt / created_at | INTEGER | 불가 | 생성 시 주입 시각, 음수 불가 |
| unlockAt / unlock_at | TEXT | 허용 | DEFAULT NULL, 유효한 YYYY-MM-DD 달력 날짜 |
| updatedAt / updated_at | INTEGER | 불가 | 생성 시 createdAt, 이후 수정 시 갱신, 음수 불가 |

`unlockAt` 이름은 기준 스펙을 유지하지만 의미는 시각이 아닌 공개 날짜다. Dart에서는 `DateOnly` 성격의 값 객체 또는 검증된 문자열을 사용한다. 일반 `DateTime.parse`의 날짜 보정에 의존하지 말고 연·월·일 왕복 비교로 존재하는 날짜인지 검증한다. DB에서는 NULL 또는 10자리 날짜 형태를 검사하고 실제 달력 유효성은 Repository가 보장한다.

목록 순서는 `updated_at DESC, id DESC`이며 대응 복합 인덱스를 생성한다. 공개 상태로 필터링하지 않으므로 공개일 인덱스는 추가하지 않는다. `isUnlocked`는 현재 현지 날짜로 계산하고 저장하지 않는다. 잠긴 상세에서도 편집 가능하므로 Repository는 원문을 제공할 수 있으나 Presentation의 열람 화면은 원문을 표시하지 않는다.

## 6. AppSettings → shared_preferences

| 모델 필드 | 저장 키 | 타입 | 기본값과 처리 |
|---|---|---|---|
| themeMode | `settings.theme_mode` | String | `dark`; MVP에서는 dark만 사용, 잘못된 값은 dark로 해석 |
| onboardingCompleted | `settings.onboarding_completed` | bool | false; 안내 확인 후 true, 기능 제한 없음 |

홈에는 첫 실행 시 닫을 수 있는 짧은 가상 서비스·로컬 저장 안내를 제공한다. 확인 상태 저장 실패 시 안내가 다음 실행에 다시 나타날 수 있음을 알리고 핵심 기능은 유지한다. 앱 정보에서 동일 안내를 언제든 볼 수 있다. 잔고·꿈·편지·마음은 preferences에 복제하지 않는다. 설정 읽기 실패는 기본 테마와 안내 표시로 복구하며 DB 오류와 분리한다.

## 7. 초기화와 스키마 변경

초기 스키마 버전은 1이다. 스냅샷은 `drift_schemas/app_database/drift_schema_v1.json`에 보관한다. 목록 복합 인덱스는 두 필드 모두 같은 방향으로 생성하며 DESC 조회에는 역방향 탐색을 사용한다. 네 개 테이블, 세 개 목록 인덱스, 제약을 생성한다. DB를 연 뒤 트랜잭션 안에서 ID 1 기본 계좌를 `INSERT ... ON CONFLICT(id) DO NOTHING`과 동등한 방식으로 보장한다. 기존 별칭·잔고·시각을 덮어쓰는 replace는 사용하지 않는다. 꿈·편지·마음은 빈 목록으로 시작한다.

설정과 DB는 별개 저장소이므로 하나의 원자적 트랜잭션으로 간주하지 않는다. 온보딩 플래그를 계좌 생성 여부의 기준으로 사용하지 않는다. 계좌 초기화 재시도는 멱등적이어야 한다.

향후 변경 시:

1. 스키마 버전을 증가시키고 이전 스키마 스냅샷을 유지한다.
2. nullable 또는 기본값이 있는 컬럼 추가를 우선한다. 변환이 필요하면 트랜잭션 안에서 기존 데이터와 ID를 보존한다.
3. 각 지원 이전 버전에서 새 버전으로의 마이그레이션과 실제 값 보존을 테스트한다.
4. 실패 시 오류를 반환하고 재시도 경로를 제공한다. 자동 DB 삭제·재생성으로 복구하지 않는다.
5. 지원보다 높은 DB 버전은 명시적인 호환 오류로 처리하고 데이터를 초기화하지 않는다.

## 8. Repository와 상태 관리 계약

| 책임 | 제공 동작 | 갱신 방식 |
|---|---|---|
| AccountRepository | 초기 계좌 보장, 계좌 관찰, 별칭·잔고 변경 | DB commit 후 관찰 스트림 반영 |
| MoodRepository | 최신 기록 관찰, 마음 추가 | 저장 성공 후 홈 상태 갱신 |
| DreamRepository | 목록·단건 관찰, 생성·수정·삭제 | 생성 ID 반환, 기존 항목 변경은 대상 존재 확인 |
| LetterRepository | 목록·단건 관찰, 생성·수정·삭제 | 공개 판정은 별도 순수 함수 |
| SettingsRepository | 설정 읽기, 안내 확인 저장 | 실패가 핵심 DB 기능을 차단하지 않음 |

Controller는 검증·저장 상태·오류 변환을 관리한다. 비동기 조회는 Riverpod의 로딩/데이터/오류 상태로 노출하고 화면에서 DB를 직접 호출하지 않는다. 저장은 commit 이후 성공으로 처리한다. 없는 ID의 수정·삭제는 성공으로 간주하지 않고 notFound로 반환한다. 입력 오류, notFound, 읽기 실패, 쓰기 실패, 호환성 오류를 구분한다.

MVP는 단일 앱 프로세스의 직렬 저장 흐름을 사용한다. 중복 제출을 막고 여러 곳에서 계좌 전체를 오래된 값으로 덮어쓰지 않도록 수정 필드만 갱신한다. 타임스탬프는 기기 시계 변경으로 과거 값이 될 수 있으며 `updatedAt >= createdAt` DB 제약은 두지 않는다.

## 9. 데이터 수명과 검증

클라우드 백업·동기화를 앱 기능으로 제공하지 않는다. OS 백업 정책은 플랫폼 설정 시 별도 확인하고 그 결과를 기록한다. 앱 제거·기기 변경으로 데이터가 사라질 수 있음을 안내한다. DB 암호화와 생체 인증은 이번 범위에서 구현하지 않는다. 공유 PNG만 사용자의 명시적 공유 동작으로 OS에 전달한다.

검증은 [인수 조건](acceptance-criteria.md)의 STORE, DREAM, LETTER 항목을 따른다. 인메모리 CRUD 테스트 외에 임시 파일 DB를 닫았다 다시 열어 초기 계좌 중복 방지·데이터 유지·삭제 유지를 검증한다. 실제 스키마 변경이 생기기 전에는 마이그레이션 검증 완료로 보고하지 않는다.
