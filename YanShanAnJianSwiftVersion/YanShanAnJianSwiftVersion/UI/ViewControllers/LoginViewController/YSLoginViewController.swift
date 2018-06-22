//
//  YSLoginViewController.swift
//  YanShanAnJianSwiftVersion
//
//  Created by 代健 on 2018/6/19.
//  Copyright © 2018年 jiandai. All rights reserved.
//

import UIKit

class YSLoginViewController: YSBaseViewController {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
   
    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - action method
    @IBAction func loginViewEndEditing(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func userLoginAction(_ sender: UIButton) {
        
        if (userNameTF.text?.isEmpty)! || (passwordTF.text?.isEmpty)! {
            print("--------")
            return;
        }
        self.userLoginSuccess()
        print(userNameTF.text!)
    }
    func userLoginSuccess() {
        let mainSB = UIStoryboard.init(name: kMainSBID, bundle: Bundle.main)
        let vc = mainSB.instantiateViewController(withIdentifier: kTabbarVCID)
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
