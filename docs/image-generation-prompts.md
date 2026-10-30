# DreamBank 이미지 리소스 생성 프롬프트

작성일: 2026-10-30 (Asia/Seoul)

## 1. 아트 디렉션

**느낌: 내 돈을 조용히 맡겨둔 프라이빗 은행. 화면을 보는 순간 생기는 안정감과 여유.**

금융 앱의 신뢰감은 정돈된 정보·명확한 잔고·일관된 타이포그래피에서 만들고, 이미지는 빛·소재·공간감으로 감성을 더한다. 로고와 계좌 카드가 브랜드의 중심이며, 장면 이미지는 작은 면적에 절제해서 사용한다.

기존의 네이비·샴페인 골드와 네 방향 별 모티프를 발전시킨다. 은행 건물이나 동전보다 작은 별을 브랜드 기호로 사용한다. 차가운 검정 대신 따뜻한 빛이 조금 섞인 네이비, 번쩍이는 금 대신 무광 샴페인 골드를 선택한다.

| 요소 | 기준 |
|---|---|
| 기본색 | Midnight navy `#0B111B`, deep navy `#142238` |
| 카드색 | Slate navy `#162131`, elevated navy `#202E41` |
| 강조색 | Muted champagne gold `#D4B77A` |
| 밝은색 | Warm ivory `#F5F1E8` |
| 브랜드 모티프 | 간결한 네 방향 별, 부드러운 수평선, 얇은 곡선 |
| 소재 | 브러시드 메탈, 무광 종이, 석재, 은은한 새틴 |
| 조명 | 낮은 대비의 간접광, 따뜻한 새벽빛, 부드러운 그림자 |
| 구도 | 넓은 여백, 하나의 주제, 자연스러운 깊이 |
| 피할 분위기 | 과시적인 부, 금괴·현금 더미, 카지노, 코인 거래소, 네온 SF, 장난감 같은 3D |

실제 은행 앱처럼 정돈된 경험을 목표로 하되, `가상 잔고` 표시는 앱과 공유 카드에서 명확하게 유지한다. 금액·계좌 별칭·안내 문구는 이미지에 구워 넣지 않고 앱에서 렌더링한다.

## 2. 필요한 리소스와 적용 위치

크기는 최종 제작·내보내기 목표이며 이미지 생성 도구가 정확한 크기를 지원하지 않으면 같은 비율로 생성 후 조정한다. 아래 경로는 적용 시 사용할 제안 경로이며 아직 생성된 파일은 아니다.

| 번호 | 리소스 | 용도 | 목표 비율·원본 | 배경 | 제안 파일 |
|---|---|---|---|---|---|
| 01 | 앱 아이콘 | Android·iOS 런처 | 1:1 · 1024×1024 | 불투명 네이비 | `assets/brand/app_icon_master.png` |
| 02 | 브랜드 심벌 | 헤더·계좌 카드·공유 카드 | 1:1 · 1024×1024 | 투명 | `assets/brand/dreambank_symbol.png` |
| 03 | 계좌 카드 배경 | 홈·내 계좌·공유 카드 | 8:5 · 1600×1000 | 불투명 | `assets/images/account_card_background.webp` |
| 04 | 홈의 여유 이미지 | 인사말 아래 또는 오늘의 여유 카드 상단 | 3:2 · 1536×1024 | 불투명 | `assets/images/home_serenity.webp` |
| 05 | 꿈 보관함 이미지 | 꿈 탭의 소개 영역·빈 상태 | 3:2 · 1536×1024 | 불투명 | `assets/images/dream_vault.webp` |
| 06 | 미래의 편지 이미지 | 편지 탭의 소개 영역·빈 상태 | 3:2 · 1536×1024 | 불투명 | `assets/images/future_letter.webp` |
| 07 | 안내용 작은 심벌 세트 | 안내·빈 상태·저장 완료 보조 | 각각 1:1 · 1024×1024 | 투명 | `assets/illustrations/…png` |

우선 01~03을 제작해 브랜드와 금융 앱의 인상을 확정한다. 04~06은 각각의 페이지에서 필요한 곳에 한 장씩 사용한다. 07은 기본 아이콘만으로 부족할 때 선택적으로 제작한다. 하단 탭 아이콘은 기존 벡터 아이콘 체계를 유지한다.

## 3. 공통 프롬프트

다음 공통 프롬프트 뒤에 각 이미지의 개별 프롬프트와 제외 조건을 붙인다. 이미지마다 새로운 스타일을 요청하기보다 승인한 아이콘·심벌·카드 결과물을 다음 생성의 참조 이미지로 제공한다.

