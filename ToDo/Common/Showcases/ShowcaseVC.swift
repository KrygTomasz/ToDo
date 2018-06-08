//
//  ShowcaseVC.swift
//  mSomed
//
//  Created by Tomasz Kryg on 28.04.2017.
//  Copyright © 2017 Kamsoft. All rights reserved.
//

import UIKit

public class ShowcaseVC: UIViewController {
    
    @IBOutlet weak var showcaseBackgroundView: UIView! {
        didSet {
            setBackgroundDim(alpha: 0.0)
            addPanGestureToCard()
        }
    }
    
    @IBOutlet weak var upperView: UIView! {
        didSet {
            upperView.backgroundColor = .clear
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideOnTap))
            upperView.addGestureRecognizer(tapGesture)
        }
    }
    @IBOutlet weak var showcaseCardView: UIView! {
        didSet {
            showcaseCardView.backgroundColor = .white
            cardTopPosition = showcaseCardView.frame.origin.y
            showcaseCardView.layer.masksToBounds = true
            showcaseCardView.clipsToBounds = true
        }
    }
    @IBOutlet weak var bottomCardConstraint: NSLayoutConstraint!
    
    let BACKGROUND_DIM_LEVEL: CGFloat = 0.6
    
    var completion: (()->())?
    
    fileprivate var cardTopPosition: CGFloat = 0.0
    private var firstPanPosition: CGFloat = 0.0
    private var lastPanPosition: CGFloat = 0.0
    private var wasPannedUp: Bool = true
    
    public var hideable: Bool = true
    public var showcaseModel: ShowcaseModel? {
        didSet {
            guard
                let model = showcaseModel,
                let navController = childViewControllers.first as? UINavigationController
                else {
                    return
            }
            let showcaseVC = model.viewController
            if let dismissableVC = showcaseVC as? DismissableShowcase {
                dismissableVC.assignDismissClosure(closure: hideView)
            } else {
                fatalError("\(showcaseVC?.nibName) isn't implementing dismissable protocol")
            }
            if let showcaseWithKeyboard = showcaseVC as? ShowcaseWithKeyboard {
                showcaseWithKeyboard.assignShowKeyboardFunction(function: keyboardWillShow)
                showcaseWithKeyboard.assignHideKeyboardFunction(function: keyboardWillHide)
            }
            hideable = model.hideable
            navController.pushViewController((showcaseModel?.viewController)!, animated: false)
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = UINavigationController()
        
        controller.view.frame = showcaseCardView.frame
        
        controller.isNavigationBarHidden = true
        
        self.showcaseCardView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChildViewController(controller)
        showcaseCardView.addSubview(controller.view)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: showcaseCardView.leadingAnchor, constant: 0),
            controller.view.trailingAnchor.constraint(equalTo: showcaseCardView.trailingAnchor, constant: 0),
            controller.view.topAnchor.constraint(equalTo: showcaseCardView.topAnchor, constant: 0),
            controller.view.bottomAnchor.constraint(equalTo: showcaseCardView.bottomAnchor, constant: 0)
            ])
        controller.didMove(toParentViewController: self)
        
        bottomCardConstraint.constant = -showcaseCardView.frame.height
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCardView()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // onPan methods
    func addPanGestureToCard() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(sender:)))
        showcaseBackgroundView.addGestureRecognizer(panRecognizer)
    }
    
    func removeGesturesFromCard() {
        showcaseBackgroundView.gestureRecognizers?.removeAll()
    }
    
    @objc func onPan(sender: UIPanGestureRecognizer) {
        if !hideable {
            return
        }
        let location = sender.location(in: showcaseBackgroundView)
        switch sender.state {
        case .began:
            firstPanPosition = location.y
        case .changed:
            let fingerIsLowerThanCardEdge = location.y > cardTopPosition
            if fingerIsLowerThanCardEdge {
                setPanStartOnCardEdge()
                moveCard(to: location)
            } else {
                showWholeCard()
            }
        case .ended:
            tryHideShowcaseCard(using: location)
        default:
            return
        }
        
    }
    
    private func setPanStartOnCardEdge() {
        if firstPanPosition < cardTopPosition {
            firstPanPosition = cardTopPosition
        }
    }
    
    private func moveCard(to location: CGPoint) {
        if location.y > firstPanPosition {
            let deltaY = location.y - firstPanPosition
            bottomCardConstraint.constant = -deltaY
            if lastPanPosition > location.y {
                wasPannedUp = true
            } else {
                wasPannedUp = false
            }
            lastPanPosition = location.y
            let positionDelta = abs(firstPanPosition - lastPanPosition)
            let alpha = BACKGROUND_DIM_LEVEL * (1 - (positionDelta/showcaseCardView.frame.height))
            setBackgroundDim(alpha: alpha)
        } else {
            bottomCardConstraint.constant = 0
            setBackgroundDim(alpha: BACKGROUND_DIM_LEVEL)
        }
    }
    
    fileprivate func setBackgroundDim(alpha: CGFloat) {
        self.showcaseBackgroundView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
    
    private func showWholeCard() {
        bottomCardConstraint.constant = 0
    }
    
    private func tryHideShowcaseCard(using location: CGPoint) {
        if !hideable {
            return
        }
        let fingerIsLowerThanCardEdge = location.y > cardTopPosition
        if fingerIsLowerThanCardEdge {
            if wasPannedUp {
                showCardView()
            } else {
                hideView() {}
            }
        } else {
            showCardView()
        }
    }
    
}

//MARK: Hide/Show methods
extension ShowcaseVC {
    
    @objc public func hideOnTap() {
        if !hideable {
            return
        }
        self.bottomCardConstraint.constant = -showcaseCardView.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setBackgroundDim(alpha: 0.0)
            self.view.layoutIfNeeded()
        }, completion: {
            completed in
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    public func hideView(onHidden: @escaping onHideCompletionBlock) {
        
        self.bottomCardConstraint.constant = -showcaseCardView.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.setBackgroundDim(alpha: 0.0)
            self.view.layoutIfNeeded()
        }, completion: {
            completed in
            self.dismiss(animated: false, completion: {
                self.completion?()
                onHidden()
            })
        })
        
    }
    
    public func showCardView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            self.bottomCardConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.setBackgroundDim(alpha: self.BACKGROUND_DIM_LEVEL)
                self.view.layoutIfNeeded()
            })
        })
    }
    
}

//MARK: Sliding showcase up/down when keyboard appears
extension ShowcaseVC {
    
    func keyboardWillShow() {
        self.bottomCardConstraint.constant = UIScreen.main.bounds.height - self.showcaseCardView.frame.height
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { completed in
            self.removeGesturesFromCard()
        })
    }
    
    func keyboardWillHide() {
        self.bottomCardConstraint.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        }, completion: { completed in
            self.addPanGestureToCard()
        })
    }
    
}
