//
//  ViewController.swift
//  caculator
//
//  Created by 송명균 on 6/23/25.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - 라벨 수식
    let displayLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        label.textColor = UIColor(red: 255/255, green: 188/255, blue: 178/255, alpha: 1.0)
        label.textAlignment = .right
        label.font = .boldSystemFont(ofSize: 60)
        label.text = "0"
        return label
    }()
    
    // 현재 입력 중인 수식 문자열
    var currentExpression = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        setupLayout()
    }
    
    // MARK: - 계산 함수
    func calculate(expression: String) -> Int? {
        let formatted = expression.replacingOccurrences(of: "×", with: "*")
                                  .replacingOccurrences(of: "÷", with: "/")
        let exp = NSExpression(format: formatted)
        return exp.expressionValue(with: nil, context: nil) as? Int
    }
    
    // MARK: - 버튼 액션
    @objc func tapButton(_ sender: UIButton) {
        guard let value = sender.currentTitle else { return }
        
        switch value {
        case "=":
            if let result = calculate(expression: currentExpression) {
                currentExpression = String(result)
            } else {
                currentExpression = "Error"
            }
        case "AC":
            currentExpression = "0"
        default:
            if currentExpression == "0" {
                // 0으로 시작하면 제거
                currentExpression = value
            } else {
                currentExpression += value
            }
        }
        
        displayLabel.text = currentExpression
    }

    // MARK: - 버튼 생성 함수
    func makeButton(title: String, backgroundColor: UIColor, size: CGFloat = 80) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 30)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = size / 2
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(size)
        }
        return button
    }

    // MARK: - 스택뷰
    func makeHorizontalStackView(_ buttons: [UIButton]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }

    // MARK: - 레이아웃 설정
    func setupLayout() {
        view.addSubview(displayLabel)
        displayLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(150)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(100)
        }

        // 색상
        let pink = UIColor(red: 255/255, green: 209/255, blue: 220/255, alpha: 1.0)
        let yellow = UIColor(red: 255/255, green: 216/255, blue: 177/255, alpha: 1.0)
        let green = UIColor(red: 213/255, green: 245/255, blue: 227/255, alpha: 1.0)
        let gray = UIColor(red: 174/255, green: 198/255, blue: 207/255, alpha: 1.0)

        // 버튼 행 구성
        let row1 = makeHorizontalStackView([
            makeButton(title: "AC", backgroundColor: gray),
            makeButton(title: "±", backgroundColor: gray),
            makeButton(title: "%", backgroundColor: gray),
            makeButton(title: "÷", backgroundColor: pink)
        ])
        let row2 = makeHorizontalStackView([
            makeButton(title: "1", backgroundColor: yellow),
            makeButton(title: "2", backgroundColor: yellow),
            makeButton(title: "3", backgroundColor: yellow),
            makeButton(title: "×", backgroundColor: pink)
        ])
        let row3 = makeHorizontalStackView([
            makeButton(title: "4", backgroundColor: yellow),
            makeButton(title: "5", backgroundColor: yellow),
            makeButton(title: "6", backgroundColor: yellow),
            makeButton(title: "-", backgroundColor: pink)
        ])
        let row4 = makeHorizontalStackView([
            makeButton(title: "7", backgroundColor: yellow),
            makeButton(title: "8", backgroundColor: yellow),
            makeButton(title: "9", backgroundColor: yellow),
            makeButton(title: "+", backgroundColor: pink)
        ])
        let row5 = makeHorizontalStackView([
            makeButton(title: "", backgroundColor: green),
            makeButton(title: "0", backgroundColor: yellow),
            makeButton(title: ".", backgroundColor: green),
            makeButton(title: "=", backgroundColor: pink)
        ])
        //MARK: - 가로 스택뷰
        let verticalStackView = UIStackView(arrangedSubviews: [row1, row2, row3, row4, row5])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 10
        verticalStackView.distribution = .fillEqually
        view.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(displayLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(350)
        }
    }
}
