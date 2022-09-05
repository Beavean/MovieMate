//
//  UIViewController+ProgressHUD.swift
//  The Movie Database
//
//  Created by Beavean on 04.09.2022.
//

import JGProgressHUD

extension UIViewController {
    
    static let hud = JGProgressHUD()
    
    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        UIViewController.hud.textLabel.text = text
        if show {
            UIViewController.hud.show(in: view)
        } else {
            UIViewController.hud.dismiss()
        }
    }
}
