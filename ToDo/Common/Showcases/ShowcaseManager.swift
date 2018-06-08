//
//  ShowcaseManager.swift
//  mSomed
//
//  Created by Tomasz Kryg on 05.05.2017.
//  Copyright © 2017 Kamsoft. All rights reserved.
//

import UIKit

public class ShowcaseManager {
    
    public static var instance: ShowcaseManager = ShowcaseManager()
    
    fileprivate init() { }
    
    private weak var presentingVC: UIViewController?
    
    public func set(presentingViewController: UIViewController?) {
        presentingVC = presentingViewController
    }
    
    public func show(using showcaseModel: ShowcaseModel?) {
        
        guard let showcaseVC: ShowcaseVC = getShowcase(using: showcaseModel) else {
            return
        }
        presentingVC?.present(showcaseVC, animated: false, completion: nil)
        
    }
    
    public func show(using showcaseModels: [ShowcaseModel?]) {
        let reversedModels = showcaseModels.reversed()
        var completion: (()->())? = nil
        
        for model in reversedModels {
            if canBeShown(using: model) {
                guard let showcaseVC: ShowcaseVC = getShowcase(using: model) else {
                    continue
                }
                showcaseVC.completion = completion
                completion = {
                    self.presentingVC?.present(showcaseVC, animated: false, completion: nil)
                }
            }
            
        }
        guard let showShowcase: (()->()) = completion else {
            return
        }
        showShowcase()
    }
    
    public func getShowcase(using showcaseModel: ShowcaseModel?) -> ShowcaseVC? {
        guard let showcaseVC = getInstance() else {
            return nil
        }
        _ = showcaseVC.view
        showcaseVC.showcaseModel = showcaseModel
        showcaseVC.modalPresentationStyle = .overCurrentContext
        return showcaseVC
    }
    
    public func getInstance() -> ShowcaseVC? {
        let viewController = ShowcaseVC(nibName: "ShowcaseVC", bundle: Bundle(for: ShowcaseVC.self))
        return viewController
    }
    
    fileprivate func canBeShown(using showcaseModel: ShowcaseModel?) -> Bool {
        guard let show = showcaseModel?.canBeShown else { return false }
        return show()
    }
    
    
}
