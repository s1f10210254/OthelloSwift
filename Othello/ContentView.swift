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
  @State private var board: [[Int]] = Array(repeating: Array(repeating: 0, count: 8), count: 8)
  @State private var turn: Int = 1

  var body: some View {
    VStack{
      ForEach(0..<rows, id: \.self) { row in
        HStack {
          ForEach(0..<columns, id: \.self) { column in
            Button(action: {
              onClick(x: row, y: column)
            }) {
              pieceView(at: row, y: column)
                .frame(width: 40, height: 40)
                .background(Color.green)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0.2)
            }
          }
        }
      }
    }
    .background(Color.green) // 背景色を緑に設定
    .onAppear {
      // 初期配置の設定
      board[3][3] = 1 // 黒
      board[4][4] = 1 // 黒
      board[3][4] = 2 // 白
      board[4][3] = 2 // 白
    }
  }


  // マスがクリックされたときの処理
  func onClick(x: Int, y: Int) {
    print("マス (\(x), \(y))がクリックされました")
    if board[x][y] == 0{
      updateBoard(x: x, y: y)
    }

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

      if !validDirections.isEmpty {
          board[x][y] = turn
          // 有効な方向の駒を反転
          for (flipX, flipY) in validDirections {
              board[flipX][flipY] = turn
          }
          turn = 3 - turn
          print("次のターン", turn)
      }
  }

  func checkDirection(x: Int, y: Int, dx: Int, dy: Int) -> [(Int, Int)] {
      var newX = x + dx
      var newY = y + dy
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
  // 特定の位置の駒のビューを生成
  func pieceView(at x: Int, y: Int) -> some View {
    let piece = board[x][y]
    return Group{
      if piece != 0 {
        Circle()
          .foregroundColor(pieceColor(piece))
      }else{
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
