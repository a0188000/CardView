//
//  Extension+NSObject.swift
//  CardView
//
//  Created by 沈維庭 on 2019/1/3.
//  Copyright © 2019年 沈維庭. All rights reserved.
//

import Foundation

extension NSObject: Declarative { }

extension Declarative where Self: NSObject {
    init(configureHandler: (Self) -> Void) {
        self.init()
        configureHandler(self)
    }
}
