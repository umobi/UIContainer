# UIContainer

[![CI Status](https://img.shields.io/travis/brennobemoura/UIContainer.svg?style=flat)](https://travis-ci.org/brennobemoura/UIContainer)
[![Version](https://img.shields.io/cocoapods/v/UIContainer.svg?style=flat)](https://cocoapods.org/pods/UIContainer)
[![License](https://img.shields.io/cocoapods/l/UIContainer.svg?style=flat)](https://cocoapods.org/pods/UIContainer)
[![Platform](https://img.shields.io/cocoapods/p/UIContainer.svg?style=flat)](https://cocoapods.org/pods/UIContainer)

## Installation

UIContainer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UIContainer'
```

# macOS support

The actual development stage of this lib for macOS hasn't been tested yet.

## Definitions
----

#### 1. UIContainer
The UIContainer protocol is the main core of each container created. Every UIView can hold another UIView or UIViewController. Using containers, you won't be worried if you are doing the right thing to show any content on screen. UIContainer is a generic protocol that can be extended to allow other views to be some container for something. Each container should be from type ContainerBox, but you can create your container and your container box, there is no rule for that.

The methods developed for any UIContainer are:

- `ParentView`: UIViewController
- `View`: AnyObject
- .prepareContainer(inside parentView: ParentView!, loadHandler: (() -> View?)?)
- .removeContainer()
- .insertContainer(view: View!)
- .prepare(parentView: ParentView!)
- .loadView<T: UIView>(_ view: T) -> UIView
- .containerDidLoad()
- .init(in parentView: ParentView!, loadHandler: (() -> View?)?)

With this in mind, you can start creating your container classes and using them. We already developed the Container for UIViewControllers and ContainerView for UIView. Some derivated classes will be shown here for Cells, not totally implemented, and Storyboard's outlet.

#### 1.a) ContainerViewParent

This protocol is important because all containers need to know the parent view controller that is the root of the leaf in the call stack.

Let's start with the top viewController. The first view controller that should exist in any app is the `UIWindow.rootViewController`, this is the only one obligated by UIKit. So, pretend that the root class is WindowViewController, now all UIView inside the container presented inside WindowViewController will hold the WindowViewController as parent. 

If you have windowViewController with `containerA<UIView>` with `containerB<UIViewController>` with `containerC<UIView>`, this means that containerA and containerB will have the parent view controller as WindowViewController and containerC will have the containerB.UIViewController as its parent.

The ContainerViewParent permits that you keep some reference or a possible parent, but that doesn't mean that will be the right parent, because sometimes the parent is the "superview".

#### 1.c) NibView and View

We have two types of views that should be defined here. The first one is the views created using .xib files, and the second one is the views created by code. UIKit doesn't implement the right code for these cases and maybe Apple believes that these are different things. With a little study and for a better approach, we decided to create the `NibView` and the `View`. They are very similar, but the nib one has the `@IBOutlet weak var view: UIView!` as normally used as contentView by other developers. In the end, the life cycle is the `.init` and the `prepare` function.

You should remember that both views have the prepare function that is called during the instanciated process. This means that parent or superview doesn't have a reference for it.

#### 1.d) ContainerView<View: UIView & ContainerViewParent> and Container<View: UIViewController>.

These classes are made to create views or view controllers. Here goes some examples:

The first case is for UIView:

```swift
import UIKit
import UIContainer

class ExampleViewController: UIViewController {
    weak var containerView: ContainerView<CartView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = ContainerView<CartView>(in: self) // Will be explained
        self.view.addSubview(containerView)
        
        self.containerView = containerView
    }
}
```

The other case is using Container for UIViewController

```swift
import UIKit
import UIContainer

class ExampleViewController: UIViewController {
    weak var containerView: Container<CartViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = Container<CartViewController>(in: self) // Will be explained
        self.view.addSubview(containerView)
        
        self.containerView = containerView
    }
}
```

Now, the only option that I prefer is creating a subclass inside my view and use it in the view controller

```swift
import UIKit
import UIContainer

class CartView: View {
    
    override func prepare() {
        super.prepare()
        
        // Do stuff here
    }
}

extension CartView {
    class Container: ContainerView<CartView> {        
        override func containerDidLoad() {
            super.containerDidLoad()
            
            // Stylize your container
        }
    }
}

class ExampleViewController: UIViewController {
    weak var cartView: CartView.Container!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cartView = CartView.Container(in: self) // Will be explained
        self.view.addSubview(cartView)
        
        self.cartView = cartView
    }
}
```

Remember that Container and ContainerView have the same methods and life cycle. The containerDidLoad is called after the cycle end, and the container has mounted the view inside itself, but it has not been presented inside the parent view yet.

### 2. UIContainerCell

This protocol is a wrapper over UIContainer that helps creating cells for your tables. It is not totally implemented because we have other cases like UICollectionViewCell that aren't tested, but you can try it using ContainerCollectionViewCell.

The magic here is that UIContainerCell already implements the obligated methods for classes that implement this protocol. When you are at **tableView.dequeueReusableCell** you should call **cell.prepareContainer(inside: self)**, remember that your cell should be UIContainerCell derivated.

The prepareContainer prevents that your view will be recreated and keeps safe as reusable cell. This is important if you use the reactive library and have **DisposeBag** inside your view. 

There are two classes, one is for UIView and the other is for UIViewController. The first one is ContainerTableViewCell and the second one is ContainerTableCell. They have the same methods and call stack.

So, your view that was used as UITableViewCell is now only UIView, how can you do that? Here goes one example:

```swift
import UIKit
import UIContainer

class CartView: View, ContainerCellDelegate {
    override func prepare() {
        super.prepare()
        
        self.applyLayouts()
        self.configureButtons()
    }
    
    func reloadView(_ cart: Cart) {
        self.titleLabel.text = cart.name;
        
        self.onPlayTouch = {
            cart.startRunning()
        }
        
        self.onStopTouch = {
            cart.stopRunning()
        }
    }
}

class CartsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(ContainerTableViewCell<CartView>.self, forCellReuseIdentifier: "CartViewCellIdentifier")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartViewCellIdentifier", for: indexPath) as! ContainerTableViewCell<CartView>
        
        cell.prepareContainer(in: self)
        cell.view.reloadView(carts[indexPath.row])
        
        return cell
    }
}
```

#### 2.a) ContainerCellDelegate

Notice the ContainerCellDelegate conformance in CartView superclass types. The ContainerCellDelegate is a helper for us because the UIView can be used as a cell or not if you are creating it as the ContainerView example.

The ContainerCellDelegate has two behaviors and it adds cellDelegate: Delegate associated type to the views. The first behavior is if you don't specify adding the line `var cellDelegate: Delegate?` inside your view class. What happens? The ContainerCellDelegate understands that you didn't specify the cell delegate and associate the EmptyCellDelegate to your class. Notice if you type "self.cellDelegate" the type would be EmptyCellDelegate?.

### 3. UIContainerStoryboard

This is a protocol created for cases when you want to add your view inside the other view using storyboard or .xib. You need to implement its storyboard view and provides some methods to help during initialization. Here some example:

```swift
import UIKit
import UIContainer

class CartViewStoryboard: View, UIContainerStoryboard {
    typealias View = CartView
    weak var containerView: ContainerView<CartView>!
    
    var edgeInsets: UIEdgeInsets = .init(top: 15, left: 15, bottom: 15, right: 15)
    
    func containerDidLoad() {
        // stylize the container
    }
}

class ExampleViewController: UIViewController {
    @IBOutlet weak var cartWrapper: CartViewStoryboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cartWrapper.prepareContainer(inside: self)
    }
}
```

### 4. ContainerController

ContainerController helps by creating conforming views as UIViewController. You only need to conform your view with the ViewControllerType protocol and implement the content: ViewControllerMaker { get } using the ViewControllerMaker.dynamic(_: (UIViewController) -> Void).

After that, you should create the UIViewController instance using the ContainerController.init(_: View) where View conforms with ViewControllerType.

### 5. WindowContainer<Provider: WindowContainerType>

The WindowContainer is our latest new feature that may change over some updates. It only works with the fade effect developed with no classes or special methods.

To use this you have to implement the WindowContainerType in your project and implement the launcher static function and container getter. To set the window at AppDelegate class, you should call the `UIWindow.container(WindowContainerType.self)`. Here goes one example:

```swift
import UIKit
import UIContainer

enum WindowType {
    case main
}

extension WindowType: WindowContainerType {
    var container: UIView! {
        switch self {
        case .main:
            return Container(in: AppDelegate.shared.windowView) {
                MainViewController.shared // Provided by ViewSharedContext
            }
    }
    
    static func launcher(in windowContainer: WindowContainer<WindowType>) -> UIView! {
        return Container(in: windowContainer) {
            UIViewController.laucherViewController()
        }
    }
}
```

Now, the AppDelegate:

```swift
import UIContainer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var windowView: WindowContainer<WindowType> {
        return window!.rootViewController as! WindowContainer<WindowType>
    }
    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     
        self.window = UIWindow.container(WindowType.self)
        self.window?.makeKeyAndVisible()
        self.windowView.transition(to: .main)
        
        return true
     }
}
```
## Author

brennobemoura, brenno@umobi.com.br

## License

UIContainer is available under the MIT license. See the LICENSE file for more info.
