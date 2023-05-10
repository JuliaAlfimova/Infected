//
//  CGPointExtension.swift
//  Infected
//
//  Created by juliemoorled on 10.05.2023.
//

import Foundation

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return hypot(dx, dy)
    }
}
