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
        tabBarSetup()
    }
    
    //MARK: - Private methods
    private func generateTabBar() {
        let trackerViewController = TrackersViewController()
        let statisticsViewController = StatisticsViewController()
        let statisticsViewModel = StatisticsViewModel()
        statisticsViewController.initialize(viewModel: statisticsViewModel)
        trackerViewController.delegateStatistic = statisticsViewModel
        viewControllers = [
            generateVC(
                viewController: trackerViewController,
                title: "Трекеры",
                image: UIImage(named: "recordIcon")
            ),
            generateVC(
                viewController: statisticsViewController,
                title: "Статистика",
                image: UIImage(named: "statisticsIcon")
            )
        ]
    }
    
    private func tabBarSetup() {
        tabBar.layer.borderWidth = 0.3
        tabBar.layer.borderColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.2).cgColor
        tabBar.clipsToBounds = true
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
