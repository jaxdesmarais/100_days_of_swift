//
//  ViewController.swift
//  project5_100_days_of_code
//
//  Created by Desmarais, Jax on 8/31/20.
//  Copyright © 2020 Desmarais, Jax. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(startGame))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupTableView()
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        startGame()
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Word")
    }
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        guard isPossible(word: lowerAnswer) else {
            showErrorMessage(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isOriginal(word: lowerAnswer)  else {
            showErrorMessage(title: "Word already used", message: "Be more original!")
            return
        }
        
        guard isReal(word: lowerAnswer) else {
            showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title!.lowercased()).")
            return
        }
        usedWords.insert(lowerAnswer, at: 0)
                    
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
                    
        return
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        if word != title {
        	return !usedWords.contains(word)
        } else {
            return false
        }
    }
    
    func isReal(word: String) -> Bool {
        if word.count >= 3 {
			let checker = UITextChecker()
        	let range = NSRange(location: 0, length: word.utf16.count)
        	let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        	return misspelledRange.location == NSNotFound
        } else {
            return false
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        let errorTitle = title
        let errorMessage = message
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return usedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
}

