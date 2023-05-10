//
//  StatsView.swift
//  Infected
//
//  Created by juliemoorled on 10.05.2023.
//

import UIKit

final class StatsView: UIView {

    // MARK: - Public properties

    var infectedCount = 0
    var healthyCount = 0
    var timePassed = 0

    // MARK: - Private properties

    private let infectedLabel = UILabel()
    private let healthyLabel = UILabel()
    private let timerLabel = UILabel()
    private let fontSize: CGFloat = 16
    private let const: CGFloat = 10

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func updateStats(infectedCount: Int, healthyCount: Int) {
        self.infectedCount = infectedCount
        self.healthyCount = healthyCount
        setLabelText(label: infectedLabel,
                     text: "Количество зараженных: ",
                     coloredText: "\(infectedCount)",
                     color: .systemPink)
        setLabelText(label: healthyLabel,
                     text: "Количество здоровых: ",
                     coloredText: "\(healthyCount)",
                     color: .systemTeal)
    }

    func updateTimerLabel() {
        timePassed += 1
        setLabelText(label: timerLabel,
                     text: "Секунды с начала заражения: ",
                     coloredText: "\(timePassed)",
                     color: .systemPink)
    }

    // MARK: - Private methods (interface setup)

    private func setupView() {
        layer.cornerRadius = 10
        setLabelText(label: infectedLabel,
                     text: "Количество зараженных: ",
                     coloredText: "\(infectedCount)",
                     color: .systemPink)
        setLabelText(label: healthyLabel,
                     text: "Количество здоровых: ",
                     coloredText: "\(healthyCount)",
                     color: .systemTeal)
        setLabelText(label: timerLabel,
                     text: "Секунды с начала заражения: ",
                     coloredText: "\(timePassed)",
                     color: .systemTeal)
        setupLabel(label: infectedLabel, topAnchor: topAnchor)
        setupLabel(label: healthyLabel, topAnchor: infectedLabel.bottomAnchor)
        setupLabel(label: timerLabel, topAnchor: healthyLabel.bottomAnchor)
    }

    private func setupLabel(label: UILabel, topAnchor: NSLayoutYAxisAnchor) {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: const),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: const),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: const)
        ])
        label.font = .systemFont(ofSize: fontSize, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .left
    }

    private func setLabelText(label: UILabel, text: String, coloredText: String, color: UIColor) {
        let attributedText = NSMutableAttributedString(string: text,
                                                       attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        let coloredText = NSAttributedString(string: coloredText,
                                        attributes: [NSAttributedString.Key.foregroundColor: color])
        attributedText.append(coloredText)
        label.attributedText = attributedText
    }

}
