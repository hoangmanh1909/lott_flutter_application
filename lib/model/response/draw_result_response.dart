class DrawResultResponse {
  int? iD;
  int? productID;
  String? drawCode;
  int? drawDate;
  String? drawTime;
  int? jackpotMin1;
  int? jackpot1;
  int? jackpotMin2;
  int? jackpot2;
  String? result;
  String? result01;
  String? result02;
  String? result03;
  String? result04;
  String? result05;
  String? result06;
  String? result07;
  String? result08;
  String? bonus;
  int? radioID;
  String? radioName;
  String? symbols;
  int? area;
  int? day;
  int? numberOfJackpot1;
  int? numberOfJackpot2;
  int? numberOfDB;
  int? numberOf01;
  int? numberOf02;
  int? numberOf03;
  int? numberOf04;
  int? numberOf05;
  int? numberOf06;
  int? numberOf07;
  int? numberOfBasic01;
  int? numberOfBasic02;
  int? numberOfBasic03;
  int? numberOfBasic04;

  DrawResultResponse(
      {this.iD,
      this.productID,
      this.drawCode,
      this.drawDate,
      this.drawTime,
      this.jackpotMin1,
      this.jackpot1,
      this.jackpotMin2,
      this.jackpot2,
      this.result,
      this.result01,
      this.result02,
      this.result03,
      this.result04,
      this.result05,
      this.result06,
      this.result07,
      this.result08,
      this.bonus,
      this.radioID,
      this.radioName,
      this.symbols,
      this.area,
      this.day,
      this.numberOfJackpot1,
      this.numberOfJackpot2,
      this.numberOfDB,
      this.numberOf01,
      this.numberOf02,
      this.numberOf03,
      this.numberOf04,
      this.numberOf05,
      this.numberOf06,
      this.numberOf07,
      this.numberOfBasic01,
      this.numberOfBasic02,
      this.numberOfBasic03,
      this.numberOfBasic04});

  DrawResultResponse.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    productID = json['ProductID'];
    drawCode = json['DrawCode'];
    drawDate = json['DrawDate'];
    drawTime = json['DrawTime'];
    jackpotMin1 = json['JackpotMin1'];
    jackpot1 = json['Jackpot1'];
    jackpotMin2 = json['JackpotMin2'];
    jackpot2 = json['Jackpot2'];
    result = json['Result'];
    result01 = json['Result01'];
    result02 = json['Result02'];
    result03 = json['Result03'];
    result04 = json['Result04'];
    result05 = json['Result05'];
    result06 = json['Result06'];
    result07 = json['Result07'];
    result08 = json['Result08'];
    bonus = json['Bonus'];
    radioID = json['RadioID'];
    radioName = json['RadioName'];
    symbols = json['Symbols'];
    area = json['Area'];
    day = json['Day'];
    numberOfJackpot1 = json['NumberOfJackpot1'];
    numberOfJackpot2 = json['NumberOfJackpot2'];
    numberOfDB = json['NumberOfDB'];
    numberOf01 = json['NumberOf01'];
    numberOf02 = json['NumberOf02'];
    numberOf03 = json['NumberOf03'];
    numberOf04 = json['NumberOf04'];
    numberOf05 = json['NumberOf05'];
    numberOf06 = json['NumberOf06'];
    numberOf07 = json['NumberOf07'];
    numberOfBasic01 = json['NumberOfBasic01'];
    numberOfBasic02 = json['NumberOfBasic02'];
    numberOfBasic03 = json['NumberOfBasic03'];
    numberOfBasic04 = json['NumberOfBasic04'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['ProductID'] = productID;
    data['DrawCode'] = drawCode;
    data['DrawDate'] = drawDate;
    data['DrawTime'] = drawTime;
    data['JackpotMin1'] = jackpotMin1;
    data['Jackpot1'] = jackpot1;
    data['JackpotMin2'] = jackpotMin2;
    data['Jackpot2'] = jackpot2;
    data['Result'] = result;
    data['Result01'] = result01;
    data['Result02'] = result02;
    data['Result03'] = result03;
    data['Result04'] = result04;
    data['Result05'] = result05;
    data['Result06'] = result06;
    data['Result07'] = result07;
    data['Result08'] = result08;
    data['Bonus'] = bonus;
    data['RadioID'] = radioID;
    data['RadioName'] = radioName;
    data['Symbols'] = symbols;
    data['Area'] = area;
    data['Day'] = day;
    data['NumberOfJackpot1'] = numberOfJackpot1;
    data['NumberOfJackpot2'] = numberOfJackpot2;
    data['NumberOfDB'] = numberOfDB;
    data['NumberOf01'] = numberOf01;
    data['NumberOf02'] = numberOf02;
    data['NumberOf03'] = numberOf03;
    data['NumberOf04'] = numberOf04;
    data['NumberOf05'] = numberOf05;
    data['NumberOf06'] = numberOf06;
    data['NumberOf07'] = numberOf07;
    data['NumberOfBasic01'] = numberOfBasic01;
    data['NumberOfBasic02'] = numberOfBasic02;
    data['NumberOfBasic03'] = numberOfBasic03;
    data['NumberOfBasic04'] = numberOfBasic04;
    return data;
  }
}
