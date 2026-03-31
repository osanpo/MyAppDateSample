//
//  ContentView.swift
//  MyAppDateSample
//
//  Created by Hideo Mizuno on 2026/03/28.
//

import SwiftUI
internal import Combine

struct ContentView: View {
    // MyAppDateクラスのインスタンスを作成
    // Date()を呼び出すかわりにMyAppDateクラスのAppDate()を呼び出すようにする準備
    //
    @StateObject private var myAppDate = MyAppDate()
    
    // 現在の時間
    @State private var currentDateStr: String = ""
    // MyAppDateクラスの時刻
    @State private var fakeDate: Date? = nil
    @State private var fakeDateStr: String = ""
    
    var body: some View {
        VStack {
            Text("現在の日付と時刻")
                .font(.headline)
                .padding(.bottom, 4)
            Text(currentDateStr)
                .font(.body)
                .padding(.bottom, 32)
            if myAppDate.isFakeDate {
                Text("MyAppDateクラスで変更した日付と時刻")
                    .font(.headline)
                    .padding(.bottom, 4)
                Text(fakeDateStr)
                    .font(.body)
            }
        }
        .padding()
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                // Date関数で実際の日時を取得
                let currentDate = Date()
                currentDateStr = currentDate.formatted(date: .complete, time: .complete)
                
                // テスト用にずらしたの日時を取得
                fakeDate = myAppDate.AppDate()
                fakeDateStr = fakeDate?.formatted(date: .complete, time: .complete) ?? ""
            }
        }
    }
}


#Preview {
    ContentView()
}
