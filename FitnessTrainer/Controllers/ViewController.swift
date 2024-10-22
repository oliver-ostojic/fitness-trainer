//
//  ViewController.swift
//  FitnessTrainer
//
//  Created by Oliver Ostojic on 9/17/24.
//

import UIKit

class ViewController: UIViewController {
   
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.myImageView.addSymbolEffect(.bounce, animated: true)
        }
    }
    
    private func setUp() {
        view.addSubview(myImageView)
        NSLayoutConstraint.activate([
            myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            myImageView.heightAnchor.constraint(equalToConstant: 200),
            myImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}
