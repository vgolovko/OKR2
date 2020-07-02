//
//  ReusableView.swift
//  Application
//
//  Created by Anton Pavlenko on 15.04.2020.
//  Copyright © 2020 Windmill. All rights reserved.
//

import UIKit

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension ReusableView where Self: UIView {
    public static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIView {
    public static var nibName: String {
        return String(describing: self)
    }
}
