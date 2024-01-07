//
//  ContentView.swift
//  Othello
//
//  Created by Hiroki on 2024/01/07.
//

import SwiftUI

struct ContentView: View {
  let rows = 8
  let columns = 8
  let initialBoard: [[Int]] = [
    [0, 0, 0, 0, 0, 0, 0, 0], // 1行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 2行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 3行目
    [0, 0, 0, 1, 2, 0, 0, 0], // 4行目
    [0, 0, 0, 2, 1, 0, 0, 0], // 5行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 6行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 7行目
    [0, 0, 0, 0, 0, 0, 0, 0]  // 8行目
  ]
  let finalBoard: [[Int]] = [
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1],
    [1, 2, 1, 0, 0, 0, 1, 2], // この行に3つの空きマスを作成
    [2, 1, 2, 1, 2, 1, 2, 1]
  ]
  let finalBoard5: [[Int]] = [
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 0, 0, 0], // この行に3つの空きマスを配置
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 0, 1, 2, 1], // この行に1つの空きマスを配置
    [1, 2, 1, 0, 1, 2, 1, 2], // この行に1つの空きマスを配置
    [2, 1, 2, 1, 2, 1, 2, 1]
  ]

  let PassBoard: [[Int]] = [
    [2, 2, 2, 2, 2, 2, 2, 2],
    [2, 2, 2, 2, 2, 2, 2, 2],
    [2, 2, 1, 2, 2, 2, 2, 2],
    [2, 1, 1, 2, 2, 1, 2, 2],
    [2, 1, 1, 2, 1, 0, 0, 2],
    [2, 2, 1, 0, 1, 0, 0, 0],
    [2, 2, 2, 0, 0, 0, 0, 0],
    [2, 2, 2, 2, 0, 0, 0, 0]
  ]

  let debugBoard: [[Int]] = [
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 2, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1],
    [1, 2, 1, 2, 1, 0, 1, 2], // ここに黒が置くと...
    [2, 1, 2, 1, 2, 2, 2, 1], // 白も黒も置けなくなる
    [1, 2, 1, 2, 1, 1, 1, 2],
    [2, 1, 2, 1, 2, 1, 2, 1]
  ]
  let blackForcesWhitePassBoard: [[Int]] = [
    [0, 0, 0, 0, 0, 0, 0, 0], // 1行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 2行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 3行目
    [0, 0, 0, 1, 2, 0, 0, 0], // 4行目
    [0, 0, 0, 1, 1, 0, 0, 0], // 5行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 6行目
    [0, 0, 0, 0, 0, 0, 0, 0], // 7行目
    [0, 0, 0, 0, 0, 0, 0, 0]  // 8行目
  ]




  @State private var board: [[Int]]
  @State private var turn: Int = 1
  @State private var passCount: Int = 0
  @State private var showingAlert:Bool = false
  @State private var alertTitle = ""
  @State private var alertMessage = ""
  @State private var possibleMoves: [(Int, Int)] = []
  @State private var blackCount: Int = 0
  @State private var whiteCount: Int = 0
  @State private var passMessage: String = ""

  init() {
    //    _board = State(initialValue: blackForcesWhitePassBoard) // 初期状態で初期化
    _board = State(initialValue: initialBoard)
  }

  var body: some View {
    Text("OthelloGame")
      .font(.largeTitle)
    HStack {
      Text("黒: \(blackCount)")
      Text("白: \(whiteCount)")
    }
    .font(.headline)

    Text(turn == 1 ? "黒のターン" : "白のターン")
      .font(.headline)
      .padding()
    VStack(spacing:1){
      ForEach(0..<rows, id: \.self) { row in
        HStack (spacing:1){
          ForEach(0..<columns, id: \.self) { column in
            Button(action: {
              onClick(x: row, y: column)
            }) {
              pieceView(at: row, y: column)
                .frame(width: 45, height: 45)
                .background(Color.green)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0.5)
            }
          }
        }
        .background(Color.black) // HStackの背景を黒色に設定
      }
      .alert(isPresented: $showingAlert) {
        Alert(
          title: Text(alertTitle),
          message: Text(alertMessage),
          dismissButton: .default(Text("OK"), action: {
            resetGame()
          })
        )
      }

    }
    .background(Color.black)


    .onAppear {
      PiceCounts()
      checkNextTurnMoves()
    }
    Text("\(passMessage)").font(.headline)
  }



  //   マスがクリックされたときの処理
  func onClick(x: Int, y: Int) {
    print("マス (\(x), \(y))がクリックされました")
    //置けたますの場合に先に進む
    if board[x][y] == 0 && isMoveValid(x: x, y: y){
      updateBoard(x: x, y: y)
    }

  }

  // 指定されたマスに駒を置くことが有効かどうかを判断
  func isMoveValid(x: Int, y: Int) -> Bool {
    let validDirections = checkAllDirections(x: x, y: y)
    print("置けるので進む",!validDirections.isEmpty)
    print("コマを置いた場所に反転させることができるコマのリスト",validDirections)
    if(validDirections.isEmpty){
      print("そのマスにはおけない")
      return false
    }
    return !validDirections.isEmpty
  }

  // すべての方向をチェックして、反転可能な駒のリストを返す関数
  func checkAllDirections(x: Int, y: Int) -> [(Int, Int)] {
    var validDirections: [(Int, Int)] = []
    for dx in -1...1 {
      for dy in -1...1 {
        if dx == 0 && dy == 0 { continue }
        let pieces = checkDirection(x: x, y: y, dx: dx, dy: dy)
        if !pieces.isEmpty {
          validDirections.append(contentsOf: pieces)
        }
      }
    }
    return validDirections
  }

  func updateBoard(x: Int, y: Int) {
    var validDirections: [(Int, Int)] = []

    // 盤面の範囲内で隣接するマスを確認
    for dx in -1...1 {
      for dy in -1...1 {
        if dx == 0 && dy == 0 { continue } // 同じマスはスキップ

        let pieces = checkDirection(x: x, y: y, dx: dx, dy: dy)
        if !pieces.isEmpty {
          validDirections.append(contentsOf: pieces)
        }
      }
    }
    print("check",validDirections)

    if !validDirections.isEmpty {
      board[x][y] = turn
      // 有効な方向の駒を反転
      for (flipX, flipY) in validDirections {
        board[flipX][flipY] = turn
      }
      turn = 3 - turn
      PiceCounts()
      print("次のターン", turn)
      if isBoardFull(){

        let winner = blackCount > whiteCount ? "黒の勝ち" : (blackCount < whiteCount ? "白の勝ち" : "引き分け")
        alertTitle = "ゲーム終了"
        alertMessage = "黒: \(blackCount), 白: \(whiteCount), 勝者: \(winner)"

        showingAlert = true
        //        resetGame()
      }else{
        checkNextTurnMoves()

      }
    }
  }

  func isBoardFull() -> Bool {
    for row in board {
      for cell in row {
        if cell == 0 { // 空のマスがある場合
          return false
        }
      }
    }
    return true // 全てのマスが埋まっている場合
  }


  func checkDirection(x: Int, y: Int, dx: Int, dy: Int) -> [(Int, Int)] {
    var newX = x + dx
    var newY = y + dy
    //反転可能なマスを記録
    var piecesToFlip: [(Int, Int)] = []

    while newX >= 0 && newX < rows && newY >= 0 && newY < columns {
      if board[newX][newY] == 3 - turn {
        piecesToFlip.append((newX, newY))
        newX += dx
        newY += dy
      } else if board[newX][newY] == turn {
        return piecesToFlip
      } else {
        break
      }
    }

    return []
  }

  func checkNextTurnMoves() {
    possibleMoves = []
    for row in 0..<rows {
      for col in 0..<columns {
        if board[row][col] == 0 && isMoveValid(x: row, y: col) {
          possibleMoves.append((row, col))
        }
      }
    }
    print("次のターンの可能な手: \(possibleMoves)")
    if possibleMoves.isEmpty{
      passCount+=1
      passMessage = turn == 1 ? "黒がパスしました" : "白がパスしました"

      if(passCount >= 2  || blackCount == 0 || whiteCount == 0){
        let winner = blackCount > whiteCount ? "黒の勝ち" : (blackCount < whiteCount ? "白の勝ち" : "引き分け")
        alertTitle = "ゲーム終了"
        alertMessage = "黒: \(blackCount), 白: \(whiteCount), 勝者: \(winner)"

        showingAlert = true
        //        resetGame()
      }
    }else{
      passCount = 0
      passMessage = ""

    }
  }

  func PiceCounts(){
    var newBlackCount = 0
    var newWhiteCount = 0

    for row in board {
      for cell in row {
        if cell == 1 {
          newBlackCount += 1
        } else if cell == 2 {
          newWhiteCount += 1
        }
      }
    }

    blackCount = newBlackCount
    whiteCount = newWhiteCount

  }
  func resetGame() {
    // 盤面を初期状態にリセット
    board = initialBoard
    // ターンを初期プレイヤーに設定
    turn = 1
    // パスカウントをリセット
    passCount = 0
    // 初期の駒の配置
    board[3][3] = 1 // 黒
    board[4][4] = 1 // 黒
    board[3][4] = 2 // 白
    board[4][3] = 2 // 白
    PiceCounts()
    checkNextTurnMoves()
  }
  // 特定の位置の駒のビューを生成
  func pieceView(at x: Int, y: Int) -> some View {
    let piece = board[x][y]
    let isPossibleMove = possibleMoves.contains(where: { $0 == (x, y) })
    return Group{
      if piece != 0 {
        Circle()
          .foregroundColor(pieceColor(piece))
      }else if isPossibleMove {
        Rectangle()
          .foregroundColor(Color.yellow.opacity(0.7)) // ハイライト色

      } else{
        Rectangle()
          .foregroundColor(pieceColor(piece))
      }
    }
  }

  // 駒の状態に応じた色を返す
  func pieceColor(_ piece: Int) -> Color {
    switch piece {
    case 0:
      return Color.green.opacity(0.5) // 透明な緑色
    case 1:
      return .black
    case 2:
      return .white
    default:
      return .clear
    }
  }
}

#Preview {
  ContentView()
}
