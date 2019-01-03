//
//  CardViewController.swift
//  CardView
//
//  Created by 沈維庭 on 2019/1/3.
//  Copyright © 2019年 沈維庭. All rights reserved.
//

import UIKit
import SnapKit

class CardViewController: UIViewController {

    var headerView = UIView {
        $0.backgroundColor = .white
    }
    
    private var indicatorView = UIView {
        $0.backgroundColor = .lightGray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.setHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        self.indicatorView.layer.cornerRadius = 4
    }

    private func setHeaderView() {
        self.headerView.addSubview(self.indicatorView)
        self.view.addSubview(self.headerView)
        
        self.indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(65)
            make.height.equalTo(8)
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }

    func remove() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
