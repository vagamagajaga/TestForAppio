//
//  ViewController.swift
//  BookKeeper
//
//  Created by Vagan Galstian on 09.04.2023.
//

import UIKit

final class StartVC: UIViewController {
    
    //MARK: - Properties
    private var animatedCircle = UIImageView()
    private var appNameLabel = UIImageView()
    private var bookLabel = UIImageView()
    private var startButton = UIButton()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        addAnimatedLabel()
        //Double.random(in: 2.0...5.0) вставить вместо 1.0 в withDuration
        UIView.animate(withDuration: 1.0, animations: {
            self.animatedCircle.transform = CGAffineTransform(rotationAngle: .pi)
        }) { _ in
            self.animatedCircle.removeFromSuperview()
            self.addAppLabelName()
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.addBookLabel()
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                    self.addStartButton()
                }
            }
        }
    }
    
    //MARK: - Methods
    @objc private func buttonPressed() {
        let vc = BooksVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Configuration
    private func addAppLabelName() {
        view.addSubview(appNameLabel)
        
        appNameLabel.image = UIImage(named: "bookLabelName")
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appNameLabel.widthAnchor.constraint(equalToConstant: 272),
            appNameLabel.heightAnchor.constraint(equalToConstant: 40),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100)
        ])
    }
    
    private func addBookLabel() {
        view.addSubview(bookLabel)
        
        bookLabel.image = UIImage(named: "icon")
        bookLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bookLabel.widthAnchor.constraint(equalToConstant: 272),
            bookLabel.heightAnchor.constraint(equalToConstant: 225),
            bookLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bookLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70)
        ])
    }
    
    private func addAnimatedLabel() {
        view.addSubview(animatedCircle)
        
        animatedCircle.image = UIImage(named: "circle")
        animatedCircle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            animatedCircle.widthAnchor.constraint(equalToConstant: 70),
            animatedCircle.heightAnchor.constraint(equalToConstant: 70),
            animatedCircle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedCircle.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addStartButton() {
        view.addSubview(startButton)
        
        startButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        startButton.backgroundColor = .systemBlue
        startButton.layer.cornerRadius = 10
        startButton.setTitle("Start", for: .normal)
        startButton.titleLabel?.textColor = .white
        startButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
        ])
    }
}
