//
//  ViewController.swift
//  GFDropDownDemo
//
//  Created by ECHINACOOP1 on 2017/4/1.
//  Copyright © 2017年 蔺国防. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var list : GFDropDown?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        list =  GFDropDown.init(frame: CGRect.init(x: 20, y: 300, width: 200, height: 50), dataArr: ["Row1","Row2","Row3"], placeHolder: "请输入类型")
        
        self.view.addSubview(list!)
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

