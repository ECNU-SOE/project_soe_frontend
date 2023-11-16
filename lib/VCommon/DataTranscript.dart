/**
{
    "suggestedScore": 1.1,
    "allTotalScore": 1.1,
    "allToneScore": 1.1,
    "allFluencyScore": 1.1,
    "allPhoneScore": 1.1,
    "allLess": 0,
    "allMore": 0,
    "allRepl": 0,
    "allRetro": 0,
    "totPhoneScore": [
        {
            "name": "a",
            "score": 1.1
        }
    ],
    "totToneScore": [
        {
            "name": "a",
            "score": 1.1
        }
    ],
    "totFluencyScore": [
        {
            "name": "a",
            "score": 1.1
        }
    ],
    "totTotalScore": [
        {
            "name": "a",
            "score": 1.1
        }
    ],
    "totLess": [
        {
            "name": "a",
            "num": 1
        }
    ],
    "totMore": [
        {
            "name": "a",
            "num": 1
        }
    ],
    "totRepl": [
        {
            "name": "a",
            "num": 1
        }
    ],
    "totRetro": [
        {
            "name": "a",
            "num": 1
        }
    ],
    "wrongShengMu": [
        {
            "name": "a",
            "num": 1
        },
        {
            "name": "b",
            "num": 1
        },
        {
            "name": "c",
            "num": 1
        }
    ],
    "wrongYunMu": [
        {
            "name": "a",
            "num": 1
        },
        {
            "name": "b",
            "num": 1
        },
        {
            "name": "c",
            "num": 1
        }
    ]
}
 */


class DataTranscript {
  double? suggestedScore;
  double? allTotalScore;
  double? allToneScore;
  double? allFluencyScore;
  double? allPhoneScore;
  int? allLess;
  int? allMore;
  int? allRepl;
  int? allRetro;
  List<nameScore>? totPhoneScore;
  List<nameScore>? totToneScore;
  List<nameScore>? totFluencyScore;
  List<nameScore>? totTotalScore;
  List<nameNum>? totLess;
  List<nameNum>? totMore;
  List<nameNum>? totRepl;
  List<nameNum>? totRetro;
  List<nameNum>? wrongShengMu;
  List<nameNum>? wrongYunMu;

  DataTranscript(
      {this.suggestedScore,
      this.allTotalScore,
      this.allToneScore,
      this.allFluencyScore,
      this.allPhoneScore,
      this.allLess,
      this.allMore,
      this.allRepl,
      this.allRetro,
      this.totPhoneScore,
      this.totToneScore,
      this.totFluencyScore,
      this.totTotalScore,
      this.totLess,
      this.totMore,
      this.totRepl,
      this.totRetro,
      this.wrongShengMu,
      this.wrongYunMu});

