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
    static private var storedRate: Float = 110
    
// MARK:

    // レートを返す
    public func rate() -> Float {
        
        return Rate.storedRate
    }
    
    // レードを設定する
    public func setRate(_ rate: Float) {
        
        Rate.storedRate = rate
    }
    
    // 非同期でweb APIを呼び、コールバックを起動する
    public func getRateFromWeb(callback: @escaping (Bool) -> Void) {
        
        // ステータスバーのインジケータ開始
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        // クジラWeb API ( http://api.aoikujira.com )
        let url     = NSURL(string: "http://api.aoikujira.com/kawase/json/usd")!
        let request = NSMutableURLRequest(url: url as URL)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            // 通信終了後に呼ばれる
            
            sleep(1)    // ダミーの時間稼ぎです
            // ステータスバーのインジケータ終了
            UIApplication.shared.isNetworkActivityIndicatorVisible = false;
            
            if let data = data {
                // 通信成功
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
                    print("Data error")
                    callback(false)
                }
            } else {
                // 通信エラー
                print("response:\(response) error:\(error)")
                callback(false)
            }
        }
        task.resume()
    }
}
