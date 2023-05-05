// ignore_for_file: camel_case_types

class btcMarket {
  String _fromsymbol;
  String _tosymbol;
  String _market;
  String _price;
  String _lastupdate;
  String _lastvolume;
  String _lastvolumeto;
  String _lasttradeid;
  String _volumeday;
  String _volumedayto;
  String _volume24hour;
  String _volume24hourto;
  String _openday;
  String _highday;
  String _lowday;
  String _open24hour;
  String _high24hour;
  String _low24hour;
  String _lastmarket;
  String _volumehour;
  String _volumehourto;
  String _openhour;
  String _highhour;
  String _lowhour;
  String _toptiervolume24hour;
  String _toptiervolume24hourto;
  String _change24hour;
  String _changepct24hour;
  String _changeday;
  String _changepctday;
  String _changehour;
  String _changepcthour;
  String _conversiontype;
  String _conversionsymbol;
  String _supply;
  String _mktcap;
  String _mktcappenalty;
  String _totalvolume24h;
  String _totalvolume24hto;
  String _totaltoptiervolume24h;
  String _totaltoptiervolume24hto;
  String _imageurl;

  String get fromsymbol => _fromsymbol;
  String get tosymbol => _tosymbol;
  String get market => _market;
  String get price => _price;
  String get lastupdate => _lastupdate;
  String get lastvolume => _lastvolume;
  String get lastvolumeto => _lastvolumeto;
  String get lasttradeid => _lasttradeid;
  String get volumeday => _volumeday;
  String get volumedayto => _volumedayto;
  String get volume24hour => _volume24hour;
  String get volume24hourto => _volume24hourto;
  String get openday => _openday;
  String get highday => _highday;
  String get lowday => _lowday;
  String get open24hour => _open24hour;
  String get high24hour => _high24hour;
  String get low24hour => _low24hour;
  String get lastmarket => _lastmarket;
  String get volumehour => _volumehour;
  String get volumehourto => _volumehourto;
  String get openhour => _openhour;
  String get highhour => _highhour;
  String get lowhour => _lowhour;
  String get toptiervolume24hour => _toptiervolume24hour;
  String get toptiervolume24hourto => _toptiervolume24hourto;
  String get change24hour => _change24hour;
  String get changepct24hour => _changepct24hour;
  String get changeday => _changeday;
  String get changepctday => _changepctday;
  String get changehour => _changehour;
  String get changepcthour => _changepcthour;
  String get conversiontype => _conversiontype;
  String get conversionsymbol => _conversionsymbol;
  String get supply => _supply;
  String get mktcap => _mktcap;
  String get mktcappenalty => _mktcappenalty;
  String get totalvolume24h => _totalvolume24h;
  String get totalvolume24hto => _totalvolume24hto;
  String get totaltoptiervolume24h => _totaltoptiervolume24h;
  String get totaltoptiervolume24hto => _totaltoptiervolume24hto;
  String get imageurl => _imageurl;

  btcMarket(
      {String fromsymbol,
      String tosymbol,
      String market,
      String price,
      String lastupdate,
      String lastvolume,
      String lastvolumeto,
      String lasttradeid,
      String volumeday,
      String volumedayto,
      String volume24hour,
      String volume24hourto,
      String openday,
      String highday,
      String lowday,
      String open24hour,
      String high24hour,
      String low24hour,
      String lastmarket,
      String volumehour,
      String volumehourto,
      String openhour,
      String highhour,
      String lowhour,
      String toptiervolume24hour,
      String toptiervolume24hourto,
      String change24hour,
      String changepct24hour,
      String changeday,
      String changepctday,
      String changehour,
      String changepcthour,
      String conversiontype,
      String conversionsymbol,
      String supply,
      String mktcap,
      String mktcappenalty,
      String totalvolume24h,
      String totalvolume24hto,
      String totaltoptiervolume24h,
      String totaltoptiervolume24hto,
      String imageurl}) {
    _fromsymbol = fromsymbol;
    _tosymbol = tosymbol;
    _market = market;
    _price = price;
    _lastupdate = lastupdate;
    _lastvolume = lastvolume;
    _lastvolumeto = lastvolumeto;
    _lasttradeid = lasttradeid;
    _volumeday = volumeday;
    _volumedayto = volumedayto;
    _volume24hour = volume24hour;
    _volume24hourto = volume24hourto;
    _openday = openday;
    _highday = highday;
    _lowday = lowday;
    _open24hour = open24hour;
    _high24hour = high24hour;
    _low24hour = low24hour;
    _lastmarket = lastmarket;
    _volumehour = volumehour;
    _volumehourto = volumehourto;
    _openhour = openhour;
    _highhour = highhour;
    _lowhour = lowhour;
    _toptiervolume24hour = toptiervolume24hour;
    _toptiervolume24hourto = toptiervolume24hourto;
    _change24hour = change24hour;
    _changepct24hour = changepct24hour;
    _changeday = changeday;
    _changepctday = changepctday;
    _changehour = changehour;
    _changepcthour = changepcthour;
    _conversiontype = conversiontype;
    _conversionsymbol = conversionsymbol;
    _supply = supply;
    _mktcap = mktcap;
    _mktcappenalty = mktcappenalty;
    _totalvolume24h = totalvolume24h;
    _totalvolume24hto = totalvolume24hto;
    _totaltoptiervolume24h = totaltoptiervolume24h;
    _totaltoptiervolume24hto = totaltoptiervolume24hto;
    _imageurl = imageurl;
  }