```text
Art direction for DreamBank, a calm and refined virtual private banking app.
Create one finished visual asset, not an app screen, not a presentation board.
The brand should feel reassuring, discreet, warm, beautifully crafted, and financially established.

Use a tightly controlled palette of midnight navy (#0B111B), deep navy (#142238), slate navy (#162131), muted champagne gold (#D4B77A), and warm ivory (#F5F1E8).
Use soft indirect illumination, restrained material detail, precise composition, and generous negative space.
The mood is quiet financial breathing room: private banking meets a peaceful architectural retreat.
Elegance should come from proportion, craftsmanship, and light.
Keep the composition simple and readable on a small mobile display.
Avoid both cold corporate sterility and sentimental fantasy illustration.

Do not render interface controls, account numbers, balances, labels, captions, watermarks, or any text.
```

## 4. 개별 이미지 생성 프롬프트

### 01. 앱 아이콘 — 조용한 여유의 별

작은 크기에서도 알아볼 수 있는 하나의 심벌을 만든다. 최종 iOS 아이콘은 불투명 정사각형으로 내보내고, 플랫폼의 모서리 마스크를 이미지에 미리 그리지 않는다.

```text
Create the master app icon for DreamBank.
Square 1:1 composition, edge-to-edge opaque midnight navy background.

At the exact center, place a distinctive four-point compass-like star representing a quiet moment of possibility.
The star has four long, balanced tips and gently softened inward curves, with a strong, simple silhouette.
Use muted champagne gold with an extremely subtle brushed-metal finish.
The symbol should feel precisely made, with nearly flat geometry and only the slightest suggestion of a soft bevel.
It should remain immediately recognizable at 32 pixels.

The star occupies approximately 48 percent of the canvas width and height.
Keep it entirely within the central safe area so it survives circular and rounded-square platform masks.
Use a near-solid navy background with a very subtle warm tonal lift behind the mark.
The composition should feel as confident and restrained as a well-made private banking emblem.

Render the icon artwork itself, with no surrounding device, no external drop shadow, no rounded-square border, no app name, no letters, no extra stars, no badge, and no decorative frame.
Opaque background, no transparency.
```

**선택 기준:** 32px에서 별이 뭉개지지 않는가, 금융 앱의 차분함이 있는가, 반짝이는 게임 아이콘처럼 보이지 않는가.

### 02. 로고 심벌 — 화면과 카드에 쓰는 평면형

01과 동일한 별의 형태를 사용한다. 앱 아이콘의 입체감은 빼고 헤더·카드에서도 명확한 평면형으로 만든다. `DreamBank` 워드마크는 앱 텍스트 또는 별도 벡터로 조합한다.

```text
Create a clean, flat brand symbol for DreamBank using the exact same four-point star silhouette as the approved app icon reference.
One centered symbol only, in solid muted champagne gold (#D4B77A).
The geometry must be balanced, with smooth inward curves, crisp edges, and a simple recognizable silhouette.

The star occupies about 70 percent of a square canvas, with equal transparent padding on every side.
Make it suitable for a mobile banking header, a dark account card, and a small sharing watermark.
Render flat graphic artwork with the visual precision of a vector symbol.

Transparent background, including transparent negative space around the shape.
No navy square, no paper texture, no white matte, no shadows, no gradients, no metallic reflection, no bevel, no lettering, no mockup.
```

**제작 후 처리:** 생성 결과를 형태 참고로 삼아 SVG 또는 Flutter Path로 정리한다. 실제 앱의 작은 로고에는 정리한 벡터를 우선 사용한다. 밝은 배경용이 필요하면 같은 실루엣을 네이비 단색으로 변환한다.

### 03. 가상 계좌 카드 — 네이비 새틴과 샴페인 곡선

전체 앱 인상을 결정하는 핵심 배경이다. 카드 모서리·잔고·별칭·브랜드·가상 표시를 포함한 모든 정보는 Flutter 위젯이 담당한다.

```text
Create a premium account-card background texture for DreamBank, landscape 8:5.
This is background artwork only; the app will place all text and symbols on top.
Fill the entire canvas with deep midnight navy, with a subtle satin finish and barely perceptible fine grain.

Keep the left 72 percent of the canvas calm, dark, low-detail, and evenly lit.
Keep the bottom 22 percent especially clean and dark for a virtual-balance disclosure.
Do not place any bright feature through the central balance area.

In the upper-right quadrant only, introduce one broad, shallow, sculptural curve, like a softly folded sheet of dark brushed metal.
Add a very thin, muted champagne-gold light along a short portion of its outer edge.
The curve should feel architectural and expensive, with soft depth, no sharp glare, and no busy pattern.
Let the right-side detail fade naturally into the navy field.
Maintain gentle tonal variation so ivory text remains clearly readable everywhere it will be placed.

The result should resemble a quietly luxurious private banking material, not a physical credit card photograph.
No card outline, no rounded corners baked in, no chip, no magnetic strip, no payment-network logos, no numbers, no text, no brand mark, no watermark.
```

