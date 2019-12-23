//
//  GradientView.swift
//  Pods
//
//  Created by Ramon Vicente on 23/03/17.
//
//

import UIKit

public class Gradient: View {

    fileprivate let gradientLayer = CAGradientLayer()

    public enum Direction {
        case top
        case bottom
        case left
        case right
        case other(CGPoint, CGPoint)

        var points: (CGPoint, CGPoint) {
            switch self {
            case .top:
                return (CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 1.0))
            case .bottom:
                return (CGPoint(x: 0, y: 1.0), CGPoint(x: 0, y: 0))
            case .left:
                return (CGPoint(x: 1.0, y: 0), CGPoint(x: 0, y: 0))
            case .right:
                return (CGPoint(x: 0.0, y: 0), CGPoint(x: 1.0, y: 0))
            case .other(let from, let to):
                return (from, to)
            }
        }
    }

    public var direction: Direction = .right {
        didSet {
            self.setupGradientLayer()
        }
    }

    public var colors: [UIColor] = [] {
        didSet {
            self.setupGradientLayer()
        }
    }

    // MARK: - Initializers
    public override func prepare() {
        super.prepare()

        self.layer.addSublayer(gradientLayer)
        setupGradientLayer()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }

    var locations: [NSNumber] {
        guard self.colors.count > 1 else {
            return [0]
        }

        let lastIndex = self.colors.count - 1

        let points = self.direction.points
        let distance = points.0.distance(to: points.1)

        return self.colors.enumerated().map { color in
            return NSNumber(value: {
                let r = Double(color.offset) / Double(lastIndex)
                return r * Double(distance)
            }() as Double)
        }
    }

    // MARK: - Setup Layer
    private func setupGradientLayer() {
        gradientLayer.frame = bounds

        gradientLayer.locations = self.locations
        gradientLayer.colors = self.colors.map { $0.cgColor }
        gradientLayer.startPoint = self.direction.points.0
        gradientLayer.endPoint = self.direction.points.1
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        self.setupGradientLayer()
    }
}

public extension Gradient {
    class func Linear(colors: [UIColor], direction: Direction) -> Gradient {
        let gradient = Gradient()
        gradient.colors = colors
        gradient.direction = direction
        return gradient
    }

    func animates(animator handler: (CAGradientLayer) -> Void) {
        handler(self.gradientLayer)
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}

extension Gradient {
    class var Skeleton: Gradient {
        let gradient = Gradient()

        gradient.colors = (0..<4).reduce([UIColor]()) { sum, _ in
            return sum + [#colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1), #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)]
        }

        gradient.direction = .other(.init(x: -2.0, y: 0.0), .init(x: 1.5, y: 0.0))

        gradient.animates { layer in
            let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
            animation.duration = 1.75
            animation.repeatCount = .infinity
            animation.fromValue = [Double]([-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5]).map { NSNumber(value: $0) }
            animation.toValue = [Double]([-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5]).map { NSNumber(value: $0 + 2) }
            animation.fillMode = .forwards
            animation.isRemovedOnCompletion = false
            layer.add(animation, forKey: #keyPath(CAGradientLayer.locations))
        }

        return gradient
    }
}
