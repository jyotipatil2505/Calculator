//
//  ButtonClass.swift
//  Calculator
//
//  Created by Jyoti on 07/05/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class ButtonClass: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.size.height / 2
            self.clipsToBounds = true
        }
    }
}
