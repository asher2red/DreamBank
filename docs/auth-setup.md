# Google·Apple 로그인 구현 및 연결 안내

작성일: 2026-10-31

## 구현 범위

앱 시작 시 Google·Apple 로그인 또는 게스트 시작을 선택하며 인증 또는 게스트 선택 후 홈으로 이동한다.
로그아웃하면 다시 시작 로그인 화면으로 돌아간다. 내 계좌 → DreamBank 계정에서 현재 계정을 확인한다.
Google의 네이티브 계정 선택 후 ID 토큰을 Firebase Auth에서 검증하고,
Apple은 Firebase Auth의 Apple 공급자 플로를 사용한다. 인증 상태 스트림으로
현재 사용자 이름·이메일(제공된 경우)·Firebase UID를 표시하고 로그아웃한다.
Firebase SDK가 네이티브 인증 세션을 유지하므로 앱 재실행 시 같은 UID를 사용한다.
취소는 오류로 표시하지 않고, 네트워크·계정 충돌 등은 안전한 문구로 표시한다.
토큰이나 이메일, 원본 SDK 오류를 로그에 남기지 않는다.

기존 로컬 DB와 인증 계정은 아직 연결되지 않는다. 로그인/로그아웃해도 계좌·마음 기록·꿈·편지는
바뀌지 않는다. 여러 계정으로 로그인해도 같은 기기의 로컬 기록을 보며, 다른 기기로 동기화되지 않는다.
잔액 랭킹, Firestore, 계정 간 병합, 로그인 수단 연결, 계정 삭제는 이번 작업 범위가 아니다.
Google과 Apple 계정이 자동으로 동일 UID가 된다고 가정해서는 안 된다.
추후 랭킹에는 이메일이나 표시 이름 대신 검증된 Firebase UID를 키로 사용해야 한다.

## 현재 연결 상태

저장소에 실제 Firebase 프로젝트 설정과 OAuth 클라이언트가 없다.
따라서 기본 빌드는 인증을 초기화하지 않고 로그인 화면과 서비스 연결 준비 안내를 표시한다.
게스트는 Firebase 인증 없이 로컬 기능에 접근할 수 있다. 가짜 Firebase UID를 생성하지 않는다.
게스트 상태는 앱 실행 중에만 유지되며, 재시작하면 다시 이용 방식을 선택한다.
기존 로컬 데이터는 지우지 않으며, 게스트 또는 실제 인증 후 기존 기능을 사용할 수 있다.
아래 외부 설정을 완료한 뒤 `FIREBASE_ENABLED=true` 빌드에서 실제 로그인을 사용할 수 있다.
이 플래그만 켜는 것으로 외부 설정이 만들어지지는 않는다.

## 1. Firebase 프로젝트

Firebase Console에서 사용할 프로젝트를 선택하고 Authentication을 시작한다.
Google 및 Apple 공급자를 활성화한다. 별도 자체 서버는 필요하지 않다.
현재 Android applicationId와 iOS bundle identifier는 모두 `dev.dreambank.dreambank`다.
배포용 ID를 변경한다면 양쪽 네이티브 프로젝트와 Firebase 등록도 함께 변경해야 한다.

## 2. Android Google 로그인

1. Firebase에 위 패키지 이름으로 Android 앱을 등록한다.
2. debug 및 실제 배포 서명 인증서의 SHA-1/SHA-256을 등록한다.
   Play 배포 시 Play App Signing 인증서도 등록한다.
3. Google 공급자를 켠 후 새 `google-services.json`을 다운로드하여
   `android/app/google-services.json`에 둔다.
4. JSON에 Web OAuth 클라이언트(`client_type: 3`)가 있어야 한다.
   Google SDK는 Gradle이 생성한 `default_web_client_id`를 사용한다.

Google Services Gradle 플러그인은 JSON 파일이 있을 때만 적용한다.
인터넷 권한은 release manifest에도 선언되어 있다.

## 3. iOS Firebase와 Google 로그인

1. Firebase에 위 Bundle ID로 iOS 앱을 등록한다.
2. `GoogleService-Info.plist`를 `ios/Runner/`에 저장하고 Xcode Runner 프로젝트에 추가한다.
   Runner target membership과 Build Phases → Copy Bundle Resources 포함 여부를 확인한다.
   파일을 폴더에 복사하기만 해서는 앱 리소스에 포함되지 않는다.
3. `ios/Runner/Info.plist`에 아래 값을 실제 프로젝트의 값으로 추가한다.
   `GIDClientID`는 다운로드한 plist의 `CLIENT_ID`, URL scheme은 `REVERSED_CLIENT_ID`다.

```xml
<key>GIDClientID</key>
<string>실제 CLIENT_ID 값</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key><string>Editor</string>
    <key>CFBundleURLSchemes</key>
    <array><string>실제 REVERSED_CLIENT_ID 값</string></array>
  </dict>
</array>
```

기존 URL scheme이 있다면 배열에 추가한다. 예시 한글 문자열을 그대로 사용하지 않는다.

## 4. Apple 로그인

Apple Developer 계정의 App ID에 Sign in with Apple을 활성화하고 Xcode에서
올바른 개발 팀과 서명 프로파일을 지정한다. Runner.entitlements와 모든 Runner 빌드 구성에
Sign in with Apple entitlement를 추가해 두었다.

Android의 Apple 로그인은 웹 OAuth 흐름이다. Apple Developer에서 Services ID,
Team ID, Key ID 및 Sign in with Apple용 private key를 준비하고 Firebase의 Apple 공급자에 설정한다.
Firebase Console에 표시된 OAuth redirect URL을 Apple Services ID의 Return URL로 등록한다.
Apple 비공개 키(.p8)는 앱이나 저장소에 넣지 않고 Firebase Console에만 등록한다.
비공개 이메일 사용 시 Apple Private Email Relay 관련 Firebase 도메인 설정도 확인한다.

## 5. 설정 완료 후 실행

```sh
sh scripts/flutterw run --dart-define=FIREBASE_ENABLED=true
sh scripts/flutterw build apk --debug --dart-define=FIREBASE_ENABLED=true
sh scripts/flutterw build ios --simulator --debug --dart-define=FIREBASE_ENABLED=true
```

## 실제 계정 검증 항목

- Android와 iOS에서 Google 로그인 → UID 확인 → 앱 종료/재실행 → 동일 UID 확인.
- iOS와 Android에서 Apple 로그인(실제 이메일/비공개 이메일) 확인.
- 계정 선택 취소, 네트워크 오류, 로그아웃 후 재로그인 확인.
- 로그인 전후 로컬 잔고/별칭/기록이 바뀌지 않는지 확인.
- 다른 로그인 수단 사용 시 별개 계정 또는 Firebase 계정 충돌 안내 동작 확인.

외부 자격 정보가 없어 현재 실제 OAuth 성공·네이티브 세션 복원은 검증하지 못했다.
테스트 더블을 사용한 화면 검증은 실제 공급자 검증을 대체하지 않는다.
스토어 배포 전에는 계정 삭제 경로와 개인정보 처리방침도 별도 구현·정리해야 한다.

## 공식 참고 문서

- [Firebase Flutter 소셜 로그인](https://firebase.google.com/docs/auth/flutter/federated-auth)
- [Firebase Flutter 초기 설정](https://firebase.google.com/docs/flutter/setup)
- [Google Sign-In Android 설정](https://pub.dev/packages/google_sign_in_android)
- [Google Sign-In iOS 설정](https://pub.dev/packages/google_sign_in_ios)
