import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ochinchin',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const JankenPage(),
    );
  }
}

//ページの中を変化させたい、動きをつけたい場合はStatefulWidget
//StatefulWidget を作るには main.dart 上で stf と入力
class JankenPage extends StatefulWidget {
  const JankenPage({super.key});

  @override
  State<JankenPage> createState() => _JankenPageState();
}


class _JankenPageState extends State<JankenPage> {
  String myHand = '✊'; //StatefulWidgetは中に変数や関数を作れる

  String computerHand = '✊'; //コンピュータの手を設定

  // 勝敗を表示させたいので、勝敗を保持する変数を定義する
  String result = '引き分け';

  //敵の体力
  int enemyLp = 1000;

  //自分の体力
  int myLp = 100;

  //ターン数
  int turn = 0;

  //グー、チョキ、パーで重複する処理を関数にまとめる
  void selectHand(String selectedHand) {
    myHand = selectedHand; // myHand に 引数として受けとった selectedHand を代入
    print(myHand); // コンソールに myHand の中身を表示する
    generateComputerHand(); //敵の手を生成
    judge(); // 勝敗を判定する。
    damageCreater(); // 敵のダメージを生成
    myDamageCreater(); // 自分のダメージを生成
    elp(); // 敵のLPを計算
    lp(); // 自分のLPを計算
    elpp(); // 敵のLPがマイナスにならないようにする
    lpp(); // 自分のLPがマイナスにならないようにする
    turn++; //ターン経過
    setState(() {}); // この命令を実行すると画面が更新される
  }

  //コンピュータの手をランダムにする
  void generateComputerHand() {
       // nextInt() の括弧の中に与えた数字より1小さい値を最高値としたランダムな数を生成する。
       // 3 であれば 0, 1, 2 がランダムで生成される。
    computerHand = randomNumberToHand(Random().nextInt(3));
  }

  //ランダムな数字を手に変える
  String randomNumberToHand(int randomNumber) {
    // 数字を✊,✌,🖐に変換する処理
    if (randomNumber == 0) {
      return '✊'; // ✊を返す。
    } else if (randomNumber == 1) {
      return '✌'; // ✊を返す。
    } else if (randomNumber == 2) {
      return '🖐'; // ✊を返す。
    } else {
      return '✊';
    }
  }

  // void generateComputerHand() {
  //   // randomNumberに一時的に値を格納します。
  //   final randomNumber = Random().nextInt(3);
  //   // 生成されたランダムな数字を ✊, ✌, 🖐 に変換して、コンピューターの手に代入します。
  //   computerHand = randomNumberToHand(randomNumber);
  // }

  // String randomNumberToHand(int randomNumber) {
  //   // () のなかには条件となる値を書きます。
  //   switch (randomNumber) {
  //     case 0: // 入ってきた値がもし 0 だったら。
  //       return '✊'; // ✊を返す。
  //     case 1: // 入ってきた値がもし 1 だったら。
  //       return '✌️'; // ✌️を返す。
  //     case 2: // 入ってきた値がもし 2 だったら。
  //       return '🖐'; // 🖐を返す。
  //     default: // 上で書いてきた以外の値が入ってきたら。
  //       return '✊'; // ✊を返す。（0, 1, 2 以外が入ることはないが念のため）
  //   }
  // }

  // 勝敗を判定する関数
  void judge() {
    // 引き分けの場合
    if (myHand == computerHand) {
      result = '引き分け';
      // 勝ちの場合
    } else if (myHand == '✊' && computerHand == '✌'  ||
        myHand == '✌' && computerHand == '🖐'  ||
        myHand == '🖐' && computerHand == '✊') {
      result = '勝ち';
      // 負けの場合
    } else {
      result = '負け';
    }
  }

  // //相手に与えるダメージを生成する
  // int damageCreater() {
  //
  //   if (myHand == '✊' && result == '勝ち') {
  //     return 150 + Random().nextInt(50); //
  //   } else if (myHand == '✌' && result == '勝ち') {
  //     return 100 + Random().nextInt(2000); //
  //   } else if (myHand == '🖐' && result == '勝ち') {
  //     return 50 + Random().nextInt(100) + turn * turn; //
  //   } else {
  //     return 0;
  //   }
  // }

  //相手に与えるダメージを生成する
  int? damageCreater() {

    if (myHand == '✊' && result == '勝ち') {
      enemyDamage = 50 + Random().nextInt(20); //
    } else if (myHand == '✌' && result == '勝ち') {
      enemyDamage = 100 + Random().nextInt(2000); //
    } else if (myHand == '🖐' && result == '勝ち') {
      enemyDamage = -5000 -Random().nextInt(95000) + turn * turn * turn * turn; //
    } else {
      enemyDamage = 0;
    }
  }

  // //自分が受けるダメージを生成する
  // int myDamageCreater() {
  //
  //   if (myHand == '✊' && result == '負け') {
  //     return 15 + Random().nextInt(5); //
  //   } else if (myHand == '✌' && result == '負け') {
  //     return 10 + Random().nextInt(65); //
  //   } else if (myHand == '🖐' && result == '負け') {
  //     return 0 + Random().nextInt(5); //
  //   } else {
  //     return 0;
  //   }
  // }

