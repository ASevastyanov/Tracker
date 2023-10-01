//
//  ViewController.swift
//  Tracker
//
//  Created by Alexandr Seva on 01.10.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var nameUserLabel : UILabel = {
        let nameUserLabel = UILabel()
        nameUserLabel.text = " test "
        nameUserLabel.textColor = .black
        nameUserLabel.font = .boldSystemFont(ofSize: 23)
        nameUserLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameUserLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(nameUserLabel)
        view.backgroundColor = .white
        NSLayoutConstraint.activate([
            nameUserLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameUserLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }


}

