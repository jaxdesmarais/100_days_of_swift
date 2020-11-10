//
//  ViewController.swift
//  milestone_project_3
//
//  Created by Desmarais, Jax on 11/2/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var allWords = [String]()
    var currentWord: String = ""
    var promptWord = [String]()
    var scoreLabel: UILabel!
    var wordLabel: UILabel!
    var chancesLeftLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "score: \(score)"
        }
    }
    
    var chancesLeft = 7 {
        didSet {
            chancesLeftLabel.text = "chances left: \(chancesLeft)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "score: 0"
        view.addSubview(scoreLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 44)
        wordLabel.text = ""
        view.addSubview(wordLabel)
        
        chancesLeftLabel = UILabel()
        chancesLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        chancesLeftLabel.textAlignment = .center
        chancesLeftLabel.font = UIFont.systemFont(ofSize: 30)
        chancesLeftLabel.text = "chances left: 7"
        view.addSubview(chancesLeftLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 100),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            
            chancesLeftLabel.topAnchor.constraint(equalTo: buttonsView.bottomAnchor, constant: 50),
            chancesLeftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let width = 44
        let height = 100
        
        for row in 0..<3 {
            for column in 0..<9 {
                    let letterButton = UIButton(type: .system)
                    letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                    letterButton.setTitle("", for: .normal)
                    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                    
                    let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                    letterButton.frame = frame
                    buttonsView.addSubview(letterButton)
                    letterButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.startGame()
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        if currentWord.contains(buttonTitle) {
            for (index, character) in currentWord.enumerated() {
                if character == Character(buttonTitle) {
                    promptWord[index] = buttonTitle
                    wordLabel.text = promptWord.joined()
                    
                    if !promptWord.contains("_") {
                        score += 1
                        let victoryAC = UIAlertController(title: "Congratulations!", message: "You won!", preferredStyle: .alert)
                        victoryAC.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nextWord))
                        present(victoryAC, animated: true)
                    }
                }
            }
    	} else {
			chancesLeft -= 1
        }
        activatedButtons.append(sender)
        sender.isHidden = true
        
        if chancesLeft == 0 {
            score = 0
            let gameOverAC = UIAlertController(title: "GAME OVER", message: "You lost!", preferredStyle: .alert)
            gameOverAC.addAction(UIAlertAction(title: "Try again", style: .default, handler: nextWord))
            present(gameOverAC, animated: true)
        }
    }
    
    @objc func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        currentWord = allWords.randomElement() ?? "silkworm"
        print(currentWord)
        
        for _ in 0..<currentWord.count {
            promptWord.append("_")
            wordLabel.text? = promptWord.joined()
        }
        
        DispatchQueue.main.async { [weak self] in
            let alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",""]
            guard let letterButtons = self?.letterButtons else { return }
            
            if alphabet.count == letterButtons.count {
                for i in 0..<alphabet.count {
                    letterButtons[i].setTitle(alphabet[i], for: .normal)
                }
            }
        }
    }
    
    @objc func nextWord(action: UIAlertAction! = nil) {
        promptWord.removeAll()
        currentWord.removeAll()
        
        for button in letterButtons {
            button.isHidden = false
        }
        startGame()
    }
}
