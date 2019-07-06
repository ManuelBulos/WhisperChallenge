//
//  AppController.swift
//  PopularReplies
//
//  Created by Jose Manuel Solis Bulos on 27/06/19.
//  Copyright © 2019 manuelbulos. All rights reserved.
//

import UIKit

class AppController {

    let window: UIWindow?

    init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let presenter = WhisperListPresenter(title: "Popular List", whisperService: WhisperService())
        let popularListViewController = WhisperListViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: popularListViewController)
        navigationController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