**적용 조건:** 텍스트는 좌측, 장식은 우측 상단에 배치한다. 카드가 세로로 늘어나면 배경을 늘려 왜곡하기보다 정렬·크롭하거나 일부를 단색으로 확장한다. 공유 카드에서도 하단 가상 표시를 배경보다 위에 선명하게 렌더링한다.

### 04. 홈 이미지 — 조용한 새벽의 프라이빗 라운지

잔고보다 시선을 더 끌지 않는 짧은 가로 이미지로 사용한다. 첫 화면에서는 계좌 카드보다 아래에 두는 것을 기본으로 한다.

```text
Create a photorealistic editorial architectural image for DreamBank, landscape 3:2.
A serene private lounge at early dawn, overlooking a still lake through a large clean architectural opening.
Only a small portion of the lounge is visible: a warm ivory limestone ledge, one softly upholstered ivory chair near the far right, and a discreet champagne-metal detail.
No furniture clutter.

The exterior is a calm navy-blue horizon with soft mist and a very faint warm dawn reflection on the water.
Use gentle natural light, tactile limestone, soft fabric, and balanced photographic exposure.
The room should feel welcoming and lived-in enough to rest, yet exceptionally quiet and refined.
No dramatic mansion, no extravagant chandelier, no visible city wealth.

Keep the left half visually simple and the main chair on the right third.
Use a stable horizontal composition that can be cropped into a wide mobile banner without losing the subject.
Keep essential details within the central horizontal band; avoid strong details near the top and bottom edges.
Finish with subtle film grain, natural material fidelity, and restrained contrast.
No people, no bank counters, no text, no logos, no screens, no sunset orange saturation.
```

**적용 조건:** 주변에 이미 제목과 안내가 있으므로 이미지 위에 문장을 겹치지 않는 것이 기본이다. 배너를 낮게 크롭해 계좌와 메시지의 우선순위를 유지한다.

### 05. 꿈 보관함 — 멀리 열린 수평선

사용자가 구체적인 꿈을 자유롭게 투영할 수 있는 장면이다. 특정 소비재나 호화 여행 상품처럼 보이지 않게 한다.

```text
Create a photorealistic editorial architectural image for DreamBank's dream vault, landscape 3:2.
A single tall, softly curved architectural opening in warm ivory plaster, leading to a quiet terrace and an expansive blue horizon.
Beyond the opening is a still sea with a delicate morning haze and a small amount of soft warm light near the horizon.

The foreground is sheltered, calm, and minimal, using subtle stone texture and clean shadow transitions.
The opening suggests room for a different life: more time, more freedom, more rest.
It should feel attainable as an emotional space, without displaying possessions or status.
Use the same navy, ivory, and muted champagne palette as a quiet private banking brand.

Keep the opening near the right third and leave the left half low-detail.
Use enough depth to invite the eye outward, but avoid impossible geometry or surreal dream effects.
Make the central subject survive a wide banner crop.
No people, no luggage, no airplane, no luxury car, no yacht, no stacks of money, no text, no logo, no magical glowing portal.
```

**적용 조건:** 목록 상단 또는 첫 꿈 작성 전 빈 상태에 사용한다. 꿈이 쌓이면 이미지를 크게 반복하지 않고 사용자의 기록을 화면 중심에 둔다.

### 06. 미래의 편지 — 나를 위해 남겨둔 안부

04·05와 동일한 색감과 조명으로, 공간 장면을 가까이 들여다본 정물 사진을 만든다.

```text
Create a photorealistic editorial still-life image for DreamBank's future letters page, landscape 3:2.
A single closed envelope made of warm ivory cotton paper rests on a dark navy desk surface.
The envelope is positioned on the right half of the frame at a slight, natural angle.
Its folds are precise and the paper has subtle tactile fibers.

A small, plain, muted champagne-gold circular seal closes the envelope.
The seal has no letters or detailed crest.
A narrow soft shaft of morning light touches one edge of the paper, leaving the surrounding scene calm and gently shadowed.
Use the same discreet material language as a private banking stationery collection.
The mood is personal reassurance, patience, and a thoughtful note kept for later.

Keep the left half mostly dark and visually quiet.
Compose the envelope within the central horizontal band so the image also works as a wide mobile banner.
Natural scale, believable paper folds, refined photographic detail, soft contrast.
No handwriting, no printed address, no stamp, no readable text, no extra envelopes, no pen, no flowers, no clock, no ornate wax crest, no logo.
```

**적용 조건:** 잠긴 편지의 실제 내용과 무관한 공통 장식으로 사용한다. 공개 날짜·공개 상태는 Flutter 텍스트와 아이콘으로 표시한다.