  //自分が受けるダメージを生成する
 int? myDamageCreater() {

    if (myHand == '✊' && result == '負け') {
      myDamage = 20 + Random().nextInt(5); //
    } else if (myHand == '✌' && result == '負け') {
      myDamage = 10 + Random().nextInt(170); //
    } else if (myHand == '🖐' && result == '負け') {
      myDamage = 0 + Random().nextInt(5); //
    } else {
      myDamage = 0;
    }
  }

  // //敵の残りLPを計算する
  // int? elp() {
  //   if (enemyLp > 0) {
  //     enemyLp = enemyLp - damageCreater();
  //   }
  //   else{
  //     enemyLp = 0;
  //   }
  // }

  //敵の残りLPを計算する
  int? elp() {
    if (enemyLp > 0) {
      enemyLp = enemyLp - enemyDamage;
    }
    else{
      enemyLp = 0;
    }
  }

  // //自分の残りLPを計算する
  // int? lp() {
  //   if (myLp > 0) {
  //     myLp = myLp - myDamageCreater();
  //   }
  //   else{
  //       myLp = 0;
  //   }
  // }

  //自分の残りLPを計算する
  int? lp() {
    if (myLp > 0) {
      myLp = myLp - myDamage;
    }
    else{
      myLp = 0;
    }
  }

  //敵のLPを正にする
  int? elpp() {
    if (enemyLp > 0) {
      enemyLp = enemyLp;
    }
    else{
      enemyLp = 0;
    }
  }

  //自分のLPを正にする
  int? lpp() {
    if (myLp > 0) {
      myLp = myLp;
    }
    else{
      myLp = 0;
    }
  }

  //ダメージを定義
  int myDamage = 0;
  int enemyDamage = 0;

  //勝敗判定
  String? shouhai() {
    if (enemyLp < 1 && myLp > 0) {
      return ("勝利");
    }
    else if (myLp < 1){
      return ("敗北");
    }
    else{
      return ("戦闘中");
    }
  }

  //対戦数
  int battleCount = 0;

  //勝利数
  int winCount = 0;

