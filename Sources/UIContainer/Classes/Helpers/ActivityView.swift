//
// Copyright (c) 2019-Present Umobi - https://github.com/umobi
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit
import ConstraintBuilder

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
        AddSubview(self).addSubview(rounder)

        Constraintable.activate(
            rounder.cbuild
                .edges
        )

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

        AddSubview(self.contentView).addSubview(blur)

        Constraintable.activate(
            blur.cbuild
                .edges
        )

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        let scroll = ScrollView(stackView, axis: .vertical)

        AddSubview(self.contentView).addSubview(scroll)

        Constraintable.activate(
            scroll.cbuild
                .edges
        )

        self.stackView = stackView
    }

    public func setContentViews(_ views: [UIView]) {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            AddSubview(self.stackView)?.addArrangedSubview($0)
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

            Constraintable.activate(
                activity.cbuild
                    .leading
                    .trailing
                    .priority(.defaultHigh),

                activity.cbuild
                    .top
                    .priority(.defaultHigh)
            )

            return content
        }(), spacing: 30), {
            let spacer = SpacerView({
                let content = ContentView.Center(titleLabel)

                Constraintable.activate(
                    titleLabel.cbuild
                        .leading
                        .trailing
                        .priority(.defaultHigh),

                    titleLabel.cbuild
                        .width
                        .lessThanOrEqualTo(200)
                )

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
        AddSubview(view).addSubview(container)

        Constraintable.activate(
            container.cbuild
                .edges
        )

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

            let center = ContentView.Center(view)
            AddSubview(contentView).addSubview(center)

            Constraintable.activate(
                center.cbuild
                    .edges
            )

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
            AddSubview($0.view).addSubview(container)

            Constraintable.activate(
                container.cbuild
                    .edges
            )
        }
    }
}
