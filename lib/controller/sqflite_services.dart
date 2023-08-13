/* import 'dart:core';

import 'package:logger/logger.dart';
import 'package:path/path.dart';


class MySqfliteServices {
  final logger = Logger();
  static Future<Database> dbInit() async {
    //initiate db
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'app.db');

    //delete the Database
    // await deleteDatabase(path);

    return await openDatabase(
      //open the database or create a database if there isn't any
      path,
      version: MaaData.VERSION,
      onCreate: (db, version) async {
        // c: Mom Part
        await db.execute(
            "CREATE TABLE ${MyKeywords.momprimaryTable} (${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER PRIMARY KEY AUTOINCREMENT, ${MyKeywords.uid} TEXT, ${MyKeywords.phone} TEXT, ${MyKeywords.sessionStart} TEXT, ${MyKeywords.expectedSessionEnd} TEXT,  ${MyKeywords.sessionEnd} TEXT, ${MyKeywords.timestamp} NUMBER)");

        await db.execute(
            "CREATE TABLE ${MyKeywords.momnoteTable} (${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER, date TEXT, note TEXT)"); /*     await db.execute(
            "CREATE TABLE ${MyKeywords.momnoteTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, note TEXT)"); */

        await db.execute(
            "CREATE TABLE ${MyKeywords.momsymptomsTable} (${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER, date TEXT, symptoms TEXT)"); /*    await db.execute(
            "CREATE TABLE ${MyKeywords.momsymptomsTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, symptoms TEXT)"); */

        await db.execute(
            "CREATE TABLE ${MyKeywords.weeklychangesTable} (id INTEGER PRIMARY KEY AUTOINCREMENT,  ${MyKeywords.weekNo} TEXT, title TEXT, ${MyKeywords.changesInChild} TEXT, ${MyKeywords.changesInMom} TEXT, symptoms TEXT, instructions TEXT)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.momweightTable} (${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER, ${MyKeywords.weekNo} NUMBER, ${MyKeywords.weight} NUMBER, ${MyKeywords.timestamp} NUMBER)");

        // c: Baby Part
        await db.execute("CREATE TABLE ${MyKeywords.babydiaryTable}"
            " (id INTEGER PRIMARY KEY AUTOINCREMENT, baby_id NUMBER, email TEXT, ${MyKeywords.momId} INTEGER, imgUrl TEXT, latitude number, longitude number, timestamp TEXT, date TEXT, caption TEXT)");

        /*         await db.execute(
            "CREATE TABLE ${MyKeywords.babygrowthTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, baby_id NUMBER, ${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER, timestar NUMBER, ques_id TEXT, question TEXT,  status NUMBER, timestamp TEXT, options TEXT)"); */
        await db.execute(
            "CREATE TABLE ${MyKeywords.babygrowthQuesTable} (id INTEGER PRIMARY KEY AUTOINCREMENT, ques_id TEXT, question TEXT, timestar NUMBER)");

        await db.execute(
            "CREATE TABLE ${MyKeywords.babyinfoTable} (${MyKeywords.baby_id} INTEGER PRIMARY KEY AUTOINCREMENT, ${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER, ${MyKeywords.babyName} TEXT, ${MyKeywords.dob} TEXT, ${MyKeywords.gender} TEXT, ${MyKeywords.weight} TEXT,${MyKeywords.height} TEXT, ${MyKeywords.headCircumstance} TEXT, ${MyKeywords.fatherName} TEXT, ${MyKeywords.motherName} TEXT, ${MyKeywords.doctorName} TEXT, ${MyKeywords.nurseName} TEXT, ${MyKeywords.timestamp} NUMBER, ${MyKeywords.activeStatus} NUMBER)");

        await db.execute(
            "CREATE TABLE ${MyKeywords.babyweightsAndHeightsTable} (${MyKeywords.email} TEXT, ${MyKeywords.momId} INTEGER, ${MyKeywords.baby_id} INTEGER, ${MyKeywords.ageNum} INTEGER, ${MyKeywords.ageTag} TEXT, ${MyKeywords.babyWeight} NUMBER, ${MyKeywords.babyHeight} NUMBER)");
        await db.execute(
            "CREATE TABLE ${MyKeywords.babygrowthResponseTable} (${MyKeywords.email} TEXT, ${MyKeywords.momId} NUMBER, ${MyKeywords.baby_id} NUMBER, ${MyKeywords.quesId} TEXT, ${MyKeywords.answerStatus} NUMBER)");

        /* id INTEGER PRIMARY KEY AUTOINCREMENT,  */
      },
    );
  }

  static Future<bool> mIsDbTableEmpty({required String tableName}) async {
    final db = await MySqfliteServices.dbInit();
    int count = 0;

    count = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tableName"))!;
    // Logger().d("db count $count");

    if (count > 0) {
      return false;
    } else {
      return true;
    }
  }

  static Future<int> mAddBabyInfo(
      {required int momId,
      required String email,
      required String babyName,
      required String dob,
      required String weight,
      required String height,
      required String gender,
      String? headCircumstance,
      String? fatherName,
      String? motherName,
      String? doctorName,
      String? nurseName}) async {
    final db = await MySqfliteServices.dbInit();
    var ts = DateTime.now().microsecondsSinceEpoch;

    int i = await db.insert(
        MyKeywords.babyinfoTable,
        {
          MyKeywords.momId: momId,
          MyKeywords.email: email,
          MyKeywords.babyName: babyName,
          MyKeywords.dob: dob,
          MyKeywords.weight: weight,
          MyKeywords.height: height,
          MyKeywords.gender: gender,
          MyKeywords.headCircumstance: headCircumstance,
          MyKeywords.fatherName: fatherName,
          MyKeywords.motherName: motherName,
          MyKeywords.doctorName: doctorName,
          MyKeywords.nurseName: nurseName,
          MyKeywords.timestamp: ts
        },
        conflictAlgorithm: ConflictAlgorithm.ignore);
    final r = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    var babyId = int.parse(r[0][MyKeywords.baby_id].toString());
    mUpdateActiveStatusOfBaby(email, babyId, momId);

    var weightsList = MyServices.mGetDummyBabyOjons();
    var heightsList = MyServices.mGetDummyBabyHeights();
    weightsList.insert(0, weight.toString());
    heightsList.insert(0, height.toString());
    var ageNumList = MyServices.mProduceWeekMonthNo();

    // Logger().d("ageNumList ${ageNumList.length} weightlist ${weightsList.length}");

    //c: store weightlist and heightList against id
    List<CurrentBabyInfo> list = [];
    List<CurrentBabyInfo> list1 = [];
    late int n;
    var ageTag = MyKeywords.weekAsTag;
    for (var i = 0; i < ageNumList.length; i++) {
      var ageNum = ageNumList[i];
      if (i > 13) {
        ageTag = MyKeywords.monthAsTag;
      }

      // Logger().d("Baby id is: $id");

      // c: create object list for weight
      list.add(
        CurrentBabyInfo.weightAndHeight(
            babyId: babyId,
            ageNum: ageNum,
            ageTag: ageTag,
            dummyWeight: weightsList[i],
            dummyHeight: heightsList[i]),
      );
      /* 
      list1.add(CurrentBabyInfo.height(
          baby_id: id,
          ageNum: ageNum,
          ageTag: ageTag,
          dummyHeight: 0.toString())); */
      // c: store each object into babyweights table
      n = await db.insert(MyKeywords.babyweightsAndHeightsTable,
          list[i].weightsAndHeightsToJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
    }

    Logger().d("Done.");

    return i;

    /* Logger().d("babyName: $babyName");
    Logger().d("dob: $dob");
    Logger().d("weight: $weight");
    Logger().d("headCircumstance: $headCircumstance");
    Logger().d("fatherName: $fatherName");
    Logger().d("motherName: $motherName");
    Logger().d("doctorName: $doctorName");
    Logger().d("nurseName: ${nurseName.runtimeType}"); */
  }

  static Future<List<String>> mGetBabyCurrentHeightList() async {
    final db = await MySqfliteServices.dbInit();
    List<String> heightList = [];
    int id;
    var mapResults;

    await MySqfliteServices.mGetCurrentBabyId().then((value) async {
      id = value;
      mapResults = await db.rawQuery(
          "SELECT ${MyKeywords.babyHeight} FROM ${MyKeywords.babyweightsAndHeightsTable} WHERE ${MyKeywords.baby_id} = ?",
          [id]);
    });

    // Logger().d("Here Current id is: $id");

    List.generate(mapResults.length, (index) {
      heightList.add(mapResults[index][MyKeywords.babyHeight].toString());
      // Logger().d("Lsit: ${mapResults[index][MyKeywords.dummyWeight].toString()}");
    });

    return heightList;
  }

  static Future<Map<String, dynamic>> mGetBabyCurrentWeightHeightList({required babyId, required email, required momId}) async {
    final db = await MySqfliteServices.dbInit();
    List<String> babyWeightList = [];
    List<String> babyHeightList = [];
    List<Map<String, Object?>> mapResults;

    /* await MySqfliteServices.mGetCurrentBabyId().then((value) async {
      id = value;
      mapResults = await db.rawQuery(
          "SELECT ${MyKeywords.babyWeight}, ${MyKeywords.babyHeight} FROM ${MyKeywords.babyweightsAndHeightsTable} WHERE ${MyKeywords.baby_id} = ?",
          [id]);
    }); */

     mapResults = await db.rawQuery(
          "SELECT ${MyKeywords.babyWeight}, ${MyKeywords.babyHeight} FROM ${MyKeywords.babyweightsAndHeightsTable} WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND ${MyKeywords.baby_id} = ?",
          [email, momId, babyId]);

    // Logger().d("Here Current id is: $id");

    List.generate(mapResults.length, (index) {
      babyWeightList.add(mapResults[index][MyKeywords.babyWeight].toString());
      // Logger().d("Lsit: ${mapResults[index][MyKeywords.dummyWeight].toString()}");
    });
    List.generate(mapResults.length, (index) {
      babyHeightList.add(mapResults[index][MyKeywords.babyHeight].toString());
      // Logger().d("Lsit: ${mapResults[index][MyKeywords.dummyWeight].toString()}");
    });

    return {
      MyKeywords.babyWeight: babyWeightList,
      MyKeywords.babyHeight: babyHeightList
    };
  }

  static Future<int> mGetCurrentBabyId() async {
    final db = await MySqfliteServices.dbInit();

    final r1 = await db.rawQuery(
        "SELECT ${MyKeywords.baby_id} FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    int id = int.parse(r1[0][MyKeywords.baby_id].toString());
    return id;
  }

  static Future<DateTime> mGetCurrentBabyDob(
      {required int momId, required int babyId, required String email}) async {
    final db = await MySqfliteServices.dbInit();
    var result;
    await MySqfliteServices.mGetCurrentBabyId().then((id) async {
      result = await db.rawQuery(
          "SELECT ${MyKeywords.dob} FROM ${MyKeywords.babyinfoTable} WHERE  ${MyKeywords.momId} = ? AND ${MyKeywords.baby_id} = ? AND ${MyKeywords.email} = ?",
          [momId, babyId, email]);
    });
    // final mapResult =
    DateTime dateTime = DateTime.parse(result[0][MyKeywords.dob]);

    return dateTime;
  }

  static Future<void> mUpdateAnswerStatus(
      {required int momId,
      required String email,
      required int babyId,
      required String quesId,
      required int answerStatus}) async {
    final db = await MySqfliteServices.dbInit();
    var r = await db.rawUpdate(
        "UPDATE ${MyKeywords.babygrowthResponseTable} SET ${MyKeywords.answerStatus} = ? WHERE ${MyKeywords.momId} = ? AND ${MyKeywords.email} = ? AND ${MyKeywords.baby_id} = ? AND ${MyKeywords.quesId} = ?",
        [answerStatus, momId, email, babyId, quesId]);

    Logger().d("update result: $r");

    if (r == 0) {
      //insert
      /*  await db.rawInsert(
          "INSERT INTO ${MyKeywords.babygrowthResponseTable}(${MyKeywords.email}, ${MyKeywords.momId}, ${MyKeywords.baby_id}, ${MyKeywords.quesId}, ${MyKeywords.answerStatus}) VALUES($email, $momId, $babyId, $quesId, $answerStatus)"); */

      await db.insert(MyKeywords.babygrowthResponseTable, {
        MyKeywords.email: email,
        MyKeywords.momId: momId,
        MyKeywords.baby_id: babyId,
        MyKeywords.quesId: quesId,
        MyKeywords.answerStatus: answerStatus,
      });

      Logger().d('answer inserted as $answerStatus');
    } else {
      Logger().d("answer Updated as $answerStatus");
    }
  }

  static Future<int?> mAddMomPrimaryDetails(
      {required String sessionStart,
      required String uid,
      required String email,
      required String expectedSessionEnd,
      String? phone,
      String? sessionEnd}) async {
    final db = await MySqfliteServices.dbInit();

    try {
      await db.insert(
          MyKeywords.momprimaryTable,
          {
            MyKeywords.email: email,
            MyKeywords.uid: uid,
            MyKeywords.sessionStart: sessionStart,
            MyKeywords.phone: phone,
            MyKeywords.expectedSessionEnd: expectedSessionEnd,
            MyKeywords.sessionEnd: sessionEnd,
            MyKeywords.timestamp: DateTime.now().millisecondsSinceEpoch,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore);
      Logger().d("Done: new session added.");
    } catch (e) {
      Logger().d("Error: new session not added");
    }

    try {
      var r = await db.rawQuery(
          "SELECT * FROM ${MyKeywords.momprimaryTable} ORDER BY ${MyKeywords.timestamp} DESC LIMIT 1");
      int momId = MomInfo.fromJson(json: r.first).momId;
      Logger().d("momId: $momId");
      return momId;
    } catch (e) {
      Logger().d(e);
      Logger().d('Error: BabyPrimaryDetails not added in sqflite');
      return null;
    }

    // return numOfInsertedRow;
  }

  static Future<MomInfo?> mFetchMomInfo(
      {required String email, required int currentMomId}) async {
    final db = await MySqfliteServices.dbInit();

    try {
      var r = await db.rawQuery(
          "SELECT * FROM ${MyKeywords.momprimaryTable} WHERE ${MyKeywords.momId} = ? AND ${MyKeywords.email} = ?",
          [currentMomId, email]);

      MomInfo momInfo = MomInfo.fromJson(json: r.first);

      return momInfo;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>> mFetchSessionStartAndExpectedEndDate(
      {required int momId, required String email}) async {
    final db = await MySqfliteServices.dbInit();

    var result = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.momprimaryTable} WHERE ${MyKeywords.momId} = ? AND ${MyKeywords.email} = ? ",
        [momId, email]);

    Logger().d(result.length);

    return {
      MyKeywords.sessionStart: result.first[MyKeywords.sessionStart],
      MyKeywords.sessionEnd: result.first[MyKeywords.sessionEnd]
    };
  }

  static Future<int> mAddInitialQuesDataOfBabyGrowth(
      {required BabyGrowthModel babyGrowthModel}) async {
    final db = await MySqfliteServices.dbInit();

    var numOfInserted = db.insert(
        MyKeywords.babygrowthQuesTable, babyGrowthModel.toJsonInitialQuesData(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return numOfInserted;
  }

  static Future<void> mAddInitialMomWeights(
      {/* required String email,
      required String babyid,
      required int weekno,
      required double weight */
      required MomWeight momWeight}) async {
    final db = await MySqfliteServices.dbInit();

    // Logger().d("My baby id: " + momWeight.momId.toString());

    db.insert(MyKeywords.momweightTable, momWeight.toJosn(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> mAddWeeklyChangeData(bool isDbTableEmpty) async {
    if (isDbTableEmpty) {
      final db = await MySqfliteServices.dbInit();
      int startWeekNo = MaaData.startWeekNo;
      int endWeekNo = MaaData.endWeekNo;
      int insertedRowNum = 0;

      for (var i = startWeekNo; i <= endWeekNo; i++) {
        String currentWeekNo = 'week_$i';
        Map<String, dynamic> map = MaaData.WeeklyChangeJsonData[currentWeekNo];

        insertedRowNum = await db.insert(
          MyKeywords.weeklychangesTable,
          {
            MyKeywords.weekNo: currentWeekNo,
            'title': map['title'],
            MyKeywords.changesInChild: map[MyKeywords.changesInChild],
            MyKeywords.changesInMom: map[MyKeywords.changesInMom],
            'symptoms': map['symptoms'],
            'instructions': map['instructions'],
          },
          conflictAlgorithm: ConflictAlgorithm
              .ignore, // ignores conflictAlgo due to duplicate entries
        );
      }
      // Logger().d(insertedRowNum);
    }
  }

  static Future<void> addNote(
      {required MomInfo momInfo, required NoteModel noteModel}) async {
    // return number of items inserted as int
    final db = await MySqfliteServices.dbInit();
    /*   var res = await db.rawInsert(
        "INSERT INTO ${MyKeywords.momnoteTable}(${MyKeywords.email},${MyKeywords.momId}, note, date) VALUES(${momInfo.email}, ${momInfo.momId}, ${noteModel.note}, ${noteModel.date})"); */
    var res = await db.insert(
        MyKeywords.momnoteTable,
        NoteModel.nConstructor1(
                date: noteModel.date,
                note: noteModel.note,
                email: momInfo.email,
                momId: momInfo.momId)
            .toJson());
    if (res > 0) {
      Logger().d("Note Inserted Successfully");
    }
  }

// c: [Deprecated] for single image selection
/*   static Future<int> mAddBabyGalleryDataToLocal(
      ImageDetailsModel imageDetailsModel) async {
    final db = await SqfliteServices.dbInit();

    Logger().d('json decode : ' + (imageDetailsModel.date.toString()));

    return db.insert(
        MaaData.TABLE_NAMES[4], imageDetailsModel.toJsonForSqlite(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  } */
  //c: for multiple selection of image
  static Future<int> mAddBabyGalleryDataToLocal(
      List<ImageDetailsModel> listImageDetailsModel) async {
    final db = await MySqfliteServices.dbInit();
    int insertCount = 0;

    for (var item in listImageDetailsModel) {
      // Logger().d('json decode : ' + (item.date.toString()));

      await db.insert(MyKeywords.babydiaryTable, item.allDataToJson(),
          conflictAlgorithm: ConflictAlgorithm.ignore);
      insertCount++;
    }
    return insertCount;
  }

  static Future<void> addSympIntensity(
      {required SymptomDetailsModel sympIntenSityModel,
      required MomInfo momInfo}) async {
    final db = await MySqfliteServices.dbInit();

    var res = await db.insert(
        MyKeywords.momsymptomsTable,
        SymptomDetailsModel.nInsertSymp(
                email: momInfo.email,
                momId: momInfo.momId,
                symptoms: sympIntenSityModel.symptoms,
                date: sympIntenSityModel.date)
            .toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    if (res > 0) {
      Logger().d("Symptoms Inserted Successfully");
    }
  }

  static Future<List<NoteModel>> mFetchNotes() async {
    // returns the memos as a list (array)
    final db = await MySqfliteServices.dbInit();
    // query all the rows in a table as an array of maps
    // final maps = await db.query("SELECT * FROM momnote");
    final maps = await db.rawQuery("SELECT * FROM ${MyKeywords.momnoteTable}");
    // final maps = await db.rawQuery("SELECT * FROM ${MaaData.TABLE_NAMES[0]}");

    // Logger().d(maps.length);
    return List.generate(maps.length,
        // create a list of notes
        (index) {
      return NoteModel(
          date: maps[index]['date'].toString(),
          note: maps[index]['note'].toString());
    });
  }

/*   static Future<List<Map<String, Object?>>> mGetCurrentBabyWeightList(
      {required int id}) async {
    final db = await MySqfliteServices.dbInit();

    var result = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyweightsTable} WHERE id=?", [id]);

    return result;
  } */

  static Future<int> mGetMomId() async {
    final db = await MySqfliteServices.dbInit();

    int n = Sqflite.firstIntValue(await db
        .rawQuery('SELECT COUNT (*) FROM ${MyKeywords.momprimaryTable}'))!;
    return n;
  }

  static Future<CurrentBabyInfo> mGetCurrentBabyInfo() async {
    final db = await MySqfliteServices.dbInit();

    // c: read only the last added baby info
    final results = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    CurrentBabyInfo lastBabyInfo = CurrentBabyInfo.fromjson(results.first);

    return lastBabyInfo;
  }

  static Future<String> mGetCurrentBabyGender() async {
    final db = await MySqfliteServices.dbInit();

    var result = await db.rawQuery(
        "SELECT ${MyKeywords.gender} FROM ${MyKeywords.babyinfoTable} ORDER BY ${MyKeywords.baby_id} DESC LIMIT 1");
    // Map<String, dynamic> map = result[0];

    return result[0][MyKeywords.gender].toString();
  }

  // m: Fetch Baby Diary data from Sqflite Db
  static Future<List<ImageDetailsModel>> mFetchBabyDiaryDataFromSqflite(
      {required int babyId, required String email, required int momId}) async {
    final db = await MySqfliteServices.dbInit();

    final maps = await db.rawQuery(
        //e: this statement showed an error as '@gmail.com' exception
        // "SELECT * FROM ${MaaData.TABLE_NAMES[4]} WHERE baby_id = $babyId AND email = $email ORDER BY date");
        //c: it's working
        "SELECT * FROM ${MyKeywords.babydiaryTable} WHERE baby_id = ? AND email = ? AND ${MyKeywords.momId} = ? ORDER BY timestamp",
        [babyId, email, momId]);

    return List.generate(maps.length, (index) {
      return ImageDetailsModel.allDataFromJson(maps[index]);
    });
  }

  static Future<List<BabyGrowthModel>> mFetchBabyGrowthQues(
      {required int timestar}) async {
    final db = await MySqfliteServices.dbInit();
    // var _listBabyGrowthModel = <BabyGrowthModel>[];

    var maps = await db.rawQuery(
        'SELECT * FROM ${MyKeywords.babygrowthQuesTable} WHERE timestar = $timestar');
    // 'SELECT * FROM ${MaaData.TABLE_NAMES[5]} WHERE baby_id = $babyId AND timestar = $timestar');

    return List.generate(maps.length, (index) {
      return BabyGrowthModel.initialQuesData(
        // momId: int.parse(maps[index][MyKeywords.momId].toString()),
        // email: maps[index]['question'].toString(),
        question: maps[index]['question'].toString(),
        quesId: maps[index]['ques_id'].toString(),
        timestar: int.parse(maps[index]['timestar'].toString()),
        ansStatus: 0,
        // ansStatus: int.parse(maps[index]['status'].toString()),
        // babyId: int.parse(maps[index]['baby_id'].toString()),
        /* 
        timestamp: maps[index]['timestamp'].toString(),
        options: maps[index]['options'].toString(), */
      );
    });

    // return _listBabyGrowthModel;
  }

  static Future<List<Map<String, dynamic>>> mFetchForwardTabsData(
      int presentWeeks) async {
    List<Map<String, dynamic>> mapList = [{}];

    final db = await MySqfliteServices.dbInit();
    String currentWeekNo = 'week_';
    int tab_1WeekNo;
    int tab_2WeekNo;
    int tab_3WeekNo;
    int tab_4WeekNo;

    if (presentWeeks <= MaaData.startWeekNo) {
      //case 1
      tab_1WeekNo = presentWeeks;
      tab_2WeekNo = presentWeeks + 1;
      tab_3WeekNo = presentWeeks + 2;
      tab_4WeekNo = presentWeeks + 3;

      /* Logger().d('case 1');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo"); */
    } else if (presentWeeks == MaaData.startWeekNo + 1) {
      //case 2
      tab_1WeekNo = presentWeeks - 1;
      tab_2WeekNo = presentWeeks;
      tab_3WeekNo = presentWeeks + 1;
      tab_4WeekNo = presentWeeks + 2;

      /*  Logger().d('case 2');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo"); */
    } else if (presentWeeks >= MaaData.endWeekNo) {
      //case 3
      tab_1WeekNo = MaaData.endWeekNo - 3;
      tab_2WeekNo = MaaData.endWeekNo - 2;
      tab_3WeekNo = MaaData.endWeekNo - 1;
      tab_4WeekNo = MaaData.endWeekNo;

      /*  Logger().d('case 3');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo"); */
    } else {
      //case 4
      tab_1WeekNo = presentWeeks - 2;
      tab_2WeekNo = presentWeeks - 1;
      tab_3WeekNo = presentWeeks;
      tab_4WeekNo = presentWeeks + 1;

      /* Logger().d('case 4');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo"); */
    }

    mapList = await db.rawQuery("""
          SELECT ${MyKeywords.weekNo}, ${MyKeywords.title}, ${MyKeywords.changesInChild},
           ${MyKeywords.changesInMom}, ${MyKeywords.symptoms}, ${MyKeywords.instructions} FROM ${MyKeywords.weeklychangesTable}
           WHERE ${MyKeywords.weekNo} = '$currentWeekNo$tab_1WeekNo' OR ${MyKeywords.weekNo} = '$currentWeekNo$tab_2WeekNo'
            OR ${MyKeywords.weekNo} = '$currentWeekNo$tab_3WeekNo'  OR ${MyKeywords.weekNo} = '$currentWeekNo$tab_4WeekNo'
            """);

    /* 
       */

    return mapList;
  }

  static Future<List<Map<String, dynamic>>> mFetchBackwardTabsData(
      int presentWeeks) async {
    List<Map<String, dynamic>> mapList = [{}];

    final db = await MySqfliteServices.dbInit();
    String currentWeekNo = 'week_';
    int tab_1WeekNo;
    int tab_2WeekNo;
    int tab_3WeekNo;
    int tab_4WeekNo;

    if (presentWeeks <= MaaData.startWeekNo) {
      //case 1
      tab_1WeekNo = presentWeeks;
      tab_2WeekNo = presentWeeks + 1;
      tab_3WeekNo = presentWeeks + 2;
      tab_4WeekNo = presentWeeks + 3;

      Logger().d('case 1');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else if (presentWeeks == MaaData.startWeekNo + 1) {
      //case 2
      tab_1WeekNo = presentWeeks - 1;
      tab_2WeekNo = presentWeeks;
      tab_3WeekNo = presentWeeks + 1;
      tab_4WeekNo = presentWeeks + 2;

      Logger().d('case 2');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else if (presentWeeks >= MaaData.endWeekNo) {
      //case 3
      tab_1WeekNo = MaaData.endWeekNo - 3;
      tab_2WeekNo = MaaData.endWeekNo - 2;
      tab_3WeekNo = MaaData.endWeekNo - 1;
      tab_4WeekNo = MaaData.endWeekNo;

      Logger().d('case 3');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    } else {
      //case 4
      tab_1WeekNo = presentWeeks - 1;
      tab_2WeekNo = presentWeeks;
      tab_3WeekNo = presentWeeks + 1;
      tab_4WeekNo = presentWeeks + 2;

      Logger().d('case 4');
      Logger().d("$tab_1WeekNo $tab_2WeekNo $tab_3WeekNo $tab_4WeekNo");
    }

    mapList = await db.rawQuery("""
          SELECT ${MyKeywords.weekNo}, ${MyKeywords.title}, ${MyKeywords.changesInChild},
           ${MyKeywords.changesInMom}, ${MyKeywords.symptoms}, ${MyKeywords.instructions} FROM ${MyKeywords.weeklychangesTable}
           WHERE ${MyKeywords.weekNo} = '$currentWeekNo$tab_1WeekNo' OR ${MyKeywords.weekNo} = '$currentWeekNo$tab_2WeekNo'
            OR ${MyKeywords.weekNo} = '$currentWeekNo$tab_3WeekNo'  OR ${MyKeywords.weekNo} = '$currentWeekNo$tab_4WeekNo'
            """);

    /* 
       */

    return mapList;
  }

  static Future<List<NoteModel>> mFetchCurrentNote(
      {required String email,
      required int momId,
      required String currentDate}) async {
    // returns the memos as a list (array)
    final db = await MySqfliteServices.dbInit();
    // query all rows belonging an specific date in a table as an array of maps

    final maps = await db.rawQuery(
        "SELECT date, note FROM ${MyKeywords.momnoteTable} WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND date = ? GROUP BY date",
        [email, momId, currentDate]);
    // await db.rawQuery("SELECT date, note FROM ${MaaData.TABLE_NAMES[0]} WHERE date = '$currentDate'  GROUP BY date ORDER BY date DESC");

    // Logger().d(maps.length);
    return List.generate(maps.length,
        // create a list of notes
        (index) {
      return NoteModel(
          date: maps[index]['date'].toString(),
          note: maps[index]['note'].toString());
    });
  }

  static Future<List<SymptomDetailsModel>> mFetchCurrentSympIntensity(
      {required String email,
      required int momId,
      required String currentDate}) async {
    final db = await MySqfliteServices.dbInit();

    final maps = await db.rawQuery(
        "SELECT date, symptoms FROM ${MyKeywords.momsymptomsTable} WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND date = ? GROUP BY date",
        [email, momId, currentDate]);

    return List.generate(maps.length, (index) {
      return SymptomDetailsModel(
          date: maps[index]['date'].toString(),
          symptoms: maps[index]['symptoms'].toString());
    });
  }

  static Future<List<SymptomDetailsModel>> mFetchAllSympIntensity() async {
    final db = await MySqfliteServices.dbInit();

    final maps = await db.rawQuery(
        "SELECT date, symptoms FROM ${MyKeywords.momsymptomsTable} GROUP BY date");

    return List.generate(maps.length, (index) {
      return SymptomDetailsModel(
          date: maps[index]['date'].toString(),
          symptoms: maps[index]['symptoms'].toString());
    });
  }

  static Future<void> mUpdateBabyCurrentWeightList(
      {required double weight, required Map<String, dynamic> map}) async {
    final db = await MySqfliteServices.dbInit();

    int id = await MySqfliteServices.mGetCurrentBabyId();

    var r = await db.rawUpdate(
        "UPDATE ${MyKeywords.babyweightsAndHeightsTable} SET ${MyKeywords.babyWeight} = ? WHERE ${MyKeywords.baby_id} = ? AND ${MyKeywords.ageNum} = ? AND ${MyKeywords.ageTag} = ?",
        [weight, id, map[MyKeywords.ageNum], map[MyKeywords.ageTag]]);

    Logger().d("Update Result: $r");
  }

  static Future<void> mUpdateMomWeight({required MomWeight momWeight}) async {
    final db = await MySqfliteServices.dbInit();

    await db.rawUpdate(
        "UPDATE ${MyKeywords.momweightTable} SET ${MyKeywords.weight} = ? WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND ${MyKeywords.weekNo} = ?",
        [momWeight.weight, momWeight.email, momWeight.momId, momWeight.weekNo]);
    var i = await db.rawQuery(
        "SELECT ${MyKeywords.weight} FROM ${MyKeywords.momweightTable} WHERE ${MyKeywords.weekNo} = ?",
        [momWeight.weekNo]);

    Logger().d("MomWeight Updated: ${i[0][MyKeywords.weight]}");
  }

  static Future<void> mUpdateBabyCurrentHeightList(
      {required double height, required Map<String, dynamic> map}) async {
    final db = await MySqfliteServices.dbInit();

    int id = await MySqfliteServices.mGetCurrentBabyId();
    /*  Logger().d("id: ${id.runtimeType}");
    Logger().d("weight: ${id.runtimeType}");
    Logger().d("id: ${id.runtimeType}");
    Logger().d("id: ${id.runtimeType}"); */
    /* Logger().d("ID is: $id");
    Logger().d(
        "AgeNum: ${map[MyKeywords.ageNum]} , AgeTag: ${map[MyKeywords.ageTag]}");
    Logger().d("Updated weight: $weight"); */

    var r = await db.rawUpdate(
        "UPDATE ${MyKeywords.babyweightsAndHeightsTable} SET ${MyKeywords.babyHeight} = ? WHERE ${MyKeywords.baby_id} = ? AND ${MyKeywords.ageNum} = ? AND ${MyKeywords.ageTag} = ?",
        [height, id, map[MyKeywords.ageNum], map[MyKeywords.ageTag]]);

    Logger().d("Update Result: $r");
  }

  static Future<void> mUpdateActiveStatusOfBaby(
      String email, int babyId, int momId) async {
    final db = await MySqfliteServices.dbInit();
    // c: activate current baby
    await db.rawUpdate(
        "UPDATE ${MyKeywords.babyinfoTable} SET ${MyKeywords.activeStatus} = ? WHERE ${MyKeywords.email} = ? AND ${MyKeywords.baby_id} = ? AND ${MyKeywords.momId} = ?",
        [1, email, babyId, momId]);
    // c: deactivate rest of all
    await db.rawUpdate(
        "UPDATE ${MyKeywords.babyinfoTable} SET ${MyKeywords.activeStatus} = ? WHERE ${MyKeywords.email} = ? AND ${MyKeywords.baby_id} != ? AND ${MyKeywords.momId} = ?",
        [0, email, babyId, momId]);
  }

  static Future<CurrentBabyInfo?> mFetchActiveBabyInfo(
      {required String email, required int momId}) async {
    final db = await MySqfliteServices.dbInit();
    CurrentBabyInfo? currentBabyInfo;
    var result = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyinfoTable} WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND ${MyKeywords.activeStatus} = ?",
        [email, momId, 1]);
    if (result.isNotEmpty) {
      currentBabyInfo = CurrentBabyInfo.fromjson(result.first);
    }
    /*  List.generate(
        result.length,
        (index) =>
            {babyId = int.parse(result[index][MyKeywords.baby_id].toString())}); */

    return currentBabyInfo;
  }

  static Future<List<CurrentBabyInfo>> mFetchInactiveBabyInfo(
      {required int momId, required String email}) async {
    final db = await MySqfliteServices.dbInit();
    late List<CurrentBabyInfo> listCurrentBabyInfo;

    var r = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babyinfoTable} WHERE ${MyKeywords.momId} = ? AND ${MyKeywords.email} = ? AND ${MyKeywords.activeStatus} = ? ",
        [momId, email, 0]);
    Logger().d(r.length);
    listCurrentBabyInfo =
        List.generate(r.length, (index) => CurrentBabyInfo.fromjson(r[index]));

    return listCurrentBabyInfo;
  }

  static Future<int?> mFetchAnswerStatus(
      {required String email,
      required int momId,
      int? babyId,
      required quesId}) async {
    final db = await MySqfliteServices.dbInit();

    var r = await db.rawQuery(
        "SELECT * FROM ${MyKeywords.babygrowthResponseTable} WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND ${MyKeywords.baby_id} = ? AND ${MyKeywords.quesId} = ?",
        [email, momId, babyId, quesId]);
    if (r.isNotEmpty) {
      return int.parse(r.first[MyKeywords.answerStatus].toString());
    }
  }

  static Future<bool> mCheckExistedQuesDataOfBabyGrowth() async {
    final db = await MySqfliteServices.dbInit();

    var r =
        await db.rawQuery("SELECT * FROM ${MyKeywords.babygrowthQuesTable}");
    return r.isNotEmpty ? true : false;
  }

  static Future<int> mUpdateMomInfo({required MomInfo momInfo}) async {
    final db = await MySqfliteServices.dbInit();

    // var r = await db.update(MyKeywords.momprimaryTable, momInfo.toJson());
    var r = await db.rawUpdate(
        "UPDATE ${MyKeywords.momprimaryTable} SET ${MyKeywords.sessionEnd} = ? WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ?",
        [momInfo.sessionEnd, momInfo.email, momInfo.momId]);

    return r;
  }

  static Future<void> mUpdateNote(
      {required MomInfo momInfo, required NoteModel noteModel}) async {
    final db = await MySqfliteServices.dbInit();

    var response = await db.rawUpdate(
        "UPDATE ${MyKeywords.momnoteTable} SET note = ? WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND date = ?",
        [noteModel.note, momInfo.email, momInfo.momId, noteModel.date]);
    if (response > 0) {
      Logger().d("Updated");
    }
  }

  static Future<void> updateSympIntensity(
      {required MomInfo momInfo,
      required SymptomDetailsModel sympIntenSityModel}) async {
    final db = await MySqfliteServices.dbInit();

    var response = await db.rawUpdate(
        "UPDATE ${MyKeywords.momsymptomsTable} SET symptoms = ? WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? AND date = ?",
        [
          sympIntenSityModel.symptoms,
          momInfo.email,
          momInfo.momId,
          sympIntenSityModel.date
        ]);
    if (response > 0) {
      Logger().d("Updated");
    }
  }

  static Future<List<String>> mFetchMomWeights(
      {required MomInfo momInfo}) async {
    final db = await MySqfliteServices.dbInit();

    List<String> list = [];

    var res = await db.rawQuery(
        "SELECT ${MyKeywords.weight} FROM ${MyKeywords.momweightTable} WHERE ${MyKeywords.email} = ? AND ${MyKeywords.momId} = ? ",
        [momInfo.email, momInfo.momId]);
    Logger().d("momWeights: ${res.first[MyKeywords.weight]}, Length: ${res.length}");
    List.generate(res.length,
        (index) => list.add(res.first[MyKeywords.weight].toString()));
    
    return list;
  }
}
 */