  //勝ち数カウント
win() {
    if (enemyLp < 1 && myLp > 0) {
      winCount ++;
    }
    else{
    ;}
}

//勝率カウント
  winRate() {
    if (battleCount > 0) {
      return (winCount * 100 / battleCount).floor();
    }
    else{
      return (0);
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('理不尽じゃんけん'),
      ),
      //グー、チョキ、パーボタンを作る

      body: Column(
          children: <Widget>[

            SizedBox(height: 8),

            Row(
              children: [

                //ターン数表示
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    " ターン数 : ${turn}  ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                //勝敗表示
                Align(
              alignment: Alignment.topLeft,
                child: Text(
                  "${shouhai()}",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
            ),

                //勝利数表示
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    " 勝利数${winCount}回 ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                //対戦数表示
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "対戦数${battleCount}回 ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

                //勝率表示
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "勝率${winRate()}% ",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

            // nextボタン
                Align(
                  alignment: Alignment.topRight,
                child:
            ElevatedButton(
              onPressed: () {
                win();
                enemyLp = 1000;
                myLp = 100;
                myDamage = 0;
                enemyDamage = 0;
                turn = 0;
                battleCount ++;
                setState(() {});
              },
              child: Text(
                'next',
                style: TextStyle(
                  fontSize: 16, // 文字サイズを大きくしたい
                ),
              ),
              ),
            ),
            ],
            ),

          Row(
            children: [

              SizedBox(width: 8),

            // 敵アイコン
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundImage:
                NetworkImage('https://1.bp.blogspot.com/-4-ktVUOZ0Mo/VbnQ8-QED8I/AAAAAAAAwKA/mj58a2ZqwAU/s800/unchi_character.png'),
               ),

              ),

              SizedBox(width: 8),

            // 動かないLPゲージ(敵）
            // Align(
            //  alignment: Alignment.topLeft,
            //  child:CustomPaint(
            //  painter: _SamplePainter(),
            //  ),
            //  ),

            // 動くLPゲージ（敵）
            AnimatedContainer(
                constraints: BoxConstraints(maxWidth: 400, maxHeight: 30),
              // 1.アニメーションの動作時間
              duration: Duration(seconds: 1),
              // 2.変化させたいプロパティ
              width: enemyLp / 1000 * 400,
              height: 30,
              color: Color.fromARGB(255, 76, 245, 100),
            ),
            ],
          ),

      Center(
          child: DefaultTextStyle.merge(
          style: const TextStyle(color: Colors.black,fontSize: 60),
          child: Column( // 縦に並べたい Columnは要素が複数なのでchildren: [],
          mainAxisAlignment: MainAxisAlignment.center,// 中央揃えにしたい
          children: [
            // 勝敗を表示
            // Text(
            //   result,
            //   style: TextStyle(
            //     fontSize: 48,
            //   ),
            // ),
            // // 余白を追加
            // SizedBox(height: 48),


            //敵の体力を表示
            Text(
              "LP ${enemyLp}/1000",
              style: TextStyle(
                fontSize: 32,

              ),
            ),
            // 余白を追加
            SizedBox(height: 14),

            // 敵のダメージを表示
            Text(
              "-${enemyDamage}",
              style: TextStyle(
                fontSize: 40,
                color: Colors.red
              ),
            ),

            //コンピューターの手を表示
            Text(
              computerHand,
              style: TextStyle(
                // fontSize: 32,
              ),
            ),
            // 余白を追加
            SizedBox(height: 48),

            // 自分の手を表示
            Text(
              myHand,
              style: TextStyle(
                // fontSize: 32, // 文字サイズを大きくしたい
              ),
            ),
            SizedBox(height: 20), // 隙間をあけたい

            // 余白を追加
            SizedBox(height: 8),

            // 自分のダメージを表示
            Text(
              "-${myDamage}",
              style: TextStyle(
                fontSize: 40,
                color: Colors.red,
              ),
            ),

            Row(//ボタンを横に並べる
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,// 余白を均等に並べる
                children: [
                  // SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () { //ボタンを押したときの処理内容
                    // print('✊'); //printはコンソールに表示させる
                    // myHand = '✊'; // myHand に ✊ を代入する
                    // print (myHand); // コンソールに myHand の中身を表示する
                    // setState(() {}); // この命令を実行すると画面が更新される
                    selectHand('✊'); // 作った関数を呼び出す
                  }, // onPressed
                  child: Text(
                      '✊',
                    style: TextStyle(
                      fontSize: 60, // 文字サイズを大きくしたい
                    ),
                  ), //ボタンに表示するテキスト
                ),
                ElevatedButton(
                  onPressed: () {
                    // myHand = '✌'; // myHandに代入
                    // print (myHand); // コンソールに myHand の中身を表示する
                    // setState(() {}); // この命令を実行すると画面が更新される
                    selectHand('✌'); // 作った関数を呼び出す
                  },
                  child: Text('✌',
                    style: TextStyle(
                      fontSize: 60, // 文字サイズを大きくしたい
                    ),),
                ),
                ElevatedButton(
                  onPressed: () {
                    // myHand = '🖐'; // myHandに代入
                    // print (myHand); // コンソールに myHand の中身を表示する
                    // setState(() {}); // この命令を実行すると画面が更新される
                    selectHand('🖐'); // 作った関数を呼び出す
                  },
                  child: Text('🖐',
                    style: TextStyle(
                      fontSize: 60, // 文字サイズを大きくしたい
                    ),
                  ),
                  ),
              ],// Row
                ),

            SizedBox(height: 8),

            Row(
              children: [

                SizedBox(width: 8),

                //自分のアイコン
            Align(
              alignment: Alignment.topLeft,
              child: CircleAvatar(
                backgroundImage:
                NetworkImage('https://1.bp.blogspot.com/-2cvgnCbNoFQ/VhHgUhjliuI/AAAAAAAAy6Y/I1xeWeydsw0/s800/toilet_kirei.png'),
              ),
            ),

                SizedBox(width: 8),

            // 動かないLPゲージ（自分）
            // Align(
            //   alignment: Alignment.topLeft,
            //   child:CustomPaint(
            //     painter: _SamplePainter2(),
            //   ),
            // ),

                // 動くLPゲージ（自分）
                AnimatedContainer(
                  // 1.アニメーションの動作時間
                  duration: Duration(seconds: 1),
                  // 2.変化させたいプロパティ
                  width: myLp / 100 * 400,
                  height: 30,
                  color: Color.fromARGB(255, 76, 245, 100),
                ),


            ],
            ),

            //自分の体力を表示
            Text(
              "LP ${myLp}/100",
              style: TextStyle(
                fontSize: 28,
              ),
            ),
            //余白を追加
            SizedBox(height: 8),

           // リセットボタン
            ElevatedButton(
              onPressed: () {
                enemyLp = 1000;
                myLp = 100;
                myDamage = 0;
                enemyDamage = 0;
                turn = 0;
                battleCount = 0;
                winCount = 0;
                setState(() {});
              },
              child: Text('reset',
                style: TextStyle(
                  fontSize: 16, // 文字サイズを大きくしたい
                ),
              ),
            ),

          ], // Column
      ),
    ),
      ),
      ],
      ),
    );
  }
}

// // 敵のLPゲージ
// class _SamplePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Color.fromARGB(255, 76, 245, 100);
//     canvas.drawRect(Rect.fromLTWH(20, 10, 450, 30), paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
// // 自分のLPゲージ
// class _SamplePainter2 extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Color.fromARGB(255, 76, 245, 100);
//     canvas.drawRect(Rect.fromLTWH(20, 10, 400, 30), paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }



