# iOS Tech Interview

[https://www.youtube.com/watch?v=56ZO6Gg68tw](https://www.youtube.com/watch?v=56ZO6Gg68tw)

[Take Home Project](https://seanallen.teachable.com/p/take-home)

- Automatic Reference Counter & Retain Cycles & Memory Leak
    - ARC - With a counter for # of strong references; When it counts to 0, it will automatically deallocate the memory for you.

        [https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html)

        - Video

            [https://www.youtube.com/watch?v=1LnipXiSrSM](https://www.youtube.com/watch?v=1LnipXiSrSM)

        - Q: What situation could cause memory issues?

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_1.52.07_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_1.52.07_PM.png)

            1. load a lots of tableview cells without optimizing
            2. [Orphans - Memory leak]Can't free (deallocate) the old one, but still allocate a new one - caused by retain cycle
            3. The reference I'm looking for are NULL
        - Q: What type of data could cause retain cycle?
            - Class reference :  when you define a class has a member of another class
            - Delegate Protocol: when you define a protocol in a class base
        - Q: How to find memory leaks on Xcode?

            Clean the project first then, run an instrument by Product→Profile→Leaks, then you can view leak cycles

        - For every object, it's keeping a counter on how many strong references are pointing to that object.
        - For example, I have a person class Shawn; There is also a Camera class, MacBook class and Phone class. If all these classes have a strong reference pointing back to Shawn, so the automatic reference counting is going to say the count is 4. if I try to set Shawn equal to nil and try to get rid of Shawn from memory, automatic reference counting won't allow it, Shawn **will not be released from Memory because there's three other objects pointing back to it**.
        - SOL: we need to make those Strong references a weak reference.
            1. Find the child component
            2. Set child to parent as a weak reference instead of Strong reference

            Important: a weak or unowned reference does **NOT** increment the reference count.

        - Code Example

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_11.51.32_AM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_11.51.32_AM.png)

            ```swift
            class Person {
            	let name: String
            	var macbook: MacBook?

            	init(name: String, macbook: MacBook?) {
            		self.name = name
            		self.macbook = macbook
            	}
            	
            	deinit {
            		print("\(name) is being deinitialed")
            	}
            }

            class MacBook {
            	let name: String
            	var owner: Person?

            	init(name: String, owner: Person?) {
            		self.name = name
            		self.owner = owner	
            	}
            	
            	deinit {
            		print("Macbook named \(name) is being deinitialized")
            	}
            }

            //===main====
            class ViewController: UIViewController {
            	var sean: Person?
            	var matilda: MacBook?

            	override func viewDidLoad() {
            		super.viewDidLoad()
            		createObjects()
            		assignProperties()
            	}

            	func createObjects() {
            		sean = Person(name: "Sean", macbook:nil)
            		matilda = MacBook(name: "Matilada", owner: nil)

            		//SUCCEED
            		//sean = nil
            		//matilada = nil
            	}

            	func assignProperties() {
            		sean?.macbook = matilda
            		matilda?.owner = sean

            		//FAILED - Retain Cycle
            		//due to sean has a strong reference to matilda
            		//matilda has a strong reference to sean
            		sean = nil
            	}
            }

            //Fix:
            //make MacBook has a weak reference to Person
            weak var matilda: MacBook?
            ```

        - Solution for Code Example

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_11.53.48_AM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_11.53.48_AM.png)

            ```swift
            class Person {
            	let name: String
            	var macbook: MacBook?

            	init(name: String, macbook: MacBook?) {
            		self.name = name
            		self.macbook = macbook
            	}
            	
            	deinit {
            		print("\(name) is being deinitialed")
            	}
            }

            class MacBook {
            	let name: String
            	weak var owner: Person? //<-------- here is the fix

            	init(name: String, owner: Person?) {
            		self.name = name
            		self.owner = owner	
            	}
            	
            	deinit {
            		print("Macbook named \(name) is being deinitialized")
            	}
            }

            //===main====
            class ViewController: UIViewController {
            	var sean: Person?
            	var matilda: MacBook?

            	override func viewDidLoad() {
            		super.viewDidLoad()
            		createObjects()
            		assignProperties()
            	}

            	func createObjects() {
            		sean = Person(name: "Sean", macbook:nil)
            		matilda = MacBook(name: "Matilada", owner: nil)

            		//SUCCEED
            		//sean = nil
            		//matilada = nil
            	}

            	func assignProperties() {
            		sean?.macbook = matilda
            		matilda?.owner = sean

            		//SUCCEED - matilda is not holding anymore
            		sean = nil //matilda's owner is nil after this line
            		matilda = nil

            		//FAILED when the other way around
            		//matilda = nil
            		//sean = nil
            	}
            }

            ```

            - matilda is not holding the person as strong reference anymore, so you can release sean now.
            - However, **the order does matter**. Since sean has a strong reference to matilda. When we release matilda first without releasing sean, the counter for matilda's counter (originally was 2) still have 1 as sean was refereing to it. So when try matilda=nil, there's noting to do. So never release a child first.

    - **Retain cycle**: two object have a strong reference to each other, it gets into a loop and that count never gets to zero, it will call retain cycle or memory leak. A quick fix to this is to make one of **strong** reference to **weak** reference
    - Follow-up question: explain memory leaks in closures. Weak self vs unowned self

        [https://medium.com/@stremsdoerfer/understanding-memory-leaks-in-closures-48207214cba](https://medium.com/@stremsdoerfer/understanding-memory-leaks-in-closures-48207214cba)

        - Video

            [https://www.youtube.com/watch?v=GIy-qnGLpHU](https://www.youtube.com/watch?v=GIy-qnGLpHU)

        - Q: When will Swift remove a reference type from memory?

            Sol: When there are no more variables pointing to the reference type. Determined by ARC

        - Q: What is **strong**?

            代表着强引用，是默认属性。当一个对象被声明为 strong 时，就表示父层级对该对象有一个强引用的指向。此时该对象的引用计数会增加1

        - Q: What is **weak**?

            Child may or may not exist. Will not exist, if parent is removed from memory

            当对象被声明为 weak 时，父层级对此对象没有指向，该对象的引用计数不会增加1。它在对象释放后弱引用也随即消失。继续访问该对象，程序会得到 nil，不会崩溃

        - Q: What is **unowned**?
            - Child definitely exists all the time but is removed when parent is removed.
            - Unowned reference will NOT increase the reference count.
            - Unowned references ALWAYS have a value (not optional)
            - 与弱引用本质上一样。唯一不同的是，对象在释放后，依然有一个无效的引用指向对象，它不是 Optional 也不指向 nil。如果继续访问该对象，程序就会崩溃
        - Q: When to use **weak** or **unowned**?

            weak: when the reference can be become nil at some point in its lifetime. EX. 比如 delegate 的修饰

            unowned: when the reference will NEVER be nil once set. Ex. 比如 self 的引用

        - Closures are self-contained blocks of functionality that can be passed around and used in your code. A function without name can be passed around.

        ```swift
        var nameClosure = { print("My name is Rod") }
        nameClosure()
        callSomeCode(aClosure: nameClosure)
        ```

        - Closures can be assigned to properties
        - **Closures are reference type**, when we pass around, we pass around a pointer to it.

        ```swift
        popup.onSave = {(data) in
        	self.dateLabel.text = data
        }
        ```

        - This is how a retain cycle could happen on a closure

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.37.09_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.37.09_PM.png)

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.38.14_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.38.14_PM.png)

        - Introducing Capturing Values

            A nested function can **capture** any of its outer function's arguments and can also **capture** any constants and variables defined within the outer function.

            - Illustration

                ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.44.45_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.44.45_PM.png)

                - animate() can capture doAnimation()'s showLabel and text
                - But animate() cannot capture myLabel without **self** reference, as it belongs to UIViewController
                - Capturing values is done with Strong References

                    ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.47.18_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.47.18_PM.png)

                - We can pass my own values to the closure - Capture List syntax

                    ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.49.50_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.49.50_PM.png)

        - SOL: use captured values to solve - added weak or unowned to the captured variable

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.53.12_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.53.12_PM.png)

            for **[label = self.myLabel!] in** you can change it to **[weak label = self.myLabel!] in**

            Because once we get into the Capture List, it would be strong reference no matter what reference it was out side of the outer func

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.59.06_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.59.06_PM.png)

            ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.55.25_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.55.25_PM.png)

            The reason we use **unowned** here is because self won't be nil

            - More Syntax on Capture List

                ![iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.56.39_PM.png](iOS%20Tech%20Interview%20502f8fe0b5aa49058ef7f38ed8025aa8/Screen_Shot_2020-05-15_at_2.56.39_PM.png)

        - SOL2: set the popup to be a weak reference

            when looking at the image after this point, where I show the memory graph, you can break any one of those strong references to fix the retain cycle. In the previous video ([https://youtu.be/1LnipXiSrSM](https://youtu.be/1LnipXiSrSM)) I talked about the 2-Step method of fixing a retain cycle. It's up to the developer to determine who the parent and child classes are. So in this video, I was making the popup the parent and the onSave the child. But you could totally make the ViewController the parent and the popup the child. Both will work. The main thing is you need to create a break somewhere in the retain cycle between the 3 reference types.

        - Key to remember
            1. Closures are reference types
            2. Captured variables are **strong** references in closures
            3. Use Capture List to change variables to weak or unowned 

                **{[weak | unowned  xxx ] in ...}**

- Communication Patterns between views & when to use
    - Delegates Protocol
        - What is it?
            - **It is a delegate design pattern**, you should use keyword protocol. The **B**, whoever want to send a message to another view **A**, the view who would do stuff. **B** would need a reference to that **A**, and **B** knows all the information and it needs to specifically tell **A** what to do. **A** doesn't know what to do, it just wait for the order from **B**. After **A** received the order, **A** would just follow the order and do exactly what **B** told. There is only one channel between **B** and **A**.
            - required : the func must be implemented by Intern
            - optional: the func may or may not be implemented by Intern
        - **One to One** communication
            - One view communicates to another view.
            - Code Example

                if A has to go to B, B will let A know what to do, then when back to A, A will have the message. (A as Intern, B as Boss)

                ```swift
                //in A.swift
                class A: UIViewController {
                	@IBOutlet weak var goB: UIButton!

                	override func viewDidLoad() {
                        super.viewDidLoad()
                   }

                	@IBAction func goBTapped(_ sender: UIButton) {
                		let bVC = storyboard?.instantiateViewController(withIdentifier: "B") as! B
                        bVC.delegate = self //<--- set the B's delegate to A
                        present(bVC, animated: true, completion: nil)
                	}
                }

                extension A: messageDelegate {
                	func doAction(mess: String, value: Int) {
                		print("\(mess) + \(value)");
                	}
                }

                //------------------------------------------------------------------

                //in B.swift
                protocol messageDelegate {
                	func doAction(mess: String, value: Int)
                }

                class B: UIViewController {
                	var delegate: messageDelegate!
                	
                	override func viewDidLoad() {
                        super.viewDidLoad()
                    }
                	
                	//For Procedure C
                	@IBAction func let_A_Do_C(_ sender){
                		//let A know the message
                		self.delegate.doAction("any action you set up here: C", 1)
                		dismiss(animated: true, completion: nil)
                		//A should have the message already
                	}

                	//For Procedure D
                	@IBAction func let_A_Do_D(_ sender){
                		//let A know the message
                		self.delegate.doAction("any action you set up here: D", 2)
                		dismiss(animated: true, completion: nil)
                		//A should have the message already
                	}
                }
                ```

                - Explanation
                    - When you want **B** communicates to **A**, **B** should have a delegate links to **A**
                    - **B** calls the delegate.**func** to assign a job to **A**. 
                    **B** gives **A** raw materials, **A** has to finish all of specific steps.
                    - **A** should have the implementation of the **func** as the object to the delegate and **A** should have all implementation of that **protocol**. 
                    (Poor Intern~)

                - In case you want to know how to add a button programmatically

                    ```swift
                    override func viewDidLoad() {
                      super.viewDidLoad()

                      let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
                      button.backgroundColor = .green
                      button.setTitle("Test Button", for: .normal)
                      button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

                      self.view.addSubview(button)
                    }

                    @objc func buttonAction(sender: UIButton!) {
                      print("Button tapped")
                    }
                    ```

        - Things Should Be Aware of
            - Retain cycle could happen between Intern and Boss
                - Ideal : You should let you Intern has a strong reference to Boss and Boss has a weak reference to Intern. Only when you have a class-type protocol.
                - Explanation: If you declare your protocol as a class protocol, like `protocol SideSelectionDelegate: class', then you need to declare the delegate variable as 'weak' to avoid retain cycles. However, if don't declare your protocol as 'class' you're allowing your protocol to be adopted by **structs**, **which are value types**, and therefore don't really work with reference counting.
                - This blog post provides a good explanation: [https://useyourloaf.com/blog/quick-guide-to-swift-delegates/](https://useyourloaf.com/blog/quick-guide-to-swift-delegates/) .
        - pros
            - **A** has less code.
        - cons
            - There must be a reference from B to A, so that B can access to A and let A do something.
            - Details is exposed, as B tells exact steps about what A should do
        - Use Case - UITableView

            Seems like the func in protocol are called once. 
            In tableview, cellForRowAt indexpath

            ```swift
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            		let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
                cell.textLabel!.text = menu[indexPath.row]
                return cell
            }
            ```

            where you are configuring your cell, that is getting called constantly as the user swapping up and down the tableview. Anytimes a new cell comes into view, cellForRowAt indexpath gets called.

        - Use Case - UIPickerView
    - Observer Notifications
        - What is it?
            - **Observer mode**: You have the observer, just sitting somewhere in your code and waiting for the notification (An event happened) - when that event happens, it will fires off a message. Once the observer hear that message, it execute the code
            - You have a notifier to trigger the event to happen.
            - One observer can receive many types of notification.
            - 可以跨层传递消息
                - app层有：数据层，网络层，业务逻辑层，ui层
                - 一般处理逻辑由网络层传递给数据层经过业务逻辑层加工再去更新ui
                - 有些情况是网络返回的数据可能要不经过业务逻辑层，直接到ui层
        - **One to Many**: you can have one observer, 10 to many different areas notify that observer
        - Code Example
            - B as Boss want to send message to A Intern

            ```swift
            //in A.swift Intern

            let messageCNotificationKey = "com.AB.C"
            let messageDNotificationKey = "com.AB.D"

            class A: UIViewController {
            	@IBOutlet weak var goB : UIButton!

            	let C = Notification.Name(rawValue: messageCNotificationkey)
            	let D = Notification.Name(rawValue: messageDNotificationKey)
            	
            	deinit {
            		NotificationCenter.default.removeObserver(self)
            	}
            	
            	override func viewDidLoad() {
                    super.viewDidLoad()
                    createObservers()
              }
            	
            	func createObservers() {
                    
                    //C
                    NotificationCenter.default.addObserver(self, selector: #selector(A.presentMessage(notification:)), name: C, object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(A.presentValue(notification:)), name: C, object: nil)
                    
                    //D
                    NotificationCenter.default.addObserver(self, selector: #selector(A.presentMessage(notification:)), name: D, object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(A.presentValue(notification:)), name: D, object: nil)
                }

            		@objc func presentMessage(notification: NSNotification) {
            				let isC = notification.name == C
            				if(isC) {
            					print("doing C")
            				} else {
            					print("doing D")
            				}
            		}
            		
            		@objc func presentValue(notification: NSNotification) {
            				let isC = notification.name == C
            				if(isC) {
            					print(1)
            				} else {
            					print(2)
            				}
            		}

            		@IBAction func goBTapped(_ sender: UIButton) {
            				//there isn't anything you need to set up for notificaiton
                    let selectionVC = storyboard?.instantiateViewController(withIdentifier: "B") as! B
                    present(selectionVC, animated: true, completion: nil)
            				
                }
            }

            //----------------------------------------------------------------------

            //In B.swift Boss
            class B: UIViewController {
            		override func viewDidLoad() {
                    super.viewDidLoad()
                }
            		
            		@IBAction func let_A_Do_C(_ sender: UIButton) {
            			let name = Notification.Name(rawValue: C)
            			NotificationCenter.default.post(name: name, object: nil)
                  dismiss(animated: true, completion: nil)
            		}

            		@IBAction func let_A_Do_D(_ sender: UIButton) {
            			let name = Notification.Name(rawValue: D)
            			NotificationCenter.default.post(name: name, object: nil)
                  dismiss(animated: true, completion: nil)
            		}
            }
            ```

            - A would be the observer response to particular type (it doesn't require to make a link to B like what we did in delegate protocol)
                - A has to create notification type (C and D)
                - A has to attach notification listener (addObserver) for both type C and type D
                - if B has a set of steps wants A to do, A has to add with a number of (# of steps *  # of types of protocol ) observers to itself.
            - B doesn't send raw material to A, A has to prepare everything for itself.
                - A has to be clear how many types of notification and what raw material should be prepared. Response to it (Personally feel it's not even better than Strategy Design Pattern)
                - A **encapsulate** the details
            - When A deallocate itself, make sure you remove the observer attached to A.
            - When B send notification to A, B should know the exact same notification name as it's defined in A.

        - Things Should Be Aware of
            - You must remove your observers in init for Intern
        - pros
            - **A** **encapsulate** details of what to do after received the notification
            - There isn't requires a link from **B** to **A**, as long as get the public notification key
        - cons
            - Messy code - hard to keep track of: 10 to 20 notifications spread out all throughout your code all pointing to one observer which cause timing issues when it lose control of which send the notification call.
            - **B** has to exactly know **A**'s notification key
                - In order to improve this, you can create an extension of Notification.Name

                ```swift
                extension Notification.Name {
                	static let testName = Notificaiton.Name("testName")
                }

                //Use case
                NotificationCenter.default.post(name: .testName, object: nil, userInfo: nil)
                ```

            - Since **A** encapsulate the details, so there could be a lot of procedure that **A** should do
            - Requires a clean up before iOS 9: A needs to remove observers - could cause confusions
                - iOS 9, it is no longer necessary for an NotificationCenter observer to un-register itself when being deallocated.
    - When to use each?
        - delegate: 
        a tight coupling , a one-to-one communication between two views
        - notification: 
        Want to communicate to many objects in one action; 
        You want to let your network layer directly talk to UI (by skipping model and controller)
- Concurrency & Threading - Grand Central Dispatch & NSOperation Queues & NSThread
    - Concurrency : Doing multiple tasks at the same time
        - Quad core processor
        - The more core you have the more tasks you can do at the same time
    - thread: all the tasks are being executed on are called threads
        - Abstract Example: a thread is like a highway and a car is like a task.
    - Lock
        - **deadlock**: 由串行队列（serial）执行同步（sync）操作，引起的循环等待 - 相互等待； 指两个或两个以上的线程，它们之间互相等待彼此停止执行，以获得某种资源，但是没有一方会提前退出的情况。
        - Type
            - @synchronized: create singleton object
            - atomic
                - it's a keyword
                - 对被修饰对象进行原子操作(不负责使用)
            - OSSpinLock
                - 循环等待询问，不释放当前资源
                - 用于轻量级数据访问，简单的int值 +1/-1操作
            - NSRecursiveLock ：比NSLock的优势是可以重入
            - NSLock
                - lock
                - unlock
            - dispatch_semaphore_t
    - **Race condition**
        - If a condition requires a task should be finished before another task. - 写操作需要在读操作之前，结果读操作先于写操作，因此读到了错误的信息。
        - 指两个或两个以上线程对共享的数据进行读写操作时，最终的数据结果不确定的情况。
        - Will happen on Async (serial & concurrent)
    - **Main thread** : where UI is done, keep it tight and make it speedy.
        - What should be aware of?
            - Don't let main thread do all heavy work, otherwise, the UI will freeze.
    - **Background thread**: do all heavy stuff
    - Grand Central Dispatch (GCD) & NSOperation Queues & NSThread
        - API built on top of this threading to make development process easier - managing threads for us. A queue of tasks give that to Grand Central Dispatch and it just handles all the thread management stuff for.
        - **Grand Central Dispatch**
            - Queue: First In First Out & serial vs concurrent
                - Serial: One task is finished then start another one in order - in a line - only one thread
                    - pros
                        - Predictable Execution Order
                    - Cons
                        - Slower
                    - Use Case: Main thread is using Serial Queue
                - Concurrent: a task starts doesn't have to wait another task to be finished.
                    - pros
                        - Faster
                    - cons
                        - Unpredictable order
                    - Use Case: Background
                - By Default, every app gets 1 serial queue for main thread and 4 concurrent queues for background thread
                - How to Switch Between Queues
                    - Move Backend to Main (Common)

                        ```swift
                        DispatchQueue.main.async {
                        	self.tableView.reloadData()
                        }
                        ```

                        - Use case: you are downloading data at the backend thread and once it's finished you want to update your tableview, you need to shift to a main thread (UI thread)
                        - Dispatching the background thread to the main thread
                    - Move Main to Backend

                        ```swift
                        DispatchQueue.global(qos: .background).async {
                        	// Code to run on background queue
                        }
                        ```

            - Use Case: 同步/异步， 串行/并发
                - 同步串行：dispatch_sync(serial_queue), 死锁
                    - 容易出现的问题： 死锁

                        ```swift
                        override func viewDidLoad() {
                        	dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                self.doSomething()
                           })
                        }
                        ```

                        - One the main queue, you put viewDidLoad first and then the doSomething block. When viewDidLoad is over, the doSomething block will start.
                        - In the code, viewDidLoad will wait until doSomething block to be finished, then it will end the execution.
                        - but doSomething block will start only when viewDidLoad end the execution.
                        - As a result, viewDidLoad waits doSomething to be called and doSomething waits viewDidLoad to be done. It's a **deadlock**.
                        - 没有问题的代码是下面这样

                        ```swift
                        //serial_queue() is a self-defined serial queue
                        override func viewDidLoad() {
                        	dispatch_sync(serial_queue(), {()->Void in
                        		self.doSomething()
                        	})
                        }
                        ```

                        - As long as viewDidLoad and doSomething are in different (serial) queue, it would be fine.

                - 异步串行：dispatch_async(serial_queue)
                - 同步并行：dispatch_sync(concurrent_queue)

                    ```objectivec
                    //global_queue is a concurrent queue
                    -(void)viewDidLoad{
                    	NSLog(@"1");
                    	dispatch_sync(global_queue, ^{
                    		NSLog(@" 2");
                    		dispatch_sync(global_queue, ^{
                    			NSLog(@" 3");
                    		});
                    		NSLog(@" 4");
                    	});
                    	NSLog(@" 5");
                    }

                    //1 2 3 4 5
                    ```

                    - if global_queue was replaced by a self defined serial queue in both places, there would be a deadlock.
                - 异步并行:   dispatch_async(concurrent_queue)
                    - 例题1

                        ```objectivec
                        - (void)viewDidLoad {
                        		dispatch_async(global_queue, ^{
                        				NSLog(@"1");
                        				
                        				[self performSelector:@selector(printLog)
                        									 withObject:nil
                        									 afterDelay:0];
                        				NSLog(@" 3");
                        		});
                        }

                        -(void)printLog{
                        		NSLog(@" 2");
                        }

                        //result print: 1 3

                        //since the async block will be thrown into a thread pool
                        //and thread pool doesn't have runloop
                        //perforSelector..with afterDelay needs runloop
                        //performSelector will not be executed.
                        ```

            - dispatch_group_async()
                - A,B,C 三个任务并发，完成后执行任务D
                - Example: 并行下载多个图片，所有图片下完后再通知主程序“下载成功”
                    - 代码

                        ```objectivec
                        -(id)init {
                        	self = [super init];
                        	if(self) {
                        		//create concurrent queue
                        		concurrent_queue = dispatch_queue_create("concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
                        		arrayURLs = [NSMutableArray array];
                        	}

                        	return self;
                        }

                        -(void)handle {
                        	//create a group
                        	dispatch_group_t group = dispatch_group_create();

                        	//use a forloop to iterate the execution for each element
                        	for(NSURL * url in arrayURLs) {
                        		
                        			//send jobs to concurrent queue
                        			dispatch_group_async(group, concurrent_queue, ^{
                        						//download the image based on url
                        						NSLog(@"url is %@", url);
                        			});
                        	}

                        	dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                        			//Every job is finished in the group
                        			NSLog(@"all the images has finished downloading");		
                        	});

                        }
                        ```

            - dispatch_barrier_async() - (参考中文iOS视频)
                - read more write less 多读单写
            - When to use?

                简单的线程同步 - 子线程多派，多读单写

                图片异步加载

                网络请求

        - **NSOperation** - NSOperationQueue
            - pros
                - Add/remove dependency for a job
                - Get control of job status
                    - isReady
                    - isExecuting
                    - isFinished
                    - isCancelled
                - Be able to set the maximum count of concurrent threads
            - When to be removed?

                KVO

            - When to use?

                AFNetworking, SDWebImageView

        - NSThread - pthread_t
            - start - 可以最大限度的掌控每一个线程的生命周期。但是同时也需要开发者手动管理所有的线程活动
                - check a list of exception
                - pthread_create: create a thread
                    - launcher
                        - t
                        - notify t is started
                        - set up name
                        - call main [t main] - runloop
                            - check exception
                            - selector
                        - exit
            - When to use?

                长度线程

        - Runloop
- ViewController LifeCycle
    - Video

        [https://www.youtube.com/watch?v=d7ZqxvbiTyg](https://www.youtube.com/watch?v=d7ZqxvbiTyg)

    - Called automatically by system
    - Begin Life
        - viewDidLoad
            - Get called the very first time, when the content view is created into memory or loaded from the storyboard, and it's **only called once**.
            - Where your outlets will have a guaranteed value in view did load
            - Use case: when a view controller shows up for the first time
        - viewWillAppear
            - Just get called before the content view **is added to app's view hierarchy**, the view might not **appear*** (*: Doesn't means it should show on the screen, if your view's hidden or there is a view on the top of that view); So it gets called every time before the view comes back to the screen.
            - Use Case

                You are in a navigation controller a master-detail view, and you keep going to the details back to the master back and forth. **viewDidLoad** is not gonna keep getting called but **viewWillAppear** will keep getting called. if you have something you need to do every time the view appears such as an animation, do it in **viewWillAppear**

        - viewDidAppear
            - Called after the content view is added to app's view hierarchy; could be potentially showing up on your screen.
            - Means the view is completely loaded
            - Use Case
                - starts an animation
        - viewWillLayoutSubviews
            - Called when the content view's **bounds change (**includes subview's constraints the size.**)**, but **BEFORE** all the subview's has been laid out.
            - Use Case
                - When you rotate your phone, it will change a view from portrait to landscape.
        - viewDidLayoutSubviews
            - Called when the content view's bounds change, but **AFTER** all the subview's has been laid out.
    - End Life
        - viewWillDisappear
            - Called before the content view is removed from the app's view hierarchy. Which I can do stuff right before the view disappear
            - Use Case
                - User could want to save something first before the view dismisses.
        - viewDidDisappear
            - Called after the content view is removed from the app's view hierarchy. If the view did disappear, it will let you know the view is gone
- Classes vs Structs & when to use them?
    - class
        - It is a **reference** type that if you change a property on that class you are actually going to change the reference
        - Operation on Heap - (Time consumping than Stack)
        - pros
            - Inheritance: Allows subclass to inherit everything from that parent class - 这样子类可以使用父类的特性和方法
            - 类型转换可以在 runtime 的时候检查和解释一个实例的类型；
            - 可以用 deinit 来释放资源；
            - 一个类可以被多次引用。
        - cons
            - heavy
    - struct - (Recommended by Apple)
        - It is a **value** type that essentially creates a copy of that objects are not overwriting  other properties
        - Operation on Stack
        - pros
            - lightweight and clean - better performance
            - 相比于一个 class 的实例被多次引用更加安全
            - 无须担心内存 memory leak 或者多线程冲突问题
        - cons

            Can't inheritance

- Frame vs Bounds
    - Frame
        - Position( coordinate) relative to its parent view, with width & height
        - Smallest the bounding box around view
    - Bounds
        - Position relative to its own coordinate system.
    - Follow up
        - When are those the same? - when the view is either in absolute vertical or horizontal.
        - When are those different? - when a UIView is rotated, the bounding box of UIView is changed → the frame of UIView has been changed.
- Filter, Map & Reduce
    - Filter: if you want to filter an array out all the even numbers in an array you can do that.
    - Map: if you want to apply like a transform to every object in the array; if you want to multiply every number by three you would use map
    - Reduce: summing up the numbers in an array
- App ID vs Bundle ID
- Testing
    - learn how to build testing suites and some of my existing projects
- Error Handling - Do, Try, Catch
- What's your Apple framework to work with?
    - CoreData.framework : database
    - CoreLocation.framework: 定位
    - MapKit.framework: 地图
    - CoreAnimation.framework: 动画
    - AddressBook.framework： 通讯录
    - AVFoundation.framework： 流媒体
    - CFNetwork.framework： 网络通信（套接字）
    - CoreTelephony.framework： （核心通讯框）打电话
    - CoreText.framework： 图文编排
    - GameKit.framwork：实现蓝牙的相互通信，即使服务端，又是客户端
    - HealthKit.framework： 分离数据收集，数据处理和社会化（苹果主推健康数据处理）
    - Security.framework：网络安全框架（加密，秘钥）
    - Social.framework： 社会化分享（新浪，微信，qq）
    - OpenAL.framework：播放音频流
    - MessageUI.framework： 发短信，发邮件
    - NewsstandKit.framework：后台下载，推送
- Third Party Library
    - cocoapods
    - Carthage
    - SwiftPackage Manager

        Just help you keep updating the swift version for your project.

    - PureLayout
        - pros
        - cons
    - Alamofire
        - pros
        - cons
    - Charts
        - pros
        - cons
- Coding: Gesture Recognizers
    - tap gesture recognizer
    - pan gesture recognizer
- Coding: Networking
    - Get to authenticate in the server
    - Gather all the API information to the endpoint
    - Build the url with the proper headers with authorization and make sure the body of the request was complete with the username password etc
    - Get the authenticate on the server
    - Return a token
- Coding: Debugging

    Just debug it by looking at it

    - race condition on network call
    - retained cycles memory leaks
    - UI not being updated on the main thread
- Coding: take a large Unit and break it into smaller units
    - Question: Break the big seconds into days, hours, minutes and seconds
    - Modulo Operator: gives you the remainder left, five modulo two is going to be 1
    - 64s → 64%60 = 4 → 1 minus , 4 seconds
- Coding: take home projects
    - networking
    - building a tableview
    - build a ui to a design spec based on Sketch
    - persistence, animation
    - Build a login flow purely by programmatic UI, no storyboard for auto layout