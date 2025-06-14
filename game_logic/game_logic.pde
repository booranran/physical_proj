import processing.serial.*;

Serial myPort;
int money = 100000;  // 시작 자산 10만원
String resultMessage = "";
int resultShowTime = 0;
HashMap<String, String> uidNameMap = new HashMap<String, String>(); //rfid uid 저장

//결혼 관련 변수
boolean isMarried = false; //상태값
boolean UR_Married = false; //중복 방지용
boolean showMarriagePopup = false;

//취직 관련 변수
String[] jobs = {"개발자", "미용사", "스타트업 CEO", "알바"};
String[] fullJobs = {"개발자", "미용사", "스타트업 CEO", "알바"};
String[] limitedJobs = {"알바", "미용사"};

int[] salary = {200000, 150000, 300000, 10000};
String currentJob = "";
int currentSalary = 0;
boolean isHired = false; //상태값
boolean UR_Hired = false; //중복 방지용
boolean showHiredPopup = false;

//진학 관련 변수
boolean isUniv = false;
boolean UR_Univ = false;
boolean UR_Graduate = false;
boolean showUnivPopup = false; //라인 트레이서가 색상 받아와서 특정 색상이면 실행

//투자 관련 변수
boolean isInvest_01 = false;
boolean UR_Invest_01 = false;
int investAmount_01 = 0;

boolean isInvest_02 = false;
boolean UR_Invest_02 = false;
int investAmount_02 = 0;

boolean showInvestPopup = true;

String investInput = "";
boolean isEnteringInvestment = false;

int currentInvestItem = 0;

//주택 관련 변수
boolean isHome_01 = false;
boolean UR_Home_01 = false;
boolean isHome_02 = false;
boolean UR_Home_02 = false;
boolean showHomePopup = true;

ArrayList<Button> homeButtons = new ArrayList<Button>();
boolean isSelectingHome = false;

boolean[] homePurchased = new boolean[4];
String[] homeOptions = {"아파트", "주택", "빌라", "펜트하우스"};
int[] homePrice = {50000, 60000, 45000, 100000};


Button yesButton, noButton;

PFont font;





// ------------------------
void serialEvent(Serial p) {
  String uid = trim(p.readStringUntil('\n')).toUpperCase();
  println("받은 UID: " + uid);

  String tag = uidNameMap.get(uid);

  if (tag == null) {
    println("알 수 없는 태그");
    return;
  }

  if (tag.equals("TAG_MARRY_001")) {
    showMarriagePopup = true;
  } else if (tag.equals("TAG_JOB_001")) { //hash map 통해서 받아온 후 true값 변환
    showHiredPopup = true;
  } else if (tag.equals("TAG_INVEST_001") && !isInvest_01) {
    showInvestPopup = true;
  } else if (tag.equals("TAG_INVEST_002") && !isInvest_02) {
    showInvestPopup = true;
  }
}
