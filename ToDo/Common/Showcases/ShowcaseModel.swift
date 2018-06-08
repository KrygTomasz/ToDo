//
//  ShowcaseModel.swift
//  mSomed
//
//  Created by Tomasz Kryg on 12.03.2018.
//  Copyright © 2018 Kamsoft. All rights reserved.
//

import UIKit

public typealias onHideCompletionBlock = (() -> Void)

public protocol DismissableShowcase: class {
    func assignDismissClosure(closure: @escaping (_ onHidden: @escaping onHideCompletionBlock) -> Void)
}

public protocol ShowcaseWithKeyboard: class {
    func assignShowKeyboardFunction(function: @escaping () -> Void)
    func assignHideKeyboardFunction(function: @escaping () -> Void)
}

/**
 Provides model for Showcase using UIViewController, function with show/hide conditions and optional hideable property (default value is true).
 */
public class ShowcaseModel {
    
    var viewController: UIViewController!
    var canBeShown: (() -> Bool)!
    var hideable: Bool!
    
    public init(with viewController: UIViewController, canBeShownFunction: @escaping (() -> Bool), canBeHide: Bool = true) {
        self.viewController = viewController
        self.canBeShown = canBeShownFunction
        self.hideable = canBeHide
    }
    
}
