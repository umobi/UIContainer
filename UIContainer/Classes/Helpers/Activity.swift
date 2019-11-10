//
//  ViewSharedContext.swift
//  Pods-UIContainer_Tests
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit

open class Activity: View {

    private weak var contentView: UIView!
    public private(set) var size: Size = .medium

    private weak var stackView: UIStackView!
    weak var activityView: UIActivityIndicatorView!
    public private(set) var mode: Mode = .forever

    public weak var blur: Blur!
    public override var backgroundColor: UIColor? {
        get { self.contentView.backgroundColor }
        set { self.contentView.backgroundColor = newValue }
    }

    open var activityColor: UIColor? {
        get { return self.activityView?.color }
        set { self.activityView?.color = newValue }
    }

    override public func prepare() {
        super.prepare()

        self.prepareContent()
        self.prepareActivity()

        self.setContentViews(self.defaultContentViews())
    }

    open func setSize(_ size: Size) {
        self.size = size
        self.activityView?.transform = .init(scaleX: self.size.factor, y: self.size.factor)
    }

    open func setMode(_ mode: Mode) {
        self.mode = mode

        if self.isAnimating {
            if case .until(let time) = self.mode {
                self.setInterruption(time)
            }

            if case .forever = self.mode {
                self.killInterruption()
            }
        }
    }

    func prepareContent() {
        let contentView = UIView()
        let rounder = Rounder(contentView, radius: 5)
        self.addSubview(rounder)
        rounder.snp.makeConstraints {
            $0.edges.equalTo(0)
        }

        self.contentView = contentView

    }

    private var timer: Timer? = nil
    func setInterruption(_ time: TimeInterval) {
        guard self.isAnimating else {
            return
        }

        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { [weak self] _ in
            self?.hide()
        })
    }

    func killInterruption() {
        self.timer?.invalidate()
        self.timer = nil
    }

    func prepareActivity() {
        let blur = Blur(dynamicBlur: .init(dynamic: {
            guard #available(iOS 13, *) else {
                return .light
            }

            return $0.userInterfaceStyle == .dark ? .dark : .light
        }))

        self.blur = blur

        self.contentView.addSubview(blur)
        blur.snp.makeConstraints { $0.edges.equalTo(0) }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0

        self.contentView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalTo(0)}
        self.stackView = stackView
    }

    public func setContentViews(_ views: [UIView]) {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            self.stackView.addArrangedSubview($0)
        }
    }

    open func defaultContentViews() -> [UIView] {
        let activity = UIActivityIndicatorView(style: .gray)
        activity.transform = .init(scaleX: self.size.factor, y: self.size.factor)

        activity.setContentHuggingPriority(.required, for: .horizontal)
        activity.setContentHuggingPriority(.required, for: .vertical)
        activity.setContentCompressionResistancePriority(.required, for: .vertical)
        activity.setContentCompressionResistancePriority(.required, for: .horizontal)

        self.activityView = activity
        return [Spacer(activity, spacing: 30)]
    }

    open func start() {
        self.activityView.startAnimating()

        if case .until(let time) = self.mode {
            self.setInterruption(time)
        }
    }

    open func stop() {
        self.activityView.stopAnimating()
        self.killInterruption()
    }

    open var isAnimating: Bool {
        return self.activityView.isAnimating
    }

    public func show(inViewController view: UIViewController!) {
        let controller = ContainerController(self)
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .partialCurl
        view.present(controller, animated: true, completion: {
            self.start()
        })
    }

    weak var container: Container? = nil
    public func show(inView view: UIView!) {
        let container = Container(in: nil, loadHandler: { self })
        view.addSubview(container)
        container.snp.makeConstraints { $0.edges.equalTo(0) }
        self.start()
        self.container = container
    }

    public func hide() {
        if self.parent == nil {
            self.stop()
            self.container?.removeFromSuperview()
            return
        }

        guard let container = self.parent as? ContainerController<Activity> else {
            self.stop()
            return
        }

        container.dismiss(animated: true, completion: {
            self.stop()
        })
    }
}

extension Activity {
    class Container: ContainerView<Activity> {
        override func spacer<T>(_ view: T) -> Spacer where T : UIView {
            let contentView = UIView()

//            let fadeView = UIView()
//            fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.075)
//            contentView.addSubview(fadeView)
//            fadeView.snp.makeConstraints { $0.edges.equalTo(0) }

            let center = Content.Center(view)
            contentView.addSubview(center)
            center.snp.makeConstraints { $0.edges.equalTo(0) }

            center.layer.shadowOffset = .init(width: 1, height: 2)
            center.layer.shadowOpacity = 0.1
            center.layer.shadowRadius = 3

            return .init(contentView, spacing: 0)
        }
    }
}


public extension Activity {
    enum Size {
        case small
        case medium
        case large

        fileprivate var factor: CGFloat {
            switch self {
            case .small:
                return 1
            case .medium:
                return 1.5
            case .large:
                return 2
            }
        }
    }
}

public extension Activity {
    enum Mode {
        case forever
        case until(TimeInterval)
    }
}

extension Activity: ViewControllerType {
    public var content: ViewControllerMaker {
        return .dynamic { [weak self] in
            let container = Container(in: $0, loadHandler: { self })
            $0.view.addSubview(container)
            container.snp.makeConstraints { $0.edges.equalTo(0) }
        }
    }
}
