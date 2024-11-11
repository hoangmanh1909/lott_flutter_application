class DrawResultRequest {
  int? day;
  int? fromDate;
  int? toDate;
  int? productID;
  int? area;
  int? radioID;
  String? isVietlott;
  int? pageIndex;
  int? pageSize;

  DrawResultRequest(
      {this.day = 0,
      this.fromDate = 0,
      this.toDate = 0,
      this.productID = 0,
      this.area = 0,
      this.radioID = 0,
      this.isVietlott,
      this.pageIndex = 0,
      this.pageSize = 0});

  DrawResultRequest.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    productID = json['productID'];
    area = json['area'];
    radioID = json['radioID'];
    isVietlott = json['isVietlott'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['productID'] = productID;
    data['area'] = area;
    data['radioID'] = radioID;
    data['isVietlott'] = isVietlott;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    return data;
  }
}
