//
//  ViewSharedContext.swift
//  Pods-UIContainer_Tests
//
//  Created by brennobemoura on 25/09/19.
//

import Foundation
import UIKit

open class ActivityView: View {

    private weak var contentView: UIView!
    public private(set) var size: Size = .medium

    private weak var stackView: UIStackView!
    weak var activityView: UIActivityIndicatorView!
    public private(set) weak var titleView: UILabel?
    private weak var contentTitleView: UIView?

    public private(set) var mode: Mode = .forever

    public weak var blur: BlurView!
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
        let rounder = RounderView(contentView, radius: 5)
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
        let blur = BlurView(dynamicBlur: .init(dynamic: {
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
        let scroll = ScrollView(stackView, axis: .vertical)

        self.contentView.addSubview(scroll)
        scroll.snp.makeConstraints { $0.edges.equalTo(0)}
        self.stackView = stackView
    }

    public func setContentViews(_ views: [UIView]) {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            self.stackView.addArrangedSubview($0)
        }
    }

    open func defaultContentViews() -> [UIView] {
        let activity = UIActivityIndicatorView(style: {
            #if os(iOS)
            return .gray
            #endif

            #if os(tvOS)
            return .white
            #endif
        }())
        let titleLabel = UILabel()

        activity.transform = .init(scaleX: self.size.factor, y: self.size.factor)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        [activity, titleLabel].forEach {
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            $0.setContentHuggingPriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .vertical)
            $0.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        self.activityView = activity
        self.titleView = titleLabel

        return [SpacerView({
            let content = ContentView.Center(activity)
            activity.snp.makeConstraints {
                $0.leading.trailing.equalTo(0).priority(.high)
                $0.top.equalTo(0).priority(.high)
            }
            return content
        }(), spacing: 30), {
            let spacer = SpacerView({
                let content = ContentView.Center(titleLabel)
                titleLabel.snp.makeConstraints {
                    $0.leading.trailing.equalTo(0).priority(.high)
                    $0.width.lessThanOrEqualTo(200)
                }
                return content
            }(), top: 0, bottom: 15, leading: 15, trailing: 15)
            spacer.isHidden = true
            self.contentTitleView = spacer
            return spacer
        }()]
    }

    public func setText(_ text: String?) {
        guard let text = text, !text.isEmpty else {
            self.contentTitleView?.isHidden = true
            return
        }

        self.titleView?.text = text
        self.contentTitleView?.isHidden = false
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
        controller.modalTransitionStyle = {
            #if os(iOS)
            return .partialCurl
            #endif
            #if os(tvOS)
            return .coverVertical
            #endif
        }()
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

        guard let container = self.parent as? ContainerController<ActivityView> else {
            self.stop()
            return
        }

        container.dismiss(animated: true, completion: {
            self.stop()
        })
    }
}

extension ActivityView {
    class Container: ContainerView<ActivityView> {
        override func spacer<T>(_ view: T) -> SpacerView where T : UIView {
            let contentView = UIView()

//            let fadeView = UIView()
//            fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.075)
//            contentView.addSubview(fadeView)
//            fadeView.snp.makeConstraints { $0.edges.equalTo(0) }

            let center = ContentView.Center(view)
            contentView.addSubview(center)
            center.snp.makeConstraints { $0.edges.equalTo(0) }

            center.layer.shadowOffset = .init(width: 1, height: 2)
            center.layer.shadowOpacity = 0.1
            center.layer.shadowRadius = 3

            return .init(contentView, spacing: 0)
        }
    }
}


public extension ActivityView {
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

public extension ActivityView {
    enum Mode {
        case forever
        case until(TimeInterval)
    }
}

extension ActivityView: ViewControllerType {
    public var content: ViewControllerMaker {
        return .dynamic { [weak self] in
            let container = Container(in: $0, loadHandler: { self })
            $0.view.addSubview(container)
            container.snp.makeConstraints { $0.edges.equalTo(0) }
        }
    }
}
