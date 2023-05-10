//
//  InfectionSpreadModel.swift
//  Infected
//
//  Created by juliemoorled on 10.05.2023.
//

import Foundation

class InfectionSpreadModel {

    // MARK: - Properties

    var groupSize: Int
    var infectionFactor: Int
    var time: Int
    var healthyCount: Int
    var infectedCount: Int


    // MARK: - Initialization

    init(groupSize: Int, infectionFactor: Int, time: Int) {
        self.groupSize = groupSize
        self.infectionFactor = infectionFactor
        self.time = time
        self.healthyCount = groupSize
        self.infectedCount = 0
    }

    // MARK: - Methods

    func updateModel() {
        infectedCount += 1
        healthyCount -= 1
    }

}
