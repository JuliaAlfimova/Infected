//
//  ViewController.swift
//  Infected
//
//  Created by juliemoorled on 09.05.2023.
//

import UIKit

final class MainVC: UIViewController {

    // MARK: - Private properties

    private let welcomeLabel = UILabel()
    private let groupSizeTextField = UITextField()
    private let infectionFactorTextField = UITextField()
    private let timeTextField = UITextField()
    private let startButton = UIButton()

    private let fieldHeight: CGFloat = 50
    private let bigFontSize: CGFloat = 19
    private let fontSize: CGFloat = 16
    private let const: CGFloat = 22

    private var groupSize = Int()
    private var infectionFactor = Int()
    private var time = Int()


    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    // MARK: - Actions

    @objc func startButtonTapped(sender: UIButton!) {
        animateButton(sender)
        let modelingVC = ModelingVC()
        if let groupSize = Int(groupSizeTextField.text ?? ""),
            let infectionFactor = Int(infectionFactorTextField.text ?? ""),
            let time = Int(timeTextField.text ?? ""){

            modelingVC.setParameters(groupSize: groupSize,
                                     infectionFactor: infectionFactor,
                                     time: time)
        } else {
            showErrorAlertController(errorMessage: "Неверный формат ввода данных. Параметры должны быть записаны неотрицательными целыми числами.")
        }
        self.navigationController?.pushViewController(modelingVC, animated: true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        textField.text = String(text.prefix(4).filter { "0123456789".contains($0) })
    }

}

extension MainVC {

    // MARK: - Private methods (interface setup)

    private func setupInterface() {
        view.backgroundColor = .systemGray6
        setupLabel(welcomeLabel)
        setupTextField(textField: groupSizeTextField,
                       placeholderText: "Количество людей в группе",
                       topAnchor: welcomeLabel.bottomAnchor)
        setupTextField(textField: infectionFactorTextField,
                       placeholderText: "Коэффициент передачи инфекции (чел)",
                       topAnchor: groupSizeTextField.bottomAnchor)
        setupTextField(textField: timeTextField,
                       placeholderText: "Период пересчета (сек)",
                       topAnchor: infectionFactorTextField.bottomAnchor)
        setupButton(startButton)
    }

    private func setupLabel(_ label: UILabel) {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: const),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -const),
        ])
        label.text = "Добро пожаловать!\nВведите параметры для моделирования."
        label.font = .systemFont(ofSize: bigFontSize, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemTeal
    }

    private func setupTextField(textField: UITextField,
                                placeholderText: String,
                                topAnchor: NSLayoutYAxisAnchor) {
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: const),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -const),
            textField.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        textField.placeholder = placeholderText
        textField.borderStyle = .roundedRect
        textField.leftViewMode = .always
        textField.font = .systemFont(ofSize: fontSize)
        textField.backgroundColor = .systemGray5
        textField.keyboardType = .numberPad //restricting data entry
        textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    private func setupButton(_ button: UIButton) {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: const),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -const),
            button.heightAnchor.constraint(equalToConstant: fieldHeight)
        ])
        button.titleLabel?.font = .systemFont(ofSize: fontSize, weight: .semibold)
        button.setTitleColor(.systemGray6, for: .normal)
        button.setTitle("Запустить моделирование", for: .normal)
        button.layer.cornerRadius = fieldHeight / 2
        button.backgroundColor = .systemTeal
        button.layer.masksToBounds = true

        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }

    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                button.transform = CGAffineTransform.identity
            })
        })
    }

    private func showErrorAlertController(errorMessage: String?) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: errorMessage,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Понятно", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        if alert.isBeingPresented { return }
        present(alert, animated: true)
    }

}

