import 'mood_type.dart';

abstract final class Messages {
  static const common = [
    '오늘은 당장 모든 답을 찾지 않아도 괜찮아요.',
    '돈 걱정 없이 하루를 보낼 수 있다면, 오늘은 무엇을 하고 싶나요?',
    '오늘의 당신에게 휴식 100만 원을 지급합니다.',
  ];
  static const pools = {
    MoodType.tired: [
      '조금 쉬어도 괜찮아요. 당신은 충분히 노력했어요.',
      '오늘은 당장 모든 답을 찾지 않아도 괜찮아요.',
      '오늘의 당신에게 휴식 100만 원을 지급합니다.',
    ],
    MoodType.neutral: [
      '특별한 일이 없는 하루도 괜찮아요.',
      '오늘은 마음이 가는 속도로 걸어가요.',
      '지금은 잠시 숨을 고르는 시간이에요.',
    ],
    MoodType.okay: [
      '오늘의 편안함을 조금 더 누려보세요.',
      '나를 위한 작은 여유를 골라볼까요?',
      '돈 걱정 없이 하루를 보낸다면 무엇을 하고 싶나요?',
    ],
    MoodType.happy: [
      '오늘의 좋은 마음을 충분히 즐겨요.',
      '당신이 꿈꾸는 하루를 상상해 보세요.',
      '이 기분을 미래의 나에게 남겨볼까요?',
    ],
  };
  static List<String> pool(MoodType? mood) => pools[mood] ?? common;
  static int initialIndex(DateTime day, MoodType? mood) =>
      (day.year * 10000 + day.month * 100 + day.day) % pool(mood).length;
  static String label(MoodType mood) => switch (mood) {
    MoodType.tired => '조금 지쳤어요.',
    MoodType.neutral => '그냥 그래요.',
    MoodType.okay => '오늘은 괜찮아요.',
    MoodType.happy => '기분이 좋아요.',
  };
}