  DataTranscript.fromJson(Map<String, dynamic> json) {
    suggestedScore = json['suggestedScore'];
    allTotalScore = json['allTotalScore'];
    allToneScore = json['allToneScore'];
    allFluencyScore = json['allFluencyScore'];
    allPhoneScore = json['allPhoneScore'];
    allLess = json['allLess'];
    allMore = json['allMore'];
    allRepl = json['allRepl'];
    allRetro = json['allRetro'];
    if (json['totPhoneScore'] != null) {
      totPhoneScore = <nameScore>[];
      json['totPhoneScore'].forEach((v) {
        totPhoneScore!.add(new nameScore.fromJson(v));
      });
    }
    if (json['totToneScore'] != null) {
      totToneScore = <nameScore>[];
      json['totToneScore'].forEach((v) {
        totToneScore!.add(new nameScore.fromJson(v));
      });
    }
    if (json['totFluencyScore'] != null) {
      totFluencyScore = <nameScore>[];
      json['totFluencyScore'].forEach((v) {
        totFluencyScore!.add(new nameScore.fromJson(v));
      });
    }
    if (json['totTotalScore'] != null) {
      totTotalScore = <nameScore>[];
      json['totTotalScore'].forEach((v) {
        totTotalScore!.add(new nameScore.fromJson(v));
      });
    }
    if (json['totLess'] != null) {
      totLess = <nameNum>[];
      json['totLess'].forEach((v) {
        totLess!.add(new nameNum.fromJson(v));
      });
    }
    if (json['totMore'] != null) {
      totMore = <nameNum>[];
      json['totMore'].forEach((v) {
        totMore!.add(new nameNum.fromJson(v));
      });
    }
    if (json['totRepl'] != null) {
      totRepl = <nameNum>[];
      json['totRepl'].forEach((v) {
        totRepl!.add(new nameNum.fromJson(v));
      });
    }
    if (json['totRetro'] != null) {
      totRetro = <nameNum>[];
      json['totRetro'].forEach((v) {
        totRetro!.add(new nameNum.fromJson(v));
      });
    }
    if (json['wrongShengMu'] != null) {
      wrongShengMu = <nameNum>[];
      json['wrongShengMu'].forEach((v) {
        wrongShengMu!.add(new nameNum.fromJson(v));
      });
    }
    if (json['wrongYunMu'] != null) {
      wrongYunMu = <nameNum>[];
      json['wrongYunMu'].forEach((v) {
        wrongYunMu!.add(new nameNum.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['suggestedScore'] = this.suggestedScore;
    data['allTotalScore'] = this.allTotalScore;
    data['allToneScore'] = this.allToneScore;
    data['allFluencyScore'] = this.allFluencyScore;
    data['allPhoneScore'] = this.allPhoneScore;
    data['allLess'] = this.allLess;
    data['allMore'] = this.allMore;
    data['allRepl'] = this.allRepl;
    data['allRetro'] = this.allRetro;
    if (this.totPhoneScore != null) {
      data['totPhoneScore'] =
          this.totPhoneScore!.map((v) => v.toJson()).toList();
    }
    if (this.totToneScore != null) {
      data['totToneScore'] = this.totToneScore!.map((v) => v.toJson()).toList();
    }
    if (this.totFluencyScore != null) {
      data['totFluencyScore'] =
          this.totFluencyScore!.map((v) => v.toJson()).toList();
    }
    if (this.totTotalScore != null) {
      data['totTotalScore'] =
          this.totTotalScore!.map((v) => v.toJson()).toList();
    }
    if (this.totLess != null) {
      data['totLess'] = this.totLess!.map((v) => v.toJson()).toList();
    }
    if (this.totMore != null) {
      data['totMore'] = this.totMore!.map((v) => v.toJson()).toList();
    }
    if (this.totRepl != null) {
      data['totRepl'] = this.totRepl!.map((v) => v.toJson()).toList();
    }
    if (this.totRetro != null) {
      data['totRetro'] = this.totRetro!.map((v) => v.toJson()).toList();
    }
    if (this.wrongShengMu != null) {
      data['wrongShengMu'] = this.wrongShengMu!.map((v) => v.toJson()).toList();
    }
    if (this.wrongYunMu != null) {
      data['wrongYunMu'] = this.wrongYunMu!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class nameScore {
  String? name;
  double? score;

  nameScore({this.name, this.score});

  nameScore.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['score'] = this.score;
    return data;
  }
}

class nameNum {
  String? name;
  int? num;

  nameNum({this.name, this.num});

  nameNum.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    num = json['num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['num'] = this.num;
    return data;
  }
}

/*
{
    "suggestedScore": 0,
    "allTotalScore": 0,
    "allPhoneScore": 0,
    "allToneScore": 0,
    "allFluencyScore": 0,
    "allLess": 662,
    "allMore": 0,
    "allRepl": 0,
    "allRetro": 0,
    "totPhoneScore": [
        {
            "name": "字词训练",
            "score": 0
        },
        {
            "name": "常速朗读",
            "score": 0
        }
    ],
    "totToneScore": [
        {
            "name": "字词训练",
            "score": 0
        },
        {
            "name": "常速朗读",
            "score": 0
        }
    ],
    "totFluencyScore": [
        {
            "name": "字词训练",
            "score": 0
        },
        {
            "name": "常速朗读",
            "score": 0
        }
    ],
    "totTotalScore": [
        {
            "name": "字词训练",
            "score": 0
        },
        {
            "name": "常速朗读",
            "score": 0
        }
    ],
    "totLess": [
        {
            "name": "字词训练",
            "num": 173
        },
        {
            "name": "常速朗读",
            "num": 489
        }
    ],
    "totMore": [
        {
            "name": "字词训练",
            "num": 0
        },
        {
            "name": "常速朗读",
            "num": 0
        }
    ],
    "totRepl": [
        {
            "name": "字词训练",
            "num": 0
        },
        {
            "name": "常速朗读",
            "num": 0
        }
    ],
    "totRetro": [
        {
            "name": "字词训练",
            "num": 0
        },
        {
            "name": "常速朗读",
            "num": 0
        }
    ],
    "wrongShengMu": [
        {
            "name": "zh",
            "num": 1
        },
        {
            "name": "m",
            "num": 1
        },
        {
            "name": "t",
            "num": 2
        },
        {
            "name": "sh",
            "num": 1
        }
    ],
    "wrongYunMu": [
        {
            "name": "v",
            "num": 1
        },
        {
            "name": "a",
            "num": 3
        },
        {
            "name": "iii",
            "num": 1
        },
        {
            "name": "ou",
            "num": 1
        },
        {
            "name": "ao",
            "num": 1
        }
    ]
}
*/