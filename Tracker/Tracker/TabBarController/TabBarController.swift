//
//  TabBarController.swift
//  Tracker
//
//  Created by Alexandr Seva on 02.10.2023.
//

import UIKit

//MARK: - UITabBarController
final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        tabBarAppearance()
    }
    
    //MARK: - Private methods
    private func generateTabBar() {
        viewControllers = [
            generateVC(
                viewController: TrackersViewController(),
                title: "Трекеры",
                image: UIImage(named: "recordIcon")
            ),
            //TODO: Изменить на эткран статистики (Пока установлен экран трекера)
            generateVC(
                viewController: TrackersViewController(),
                title: "Статистика",
                image: UIImage(named: "statisticsIcon")
            )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func tabBarAppearance(){
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBar.standardAppearance = tabBarAppearance
    }
}
