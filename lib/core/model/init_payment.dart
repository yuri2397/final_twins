// To parse this JSON data, do
//
//     final initPayment = initPaymentFromJson(jsonString);

import 'dart:convert';

InitPayment initPaymentFromJson(String str) => InitPayment.fromJson(json.decode(str));

String initPaymentToJson(InitPayment data) => json.encode(data.toJson());

class InitPayment {
  String? id;
  String? object;
  int? amount;
  int? amountCapturable;
  AmountDetails? amountDetails;
  int? amountReceived;
  String? captureMethod;
  String? clientSecret;
  String? confirmationMethod;
  int? created;
  String? currency;

  InitPayment({
    this.id,
    this.object,
    this.amount,
    this.amountCapturable,
    this.amountDetails,
    this.amountReceived,
    this.captureMethod,
    this.clientSecret,
    this.confirmationMethod,
    this.created,
    this.currency,
  });

  factory InitPayment.fromJson(Map<String, dynamic> json) => InitPayment(
    id: json["id"],
    object: json["object"],
    amount: json["amount"],
    amountCapturable: json["amount_capturable"],
    amountDetails: json["amount_details"] == null ? null : AmountDetails.fromJson(json["amount_details"]),
    amountReceived: json["amount_received"],
    captureMethod: json["capture_method"],
    clientSecret: json["client_secret"],
    confirmationMethod: json["confirmation_method"],
    created: json["created"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "object": object,
    "amount": amount,
    "amount_capturable": amountCapturable,
    "amount_details": amountDetails?.toJson(),
    "amount_received": amountReceived,
    "capture_method": captureMethod,
    "client_secret": clientSecret,
    "confirmation_method": confirmationMethod,
    "created": created,
    "currency": currency,
  };
}

class AmountDetails {
  List<dynamic>? tip;

  AmountDetails({
    this.tip,
  });

  factory AmountDetails.fromJson(Map<String, dynamic> json) => AmountDetails(
    tip: json["tip"] == null ? [] : List<dynamic>.from(json["tip"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "tip": tip == null ? [] : List<dynamic>.from(tip!.map((x) => x)),
  };
}

class AutomaticPaymentMethods {
  String? allowRedirects;
  bool? enabled;

  AutomaticPaymentMethods({
    this.allowRedirects,
    this.enabled,
  });

  factory AutomaticPaymentMethods.fromJson(Map<String, dynamic> json) => AutomaticPaymentMethods(
    allowRedirects: json["allow_redirects"],
    enabled: json["enabled"],
  );

  Map<String, dynamic> toJson() => {
    "allow_redirects": allowRedirects,
    "enabled": enabled,
  };
}

class PaymentMethodConfigurationDetails {
  String? id;
  dynamic parent;

  PaymentMethodConfigurationDetails({
    this.id,
    this.parent,
  });

  factory PaymentMethodConfigurationDetails.fromJson(Map<String, dynamic> json) => PaymentMethodConfigurationDetails(
    id: json["id"],
    parent: json["parent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "parent": parent,
  };
}

class PaymentMethodOptions {
  List<dynamic>? ideal;

  PaymentMethodOptions({
    this.ideal,
  });

  factory PaymentMethodOptions.fromJson(Map<String, dynamic> json) => PaymentMethodOptions(
    ideal: json["ideal"] == null ? [] : List<dynamic>.from(json["ideal"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "ideal": ideal == null ? [] : List<dynamic>.from(ideal!.map((x) => x)),
  };
}
