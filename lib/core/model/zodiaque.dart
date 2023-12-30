import 'package:twinz/core/utils/utils.dart';

class SigneZodiaque {
  String nom;
  String description;
  String cheminImage;

  SigneZodiaque(this.nom, this.description, this.cheminImage);
}

List<SigneZodiaque> listeSignes = [
  SigneZodiaque(
      "${lang?.aries}",
      "${lang?.ariesDescription}",
      "assets/images/aries.svg"),
  SigneZodiaque(
      "${lang?.taurus}",
      "${lang?.taurusDescription}",
      "assets/images/taurus.svg"),
  SigneZodiaque(
      "${lang?.gemini}",
      "${lang?.geminiDescription}",
      "assets/images/gemini.svg"),
  SigneZodiaque(
      "${lang?.cancer}",
      "${lang?.cancerDescription}",
      "assets/images/cancer.svg"),
  SigneZodiaque(
      "${lang?.leo}",
      "${lang?.leoDescription}",
      "assets/images/leo.svg"),
  SigneZodiaque(
      "${lang?.virgo}",
      "${lang?.virgoDescription}",
      "assets/images/virgo.svg"),
  SigneZodiaque(
      "${lang?.libra}",
      "${lang?.libraDescription}",
      "assets/images/libra.svg"),
  SigneZodiaque(
      "${lang?.scorpio}",
      "${lang?.scorpioDescription}",
      "assets/images/scorpio.svg"),
  SigneZodiaque(
      "${lang?.sagittarius}",
      "${lang?.sagittariusDescription}",
      "assets/images/sagittarius.svg"),
  SigneZodiaque(
      "${lang?.capricorn}",
      "${lang?.capricornDescription}",
      "assets/images/capricorn.svg"),
  SigneZodiaque(
      "${lang?.aquarius}",
      "${lang?.aquariusDescription}",
      "assets/images/aquarius.svg"),
  SigneZodiaque(
      "${lang?.pisces}",
      "${lang?.piscesDescription}",
      "assets/images/pisces.svg"),
];
