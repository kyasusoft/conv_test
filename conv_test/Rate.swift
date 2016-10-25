//
//  Rate.swift
//  conv_test
//
//  Created by kyasu on 2016/10/13.
//  Copyright © 2016年 kyasu. All rights reserved.
//

import UIKit

class Rate: NSObject {

    // タイププロパティ(同じ型の値の間で共有される)
    static var storedRate: Float = 110
    
// MARK:

    // 非同期でweb APIを呼び、コールバックを起動する
    public func getRateFromWeb(callback: @escaping (Bool) -> Void) {
        
        // ステータスバーのインジケータ開始
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        // クジラWeb API ( http://api.aoikujira.com )
        let url     = URL(string: "http://api.aoikujira.com/kawase/jsonp/usd")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 通信終了後に呼ばれる
            sleep(1)    // インジケータを見せるためのダミーの時間稼ぎです
            // ステータスバーのインジケータ終了
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            
            if error == nil {
                // 通信成功
                if let data = data {
                    do {
                        // JSONパース(protocol ErrorType に適合する型なのでdo catchを使用する)
                        let dict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                        // USD -> JPN のレートを取得
                        let jpy = dict["JPY"] as! String
                        // Foatに変換してタイププロパティに保存
                        Rate.storedRate = Float(jpy)!
                        // コールバック呼び出し
                        callback(true)
                        
                    } catch  {
                        // パースエラー
                        print("Data error data:\(data)\n")
                        callback(false)
                    }
                } else {
                    // データなし
                    print("No data")
                    callback(false)
                }
            } else {
                // 通信失敗
                print("response:\(response) error:\(error)")
                callback(false)
            }
        }.resume()
    }
}
