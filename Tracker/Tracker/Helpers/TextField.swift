//
//  TextField.swift
//  Tracker
//
//  Created by Alexandr Seva on 05.10.2023.
//


import UIKit

extension UITextField {
    func indent(size:CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
}
