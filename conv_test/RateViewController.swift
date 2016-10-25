//
//  RateViewController.swift
//  conv_test
//
//  Created by kyasu on 2016/10/13.
//  Copyright © 2016年 kyasu. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {

    @IBOutlet weak var rateTextFiled: UITextField!

// MARK:

    // viewがロードされた後に呼ばれる
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // レートクラスからレートを取得する
        let rate = Rate.storedRate

        // FloatをStringに変換してテキストフィールドにセットする
        rateTextFiled.text = String(rate)
    }

    // メモリーワーニングが発生すると呼ばれる
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK:

    // 本画面を終了
    @IBAction func done(_ sender: AnyObject) {
        
        // キーボードをしまう
        rateTextFiled.resignFirstResponder()
        
        // テキストフィールドから値を取得しセットする
        let rate = rateTextFiled!.text
        Rate.storedRate = Float(rate!)!
        
        print(rate)
        // 画面を消す
        self.dismiss(animated: true, completion: nil)
    }

    // 現在のレートを取得
    @IBAction func update(_ sender: AnyObject) {
        
        // キーボードをしまう
        rateTextFiled.resignFirstResponder()

        // 非同期でWeb APIを発行し、コールバックでテキストフィールドにセットする
        Rate().getRateFromWeb(callback: { result in
            // コールバック
            // UI部品に設定するのでメインキューで実行する
            DispatchQueue.main.async {
                let rate = Rate.storedRate
                self.rateTextFiled.text = String(rate)
            }
            
            if result == false {
                let alert = UIAlertController(title: "エラー", message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
