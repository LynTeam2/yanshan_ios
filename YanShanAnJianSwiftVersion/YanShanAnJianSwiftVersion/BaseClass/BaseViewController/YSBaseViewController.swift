//
//  YSBaseViewController.swift
//  YanShanAnJianSwiftVersion
//
//  Created by 代健 on 2018/6/19.
//  Copyright © 2018年 jiandai. All rights reserved.
//

import UIKit

class YSBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configViewControllerParameter() {
        //子类实现
    }
    
    func configViewLayout() {
        self.extendedLayoutIncludesOpaqueBars = false
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    func addSubViews() {
        
    }
    
    func addNavigationItems() {
        
    }
    
    func backToBeforeViewController() {
        self.navigationController?.popViewController(animated: true)
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
