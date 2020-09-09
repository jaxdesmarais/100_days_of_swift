//
//  ViewController.swift
//  project2_100_days_of_code
//
//  Created by Desmarais, Jax on 8/9/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	let stackView = UIStackView()
    
    var button1: UIButton!
    var button2: UIButton!
    var button3: UIButton!
        
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
                
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let guide = view.safeAreaLayoutGuide

        button1 = UIButton(type: .custom)
        button1.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button1.tag = 0
        button1.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button1)
        
        button2 = UIButton(type: .custom)
        button2.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        button2.layer.borderWidth = 1
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button2.tag = 1
        button2.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button2)
        
        button3 = UIButton(type: .custom)
        button3.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        button3.layer.borderWidth = 1
        button3.layer.borderColor = UIColor.lightGray.cgColor
        button3.tag = 2
        button3.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        view.addSubview(button3)
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.contentMode = .scaleAspectFit
        stackView.alignment = .center
        stackView.spacing = 20.0
        
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(button3)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10).isActive = true
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion(action: nil)
    }
    
    func askQuestion(action: UIAlertAction!) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased()
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        var title: String
        let tagNumber: Int = sender.tag
        let selectedCountryName = countries[tagNumber].uppercased()
        questionsAsked += 1
            
        if tagNumber == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong, that's the flag of \(selectedCountryName)"
            score -= 1
        }
        
        if questionsAsked == 10 {
            let finalAc = UIAlertController(title: "Game Over", message: "Your final score is \(score) out of 10", preferredStyle: .alert)
            finalAc.addAction(UIAlertAction(title: "Play Again", style: .default, handler: askQuestion))
            present(finalAc, animated: true)
            score = 0
            questionsAsked = 0
        }
        
        let rightTitle = UIBarButtonItem(title: "Score: \(score)", style: .plain, target: nil, action: nil)
        rightTitle.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightTitle
        
        let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
		present(ac, animated: true)
    }
}
