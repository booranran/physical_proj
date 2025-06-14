import java.util.Collections;



void setup() {
  size(600, 400);
  //println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');

  yesButton = new Button(150, 250, 100, 40, "YES");
  noButton = new Button(350, 250, 100, 40, "NO");

  font = loadFont("GmarketSansMedium.vlw");
  textFont(font);

  //uidNameMap.put("a23esf", "TAG_MARRY_001");
  //uidNameMap.put("a23esf", "TAG_JOB_001");
}

void draw() {
  background(255);
  textAlign(CENTER);
  fill(0);
  textSize(20);
  text("현재 자산: " + money + "원", width/2, 100);

  if (showMarriagePopup) {
    fill(230);
    rect(100, 150, 400, 150, 10);
    fill(0);
    text("결혼하시겠습니까?", width/2, 190);
    yesButton.display();
    noButton.display();
  }

  if (showHiredPopup) {
    fill(230);
    rect(100, 150, 400, 150, 10);
    fill(0);
    if (isUniv && UR_Graduate) {
      text("졸업을 축하합니다! 직업을 선택하세요.", width/2, 190);
      if (jobButtons.isEmpty()) {
        setupJobButtons(fullJobs);  // 처음 한번만 버튼 생성
      }
      drawJobButtons();  // 버튼 출력
    } else if (isUniv && !UR_Graduate) {
      text("아직 졸업 전입니다. 졸업 후 직업을 선택할 수 있습니다.", width/2, 190);
      // 버튼 없음
    } else if (!isUniv) {
      text("직업을 선택하세요. (제한적 직업)", width/2, 190);
      // 제한 직업 버튼 출력
      if (jobButtons.isEmpty()) {
        setupJobButtons(limitedJobs);  // 처음 한번만 버튼 생성
      }
      drawJobButtons();  // 버튼 출력
    }
  }

  if (showUnivPopup) {
    if (!isUniv) {
      fill(230);
      rect(100, 150, 400, 150, 10);
      fill(0);
      text("진학하시겠습니까?", width/2, 190);
      yesButton.display();
      noButton.display();
    }
  }

  if (showInvestPopup) {
    fill(230);
    rect(100, 150, 400, 150, 10);
    fill(0);
    text("투자 하시겠습니까?", width/2, 190);
    yesButton.display();
    noButton.display();
  }

  if (isEnteringInvestment) {
    fill(230);
    rect(100, 150, 400, 150, 10);
    fill(0);
    textSize(20);
    text("투자금 입력: " + investInput, width/2, 150);
  }

  if (showHomePopup) {
    fill(230);
    rect(100, 150, 400, 150, 10);
    fill(0);
    text("부동산을 구매 하시겠습니까?", width/2, 190);
    yesButton.display();
    noButton.display();
  }

  if (isSelectingHome) {
    for (Button btn : homeButtons) {
      btn.display();
    }
  }

  //결과 메시지 잠깐 출력
  if (resultMessage != "" && millis() - resultShowTime < 2000) {  // 2초 동안 표시
    text(resultMessage, width/2, 250);
  }
  println("draw check: showInvestPopup=" + showInvestPopup + ", isEnteringInvestment=" + isEnteringInvestment);
}


