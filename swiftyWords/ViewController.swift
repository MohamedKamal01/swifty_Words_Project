//
//  ViewController.swift
//  swiftyWords
//
//  Created by Mohamed Kamal on 08/02/2022.
//

import UIKit

class ViewController: UIViewController {

    var scoreLabel: UILabel!
    var cluesLabel: UILabel!
    var answerLabel: UILabel!
    var currentAnswer: UITextField!
    var lettersButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        //scorelabel code
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score : 0"
        view.addSubview(scoreLabel)
        
        //clueslabel code
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 18)
        cluesLabel.text = "Clues"
        cluesLabel.numberOfLines = 0
        cluesLabel.textAlignment = .left
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        
        //answerlabel code
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 18)
        answerLabel.text = "Answer"
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .left
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        // current answer
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 30)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)

        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        //constraints
        NSLayoutConstraint.activate([
            //score label
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor , constant: 0),
            
            //clues label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 5),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 1),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 1.2, constant: -100),

            //answer label
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 5),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -1),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            //text field
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),

            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 200),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
        cluesLabel.backgroundColor = .white
        answerLabel.backgroundColor = .white
        let width = 80
        let height = 50

        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonsView.addSubview(letterButton)
                lettersButtons.append(letterButton)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }

    @objc func submitTapped(_ sender: UIButton)
    {
        guard let answerText = currentAnswer.text else { return }

            if let solutionPosition = solutions.firstIndex(of: answerText) {
                activatedButtons.removeAll()

                var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
                splitAnswers?[solutionPosition] = answerText
                answerLabel.text = splitAnswers?.joined(separator: "\n")

                currentAnswer.text = ""
                score += 1

                if score % 7 == 0 {
                    let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                    present(ac, animated: true)
                }
            }
    }
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in lettersButtons {
            btn.isHidden = false
        }
    }
    @objc func clearTapped(_ sender: UIButton)
    {
        currentAnswer.text = ""

            for btn in activatedButtons {
                btn.isHidden = false
            }

            activatedButtons.removeAll()
    }
    @objc func letterTapped(_ sender: UIButton)
    {
        guard let buttonTitle = sender.titleLabel?.text else { return }
            currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
            activatedButtons.append(sender)
            sender.isHidden = true
    }
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        // Now configure the buttons and labels
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

        letterBits.shuffle()

        if letterBits.count == lettersButtons.count {
            for i in 0 ..< lettersButtons.count {
                lettersButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
}