  btcMarket.fromJson(dynamic json) {
    _fromsymbol = json["FROMSYMBOL"];
    _tosymbol = json["TOSYMBOL"];
    _market = json["MARKET"];
    _price = json["PRICE"];
    _lastupdate = json["LASTUPDATE"];
    _lastvolume = json["LASTVOLUME"];
    _lastvolumeto = json["LASTVOLUMETO"];
    _lasttradeid = json["LASTTRADEID"];
    _volumeday = json["VOLUMEDAY"];
    _volumedayto = json["VOLUMEDAYTO"];
    _volume24hour = json["VOLUME24HOUR"];
    _volume24hourto = json["VOLUME24HOURTO"];
    _openday = json["OPENDAY"];
    _highday = json["HIGHDAY"];
    _lowday = json["LOWDAY"];
    _open24hour = json["OPEN24HOUR"];
    _high24hour = json["HIGH24HOUR"];
    _low24hour = json["LOW24HOUR"];
    _lastmarket = json["LASTMARKET"];
    _volumehour = json["VOLUMEHOUR"];
    _volumehourto = json["VOLUMEHOURTO"];
    _openhour = json["OPENHOUR"];
    _highhour = json["HIGHHOUR"];
    _lowhour = json["LOWHOUR"];
    _toptiervolume24hour = json["TOPTIERVOLUME24HOUR"];
    _toptiervolume24hourto = json["TOPTIERVOLUME24HOURTO"];
    _change24hour = json["CHANGE24HOUR"];
    _changepct24hour = json["CHANGEPCT24HOUR"];
    _changeday = json["CHANGEDAY"];
    _changepctday = json["CHANGEPCTDAY"];
    _changehour = json["CHANGEHOUR"];
    _changepcthour = json["CHANGEPCTHOUR"];
    _conversiontype = json["CONVERSIONTYPE"];
    _conversionsymbol = json["CONVERSIONSYMBOL"];
    _supply = json["SUPPLY"];
    _mktcap = json["MKTCAP"];
    _mktcappenalty = json["MKTCAPPENALTY"];
    _totalvolume24h = json["TOTALVOLUME24H"];
    _totalvolume24hto = json["TOTALVOLUME24HTO"];
    _totaltoptiervolume24h = json["TOTALTOPTIERVOLUME24H"];
    _totaltoptiervolume24hto = json["TOTALTOPTIERVOLUME24HTO"];
    _imageurl = json["IMAGEURL"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["FROMSYMBOL"] = _fromsymbol;
    map["TOSYMBOL"] = _tosymbol;
    map["MARKET"] = _market;
    map["PRICE"] = _price;
    map["LASTUPDATE"] = _lastupdate;
    map["LASTVOLUME"] = _lastvolume;
    map["LASTVOLUMETO"] = _lastvolumeto;
    map["LASTTRADEID"] = _lasttradeid;
    map["VOLUMEDAY"] = _volumeday;
    map["VOLUMEDAYTO"] = _volumedayto;
    map["VOLUME24HOUR"] = _volume24hour;
    map["VOLUME24HOURTO"] = _volume24hourto;
    map["OPENDAY"] = _openday;
    map["HIGHDAY"] = _highday;
    map["LOWDAY"] = _lowday;
    map["OPEN24HOUR"] = _open24hour;
    map["HIGH24HOUR"] = _high24hour;
    map["LOW24HOUR"] = _low24hour;
    map["LASTMARKET"] = _lastmarket;
    map["VOLUMEHOUR"] = _volumehour;
    map["VOLUMEHOURTO"] = _volumehourto;
    map["OPENHOUR"] = _openhour;
    map["HIGHHOUR"] = _highhour;
    map["LOWHOUR"] = _lowhour;
    map["TOPTIERVOLUME24HOUR"] = _toptiervolume24hour;
    map["TOPTIERVOLUME24HOURTO"] = _toptiervolume24hourto;
    map["CHANGE24HOUR"] = _change24hour;
    map["CHANGEPCT24HOUR"] = _changepct24hour;
    map["CHANGEDAY"] = _changeday;
    map["CHANGEPCTDAY"] = _changepctday;
    map["CHANGEHOUR"] = _changehour;
    map["CHANGEPCTHOUR"] = _changepcthour;
    map["CONVERSIONTYPE"] = _conversiontype;
    map["CONVERSIONSYMBOL"] = _conversionsymbol;
    map["SUPPLY"] = _supply;
    map["MKTCAP"] = _mktcap;
    map["MKTCAPPENALTY"] = _mktcappenalty;
    map["TOTALVOLUME24H"] = _totalvolume24h;
    map["TOTALVOLUME24HTO"] = _totalvolume24hto;
    map["TOTALTOPTIERVOLUME24H"] = _totaltoptiervolume24h;
    map["TOTALTOPTIERVOLUME24HTO"] = _totaltoptiervolume24hto;
    map["IMAGEURL"] = _imageurl;
    return map;
  }
}
