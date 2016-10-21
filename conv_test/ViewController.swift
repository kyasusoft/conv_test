//
//  ViewController.swift
//  conv_test
//
//  Created by kyasu on 2016/10/13.
//  Copyright © 2016年 kyasu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var yenTextField:    UITextField!
    @IBOutlet weak var dollerTextField: UITextField!
    @IBOutlet weak var 🇯🇵: UIImageView!
    @IBOutlet weak var 🇺🇸: UIImageView!

    var rates: Rate? = nil
    
// MARK:

    // viewがロードされた後に呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rates = Rate()
        rates!.getRateFromWeb( callback: {})
    }

    // メモリーワーニングが発生すると呼ばれる
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
/*
    // セグエで画面遷移する前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowRateViewController") {
            // 遷移先のViewControllerを取得
            let rateVC = segue.destination as? RateViewController
        }
    }
*/
    
// MARK: - Function
    
    // キーボードをしまう
    func dismissKeyboard () {
        
        yenTextField.resignFirstResponder()
        dollerTextField.resignFirstResponder()
    }
    
    // 国旗を動かす
    func moveFlag (_ 国旗: UIImageView) {
        
        // viewの位置とサイズを取得
        var rect = 国旗.frame
        // 動かす距離
        let moveWidth = UIScreen.main.bounds.size.width - 100
        // 左から右へ動かす
        UIView.animate(withDuration: 0.5, animations: {
            rect.origin.x += moveWidth
            国旗.frame = rect
        }) { (bool) in
            // 右から左へ動かす
            UIView.animate(withDuration: 0.5, animations: {
                rect.origin.x -= moveWidth
                国旗.frame = rect
            })
        }
    }

// MARK: - Action
    
    // ドル -> 円 に変換
    @IBAction func toYen(_ sender: AnyObject) {
        
        // キーボードをしまう
        dismissKeyboard()
        
        // レートを取得
        let rate   = rates!.rate()
        // ドルを取得
        let doller = Float(dollerTextField!.text!)!
        // 円に変換
        let yen    = doller * rate

        // テキストフィールドに反映
        yenTextField.text = String(yen)
        
        // 国旗を動かす
        moveFlag(🇯🇵)
    }

    // 円 -> ドル に変換
    @IBAction func toDoller(_ sender: AnyObject) {
        
        dismissKeyboard()

        let rate   = rates!.rate()
        let yen    = Float(yenTextField.text!)!
        let doller = yen / rate
        
        dollerTextField.text = String(doller)
        
        moveFlag(🇺🇸)
    }
}