### 07. 선택 리소스 — 작은 안내용 오브젝트

한 장의 스프라이트 시트로 만들지 않고 아래 주제 중 하나를 골라 별도 생성한다. 세 개를 모두 쓸 필요는 없다.

```text
Create one small editorial object illustration for DreamBank on a transparent background.
Subject: [INSERT ONE SUBJECT BELOW].
Use restrained, nearly flat dimensional forms with a matte finish, soft edges, and subtle material shading.
Palette: deep navy, warm ivory, and a very small amount of muted champagne gold.
The object should be elegant, calm, and readable at a small size, with no tiny decorative details.
One centered object, generous transparent margins on all sides.
Avoid a cute toy aesthetic, cartoon faces, glossy plastic, exaggerated 3D extrusion, and dramatic shadows.
No ground plane, no opaque background, no text, no labels, no letters, no logos.
```

주제별 삽입 문구:

- 꿈 빈 상태: `one simple open ivory keepsake box with a single small champagne four-point star resting just above its opening; the star is a solid object, not a glow effect`
- 편지 빈 상태: `one neatly folded ivory envelope with a small plain champagne circular seal, shown in a restrained three-quarter view`
- 저장 완료 보조: `one simple champagne four-point star resting inside a shallow ivory circular dish`

**적용 조건:** 실제 저장 완료 여부는 앱 상태로 판단하고 텍스트 피드백을 함께 제공한다. 이 오브젝트를 일반 탭 아이콘 대신 사용하지 않는다.

## 5. 공통 제외 조건

생성 도구가 별도의 negative prompt를 지원하면 아래를 사용한다. 지원하지 않으면 개별 프롬프트 끝에 붙인다.

```text
No existing bank branding, no copied corporate logo, no credit-card network marks,
no account numbers, no readable text, no fake interface, no dashboard,
no money piles, no gold bars, no casino aesthetics, no cryptocurrency symbols,
no excessive gold, no neon, no cyberpunk, no lens flare, no sparkles,
no cartoon people, no toy-like plastic, no excessive 3D, no busy patterns,
no harsh glossy reflections, no crushed blacks, no watermark, no presentation mockup.
```

## 6. 생성·선별·적용 순서

1. **아이콘 후보 생성:** 01을 사용해 작은 크기에서도 좋은 실루엣을 선택한다. 최종 선택 후 별의 비율과 곡선을 고정한다.
2. **로고 통일:** 선택한 아이콘을 참조해 02를 제작하고, 심벌은 벡터로 정리한다. DreamBank 워드마크는 별도 텍스트로 조합한다.
3. **카드 배경 검증:** 03을 생성한 뒤 실제 별칭·10억 원·최대 잔고·가상 안내를 앱에서 올려본다. 장식이 숫자와 경쟁하면 배경을 더 어둡고 단순하게 수정한다.
4. **페이지 이미지 제작:** 승인된 스타일의 색감·광원·재질을 참조해 04~06을 생성한다. 이미지마다 조명과 톤이 다르게 튀지 않도록 나란히 비교한다.
5. **실제 화면에서 선택:** 320px 폭과 큰 글자 환경에서 이미지 때문에 잔고나 주요 버튼이 밀리거나 읽기 어려워지지 않는지 확인한다.
6. **내보내기:** 심벌은 SVG/코드, 아이콘은 플랫폼별 PNG, 장면은 WebP를 우선한다. 원본을 보관하고 앱 배포용은 화면에 필요한 해상도로 줄인다. 장면은 장당 약 100~250KB를 초기 목표로 삼고 품질을 비교한다.
7. **앱 적용:** 로컬 assets에 포함해 오프라인에서도 표시한다. 카드 배경은 ClipRRect와 필요시 네이비 오버레이를 적용한다. 이미지와 중요한 텍스트를 분리하고 장식 이미지는 접근성 읽기에서 제외한다.

### 최종 선택 체크

- 잔고 숫자가 화면의 가장 중요한 정보로 남는가?
- 편안한 은행 앱으로 보이며 과시적인 자산 자랑처럼 느껴지지 않는가?
- 별 모양과 네이비·골드의 색감이 모든 리소스에서 일치하는가?
- 금액·별칭·공개 날짜가 이미지가 아닌 실제 앱 텍스트인가?
- 실제 기본 잔고와 최대 잔고, 긴 별칭을 배경 위에 명확히 표시할 수 있는가?
- 가상 잔고 표시가 카드와 공유 이미지에서 읽히는가?
- 이미지 없이도 핵심 기능을 이해하고 이용할 수 있는가?

이 문서는 생성용 프롬프트와 적용 지침이다. 이번 작업에서는 이미지를 생성하거나 기존 앱 디자인을 변경하지 않았다.
