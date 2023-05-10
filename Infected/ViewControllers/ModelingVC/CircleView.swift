//
//  ElementView.swift
//  Infected
//
//  Created by juliemoorled on 09.05.2023.
//

import UIKit

final class CircleView: UIView {

    // MARK: - Properties

    var isInfected: Bool = false
    private var color = UIColor()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public methods

    func setInfected() {
        isInfected = true
        UIView.animate(withDuration: 0.5) {
            self.setupView()
        }
    }

    // MARK: - Private methods (interface setup)

    private func setupView() {
        if isInfected {
            color = .systemPink
        } else {
            color = .systemTeal
        }
        backgroundColor = color.withAlphaComponent(0.5)
        layer.cornerRadius = frame.size.width / 2
        layer.borderWidth = 2
        layer.borderColor = color.cgColor
    }

}
