//
//  ModelingVC.swift
//  Infected
//
//  Created by juliemoorled on 09.05.2023.
//

import UIKit

final class ModelingVC: UIViewController {

    // MARK: - Private properties

    private var infectionModel = InfectionSpreadModel(groupSize: 0, infectionFactor: 0, time: 0)
    private var circles = [CircleView]()
    private var scrollHeight: CGFloat = 100
    private var statsHeight: CGFloat = 100
    private var secondsCounterTimer: Timer? //for stats
    private var timeCounterTimer: Timer? //for infection update

    private let infoLabel = UILabel()
    private let scrollView = UIScrollView()
    private let statsView = StatsView()
    private let circleDiameter: Int = 50
    private let fontSize: CGFloat = 16
    private let const: CGFloat = 10

    var counter = 0

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInterface()
    }

    // MARK: - Public methods

    func setParameters(groupSize: Int, infectionFactor: Int, time: Int) {
        infectionModel = InfectionSpreadModel(groupSize: groupSize,
                                              infectionFactor: infectionFactor,
                                              time: time)
    }

    // MARK: - Private modeling methods

    private func infect(circle: CircleView) {
        if circle.isInfected { return }
        if circles.count > 1 && secondsCounterTimer?.isValid != true {
            startPandemic()
        }
        circle.setInfected()
        infectionModel.updateModel()
        statsView.updateStats(infectedCount: infectionModel.infectedCount, healthyCount: infectionModel.healthyCount)
        checkForTheEnd()
    }

    private func startPandemic() {
        secondsCounterTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.statsView.updateTimerLabel()
        }
        timeCounterTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(infectionModel.time), repeats: true) { [weak self] _ in
            DispatchQueue.global(qos: .background).async {
                if let infectedCircles = self?.circles.filter({ $0.isInfected == true }) {
                    for circle in infectedCircles {
                        self?.infectNearestViews(to: circle, count: self?.infectionModel.infectionFactor ?? 0)
                    }
                }
            }
        }
    }

    private func infectNearestViews(to circle: CircleView, count: Int){
        DispatchQueue.global(qos: .background).async {
            guard let superview = circle.superview else { return }
            let circleSubViews = superview.subviews.compactMap { $0 as? CircleView }
//            let subviews = circleSubViews.filter { $0 != circle && !$0.isInfected }
//            должны заражаться только соседи?
            let sortedSubviews = circleSubViews.sorted { firstView, secondView in
                let firstDistance = firstView.center.distance(to: circle.center)
                let secondDistance = secondView.center.distance(to: circle.center)
                return firstDistance < secondDistance
            }
            let nearestViews = Array(sortedSubviews.prefix(count))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                for view in nearestViews {
                    self.infect(circle: view)
                }
            }
        }
    }

    private func checkForTheEnd() {
        if infectionModel.healthyCount > 0 { return }
        infectionModel.infectedCount = infectionModel.groupSize
        infectionModel.healthyCount = 0
        statsView.updateStats(infectedCount: infectionModel.infectedCount, healthyCount: infectionModel.healthyCount)
        secondsCounterTimer?.invalidate()
        timeCounterTimer?.invalidate()
        infoLabel.textColor = .systemPink
        infoLabel.text = "Конец. Все люди в моделируемой группе заражены."
    }

    // MARK: - Actions

    @objc func circleTapped(_ sender: UITapGestureRecognizer) {
        guard let circleView = sender.view as? CircleView else { return }
        if circleView.isInfected { return }
        animateCircle(circleView: circleView)
        infect(circle: circleView)
    }

}

extension ModelingVC {

    // MARK: - Private methods (interface setup)

    private func setupInterface() {
        view.backgroundColor = .systemGray6
        navigationController?.navigationBar.tintColor = .label
        setupInfoLabel()
        setupStatsView()
        setupScrollView()
        setCircles()
        drawCircles()
    }

    private func setupInfoLabel() {
        view.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: const),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -const),
        ])
        infoLabel.text = "Нажмите на здоровый элемент для начала заражения"
        infoLabel.font = .systemFont(ofSize: fontSize, weight: .semibold)
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.textColor = .systemTeal
    }

    private func setupStatsView() {
        statsView.updateStats(infectedCount: infectionModel.infectedCount, healthyCount: infectionModel.healthyCount)
        view.addSubview(statsView)
        statsView.translatesAutoresizingMaskIntoConstraints = false
        statsHeight = view.frame.height * 0.15
        NSLayoutConstraint.activate([
            statsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            statsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statsView.heightAnchor.constraint(equalToConstant: statsHeight)
        ])

    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollHeightMultiplier = CGFloat(infectionModel.groupSize < 100 ? 1 : infectionModel.groupSize / 100)
        scrollHeight = view.frame.height*0.75 - statsHeight
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: const),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: statsView.topAnchor)
        ])
        scrollHeight *= scrollHeightMultiplier
        scrollView.contentSize.height = scrollHeight
        print("\(scrollHeight*scrollHeightMultiplier/100)")
    }

    private func setCircles() {
        if infectionModel.groupSize < 1 { return }
        for _ in 1...infectionModel.groupSize {
            let circle = CircleView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: circleDiameter,
                                                  height: circleDiameter))
            circles.append(circle)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:)))
            circle.addGestureRecognizer(tapGesture)
        }
    }

    private func drawCircles() {
        for circle in circles {
            let randomX = CGFloat.random(in: 0...(view.bounds.width - CGFloat(circleDiameter)))
            let randomY = CGFloat.random(in: 0...(scrollHeight - CGFloat(circleDiameter)))
            circle.frame.origin = CGPoint(x: randomX, y: randomY)
            scrollView.addSubview(circle)
        }
    }

    private func animateCircle(circleView: CircleView) {
        UIView.animate(withDuration: 0.5, animations: {
            circleView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }) { (completed) in
            UIView.animate(withDuration: 0.5, animations: {
                circleView.transform = CGAffineTransform.identity
            })
        }
    }

}
