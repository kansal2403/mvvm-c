//
//  AppCoordinator.swift
//  MVVM-C
//
//  Created by Rahish Kansal on 26/04/24.
//

import Foundation
import UIKit

struct PostViewActions {
    let showDetial: (Post)->()
}

class AppCoordinator {
    private var navigationController: UINavigationController?
    
    func start() -> UIViewController {
        let storyboard: UIStoryboard =  UIStoryboard.init(name: "Main", bundle: nil)
        
        func showDetials(for post: Post) {
            let detialsViewcontroller = storyboard.instantiateViewController(identifier: "PostDetailsViewController") { coder in
                PostDetailsViewController.init(coder: coder, post: post)
            }
            self.navigationController?.pushViewController(detialsViewcontroller, animated: true)
        }
        
        let controller = storyboard.instantiateViewController(identifier: "PostsListViewController",
                                                              creator: { coder in
            PostsListViewController.init(coder: coder,
                                         viewModel: PostsListViewModelImpl(
                                            fetchPostsService: FetchPostsServiceImpl(), actions: PostViewActions(showDetial: showDetials(for:)))
            )
        })
        let navController = UINavigationController(rootViewController: controller)
        self.navigationController = navController
        return navController
    }
}
