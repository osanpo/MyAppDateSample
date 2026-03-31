//
// テスト用に日付を強制変更するクラス
//
//  MyAppDate.swift
//
//  Created by Hideo Mizuno on 2026/03/28.
//

import Foundation
internal import Combine

class MyAppDate: ObservableObject {
    #if DEBUG
        private let fakeDateStr: String? = "20260401"     // 強制変更する日付(yyyyMMdd形式)  ""なら変更しない
        private let fakeTimeStr: String? = "110000"     // 強制変更する時刻(hhmms形式) 24時間制　"" なら変更しない
    #else
        // 本番用なので書き換え禁止
        private let fakeDateStr: String? = ""
        private let fakeTimeStr: String? = ""
    #endif
    @Published var isFakeDate: Bool = false
    private var timeDifference: TimeInterval = 0.0
    
    // コンストラクタ
    init() {
        #if DEBUG
        #else
            isFakeDate = false
            return
        #endif
        if fakeDateStr == "" && fakeTimeStr == "" {
            isFakeDate = false
            return
        }

        // 現在の時刻の特定
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmmss"
        // 端末設定のLocal Timeで文字列化
        let localDateTimeStr = formatter.string(from: currentDate)
        let localDateStr = String(localDateTimeStr.prefix(8))
        let localTimeStr = String(localDateTimeStr.suffix(6))

        // 強制変更する日付と時刻の設定
        var fakeDateTimeStr = ""
        var fakeYear : Int = 0
        var fakeMonth : Int = 0
        var fakeDay : Int = 0
        var fakeHour: Int = 0
        var fakeMinute: Int = 0
        var fakeSecond: Int = 0
        var fakeDate: Date? = nil
        
        // 日付の設定
        if fakeDateStr != "" {
            fakeYear = Int(fakeDateStr!.prefix(4)) ?? 0
            fakeMonth = Int(fakeDateStr!.dropFirst(4).prefix(2)) ?? 0
            fakeDay = Int(fakeDateStr!.dropFirst(6).prefix(2)) ?? 0
        } else {
            fakeYear = Int(localDateStr.prefix(4)) ?? 0
            fakeMonth = Int(localDateStr.dropFirst(4).prefix(2)) ?? 0
            fakeDay = Int(localDateStr.dropFirst(6).prefix(2)) ?? 0
        }
        // 時刻の設定
        if fakeTimeStr != "" {
            fakeHour = Int(fakeTimeStr!.prefix(2)) ?? 0
            fakeMinute = Int(fakeTimeStr!.dropFirst(2).prefix(2)) ?? 0
            fakeSecond = Int(fakeTimeStr!.dropFirst(4).prefix(2)) ?? 0
        } else {
            fakeHour = Int(localTimeStr.prefix(2)) ?? 0
            fakeMinute = Int(localTimeStr.dropFirst(2).prefix(2)) ?? 0
            fakeSecond = Int(localTimeStr.dropFirst(4).prefix(2)) ?? 0
        }
        // 強制変更する日付と時刻の設定
        fakeDateTimeStr = String(format: "%04d%02d%02d %02d%02d%02d", fakeYear, fakeMonth, fakeDay, fakeHour, fakeMinute, fakeSecond)
        fakeDate = formatter.date(from: fakeDateTimeStr)
        
        // fakeDateとcurrentDateの時差を求める
        timeDifference = fakeDate?.timeIntervalSince(currentDate) ?? 0.0
        isFakeDate = true
    }
    
    public func AppDate() -> Date {
        #if DEBUG
            if isFakeDate {
                return Date().addingTimeInterval(timeDifference)
            } else {
                return Date()
            }
        #else
            return Date()
        #endif

    }
        
    
}
