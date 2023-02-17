//
//  UIViewController+ProgressHUD.swift
//  The Movie Database
//
//  Created by Beavean on 04.09.2022.
//

import JGProgressHUD

extension UIViewController {
    private static let hud = JGProgressHUD()

    func showLoader(_ show: Bool, withText text: String? = "Loading") {
        Self.hud.textLabel.text = text
        if show {
            Self.hud.show(in: view)
        } else {
            Self.hud.dismiss()
        }
    }
}
