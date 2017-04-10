//
//  GFDropDown.swift
//  GFDropDownDemo
//
//  Created by ECHINACOOP1 on 2017/4/1.
//  Copyright © 2017年 蔺国防. All rights reserved.
//

import UIKit

let cellId = "cellID"

class GFDropDown: UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    var tableView : UITableView?
    var textField : UITextField?
    
    ///textFiled高度&&控件的高度
    var textFieldH: CGFloat?
    ///tableView高度
    var tableViewH: CGFloat? = 120
    ///tableView的cell高度
    var rowH      : CGFloat? = 50
    ///数据源
    var data      : [Any]?
    ///占位文字
    var placeText : String?
    ///列表是否显示
    var isShowList: Bool?{
    
        didSet{
            if isShowList! {
                
                self.superview?.bringSubview(toFront: self)
                //设置下拉动画
                UIView.beginAnimations("ResizeForKeyBorard", context: nil
                )
                UIView.setAnimationCurve(UIViewAnimationCurve.easeIn)
                self.frame.size.height = textFieldH! + tableViewH!
                tableView?.frame.size.height = tableViewH!
                UIView.commitAnimations()
            }else{
                //设置上拉动画
                UIView.beginAnimations("ResizeForKeyBorard", context: nil
                )
                UIView.setAnimationCurve(UIViewAnimationCurve.easeIn)
                self.frame.size.height = textFieldH!
                tableView?.frame.size.height = 0
                UIView.commitAnimations()
            }
        }
    }
    
    init(frame: CGRect, dataArr:[Any], placeHolder: String) {
        
        super.init(frame: frame);
        
        data = dataArr
        placeText = placeHolder
        textFieldH = frame.size.height
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        
        //创建并设置textfield和tableView
        textField = UITextField.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: textFieldH!))
        
        textField?.delegate = self
        textField?.placeholder = placeText
        textField?.layer.borderWidth = 1
        textField?.layer.masksToBounds = true
        textField?.layer.cornerRadius = 5
        textField?.layer.borderColor = UIColor.gray.cgColor
        textField?.placeholder = placeText
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 0))
        
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView?.delegate = self
        tableView?.rowHeight = rowH!
        tableView?.dataSource = self
        
        tableView?.layer.cornerRadius = 5
        tableView?.layer.masksToBounds = true
        tableView?.layer.borderWidth = 1
        tableView?.layer.borderColor = UIColor.gray.cgColor
        
        self.addSubview(textField!)
        self.addSubview(tableView!)
        
        //初始化不显示列表
        isShowList = false
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        
        //控制列表显示状态
        if self.isShowList! {
            
            self.isShowList = false
        }else{
            self.isShowList = true
        }
        
        //不允许TextField编辑
        return false
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return (self.data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        cell?.textLabel?.text = self.data?[indexPath.row] as? String
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isShowList = false
        textField?.text = self.data?[indexPath.row] as? String
    }
    
    
    //重写hitTest方法,来处理在View点击外区域收回下拉列表
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if self.isUserInteractionEnabled == false && self.alpha <= 0.01 && self.isHidden == true {
        
            return nil
        }
        
        if self.point(inside: point, with: event) == false {
            self.isShowList = false
            return nil
        }else{
            
            for subView in self.subviews.reversed() {
                
                let convertPoint = subView.convert(point, from: self)
                let hitTestView = subView.hitTest(convertPoint, with: event)
                if (hitTestView != nil) {
                    return hitTestView
                }
            }
            return self
        }
    }
}