void mousePressed() {
  if (showMarriagePopup) {
    if (yesButton.isMouseOver()) {
      int gift = int(random(5, 21)) * 10000;
      int cost = int(random(1, 31)) * 10000;
      money += (gift - cost);
      isMarried = true;
      resultMessage = "결혼 완료! 축의금 " + gift + "원, 비용 " + cost + "원";
      resultShowTime = millis();  // 현재 시간 저장
      showMarriagePopup = false;
    } else if (noButton.isMouseOver()) {
      resultMessage = "결혼 취소";
      resultShowTime = millis();
      showMarriagePopup = false;
    }
  }

  Button selectedButton = null;

  if (showHiredPopup) {
    for (Button btn : jobButtons) {
      if (btn.isMouseOver()) {
        selectedButton = btn;
        break;
      }
    }
    if (selectedButton != null) {
      currentJob = selectedButton.label;
      isHired = true;
      UR_Hired = true;

      // 직업 이름에 맞는 salary 찾기
      for (int i = 0; i < jobs.length; i++) {
        if (jobs[i].equals(currentJob)) {
          currentSalary = salary[i];
          break;
        }
      }

      resultMessage = currentJob + "로 취업! 월급: " + currentSalary + "원";
      resultShowTime = millis();
      showHiredPopup = false;
      jobButtons.clear(); //나중에 한번 더 취업 되는 경우 대비 하여 clear
    }
  }

  if (showUnivPopup) {
    if (yesButton.isMouseOver()) {
      int register = 4000;
      money -= register;
      isUniv = true;
      UR_Univ = true;
      resultMessage = "진학 완료! 등록금: " + register;
      resultShowTime = millis();  // 현재 시간 저장
      showUnivPopup = false;
    } else if (noButton.isMouseOver()) {
      resultMessage = "진학 취소";
      resultShowTime = millis();
      showUnivPopup = false;
    }
  }

  if (showInvestPopup) {

    if (yesButton.isMouseOver()) {
      isEnteringInvestment = true;
      investInput = "";

      if (currentInvestItem == 0) {
        currentInvestItem = 1;  // 첫 투자
      } else if (currentInvestItem == 1) {
        currentInvestItem = 2;  // 두 번째 투자
      }
      showInvestPopup = false;
      println("YES clicked → isEnteringInvestment=" + isEnteringInvestment + ", showInvestPopup=" + showInvestPopup);
    } else if (noButton.isMouseOver()) {
      resultMessage = "투자 취소";
      resultShowTime = millis();
      showInvestPopup = false;
    }
  }

  if (showHomePopup) {
    if (yesButton.isMouseOver()) {
      isSelectingHome = true;
      showHomePopup = false;
      
      ArrayList<Integer> indices = new ArrayList<Integer>();
      for(int i = 0; i < homeOptions.length; i++){
        indices.add(i);
      }
      
      Collections.shuffle(indices);
      
      int idx1 = indices.get(0);
      int idx2 = indices.get(1);
      

      homeButtons.clear();
      homeButtons.add(new Button(150, 250, 120, 40, homeOptions[idx1]));
      homeButtons.add(new Button(350, 250, 120, 40, homeOptions[idx2]));
    } else if (noButton.isMouseOver()) {
      resultMessage = "부동산 구매 취소";
      resultShowTime = millis();
      showHomePopup = false;
    }
  }
  
  if(isSelectingHome){
    for(Button btn : homeButtons) {
      if(btn.isMouseOver()){
        int price = 0;
        if(btn.label.equals("아파트")){
          price = 5000;
        }
        else if(btn.label.equals("빌라")){
          price = 4000;
        }
        
        if(canAfford(price)){
          
          money -= price;
        }
        else{
          resultMessage = "돈이 부족합니다! 구매 불가. ";
          resultShowTime = millis();
        }
      }
    }
  }
}


void keyPressed() {
  println("keyPressed triggered: " + key);
  if (isEnteringInvestment) {
    if (key >= '0' && key <= '9') {
      investInput += key;
    } else if (key == BACKSPACE && investInput.length() > 0) {
      investInput = investInput.substring(0, investInput.length()-1);
    } else if (key == ENTER || key == RETURN) {
      int stock = int(investInput);
      money -= stock;


      if (currentInvestItem == 1) {
        isInvest_01 = true;
        UR_Invest_01 = true;
        investAmount_01 = stock;
      } else if (currentInvestItem == 2) {
        isInvest_02 = true;
        UR_Invest_02 = true;
        investAmount_02 = stock;
      }


      resultMessage = "투자완료! 투자금: " + stock;
      resultShowTime = millis();

      isEnteringInvestment = false;
      currentInvestItem = 0;  // 초기화
    }
  }
}



ArrayList<Button> jobButtons = new ArrayList<Button>();

void setupJobButtons(String[] jobs) {
  jobButtons.clear();  // 기존 버튼 초기화
  int startX = 100;
  int startY = 220;
  int gap = 120;

  for (int i = 0; i < jobs.length; i++) {
    int x = startX + (i * gap);
    int y = startY;
    jobButtons.add(new Button(x, y, 100, 40, jobs[i]));
  }
}



// 버튼 출력
void drawJobButtons() {
  for (Button btn : jobButtons) {
    btn.display();
  }
}

//돈 체크
boolean canAfford(int price){
  return money >= price;
}

void showResult(String msg) {
  resultMessage = msg;
  resultShowTime = millis();
}
