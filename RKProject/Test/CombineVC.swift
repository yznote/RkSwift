//
//  CombineVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/23.
//

import Combine
import UIKit

class CombineVC: RKBaseVC {
    private var rootView: CombineView {
        return view as! CombineView
    }

    override func loadView() {
        view = CombineView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // ui ctr 取消下面注释显示ui
        // rootView.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleL.text = "Flex&Combine"
        naviSubView.backgroundColor = .clear
        naviLineL.isHidden = true
        // comOne()
        // comTwo()
        // comThree()
        // ts1()
        // ts2()
        // ts3()
        // ts4()
        // ts5()
        // ts6()
        // ts7()
        // ts8()
        // ts9()
        // ts10()
        // ts11()
        // ts12()
        // ts13()
        // ts14()
        // ts15()
        // ts16()
        // ts17()

        // catch1()
        // catch2()
        // catch3()
        // catch4()
        // catch5()

        // operatorEvent1()
        // operatorEvent2()

        // publish1()
        // publish2()
        // publish3()
        // publish4()
        // publish5()
        // publish6()
        // publish7()
        // publish8()
        // publish9()
        // publish10()

        // aTs1()

        // bTs1()
        // bTs2()
        bTs3()
    }

    func bTs3() {
        // debounce：在指定时间窗口内，如果没有新的事件到达，才会发布最后一个事件。通常用于防止过于频繁的触发，比如搜索框的实时搜索。
        let searchText = PassthroughSubject<String, Never>()
        searchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { text in
                debug.log("Search request: \(text) at \(Date())")
            }.store(in: &cancelSet)

        // Simulate rapid input
        for (index, text) in ["S", "Sw", "Swi", "Swif", "Swift"].enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
                debug.log("Input: \(text) at \(Date())")
                searchText.send(text)
            }
        }
    }

    // Throttle Example
    func bTs2() {
        // throttle：在指定时间间隔内，只发布一次。如果 latest 为 true，会发布时间段内的最后一个元素，false 时发布第一个元素
        let scrollEvents = PassthroughSubject<Int, Never>()

        scrollEvents
            .throttle(for: .seconds(0.2), scheduler: DispatchQueue.main, latest: false)
            .sink { position in
                debug.log("Handle scroll position: \(position) at \(Date())")
            }
            .store(in: &cancelSet)

        // Simulate rapid scrolling
        for position in 1...5 {
            debug.log("Scrolled to: \(position) at \(Date())")
            scrollEvents.send(position)
        }
    }

    // Delay Example
    func bTs1() {
        // delay：将事件的发布推迟指定时间。
        let notifications = PassthroughSubject<String, Never>()

        notifications
            .delay(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { message in
                debug.log("Display notification: \(message) at \(Date())")
            }
            .store(in: &cancelSet)

        debug.log("Send notification: \(Date())")
        notifications.send("Operation completed")
    }

    func aTs1() {
        //
        let numberPublisher = ["1", "2", nil].publisher.compactMap { Int($0 ?? "") }
        let letterPublisher = ["A", "B", "C"].publisher
        let extraNumberPublisher = ["10", "20", "30"].publisher.compactMap { Int($0) }

        // 使用 merge 合并 numberPublisher 和 extraNumberPublisher
        debug.log("Merge Example:")
        // let mergeSubscription = numberPublisher
        _ = numberPublisher
            .merge(with: extraNumberPublisher)
            .sink { value in
                debug.log("Merge received: \(value)")
            }

        // 使用 zip 将 numberPublisher 和 letterPublisher 配对
        debug.log("\n🍎Zip Example🍎")
        // let zipSubscription = numberPublisher
        _ = numberPublisher
            .zip(letterPublisher)
            .sink { number, letter in
                debug.log("Zip received: number: \(number), letter: \(letter)")
            }

        // 使用 combineLatest 将 numberPublisher 和 letterPublisher 的最新值组合
        debug.log("\n🍎CombineLatest Example🍎")
        // let combineLatestSubscription = numberPublisher
        _ = numberPublisher
            .combineLatest(letterPublisher)
            .sink { number, letter in
                debug.log("CombineLatest received: number: \(number), letter: \(letter)")
            }

        /* 输出
         Merge Example:
         Merge received: 1
         Merge received: 2
         Merge received: 10
         Merge received: 20
         Merge received: 30

         🍎Zip Example🍎
         Zip received: number: 1, letter: A
         Zip received: number: 2, letter: B

         🍎CombineLatest Example🍎
         CombineLatest received: number: 2, letter: A
         CombineLatest received: number: 2, letter: B
         CombineLatest received: number: 2, letter: C
         */
    }

    func publish10() {
        let customPublisher = CustomPublisher()
        let cancellable = customPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("custom-finish")
                    case .failure(let error):
                        debug.log("custom-error", error)
                }
            } receiveValue: { val in
                debug.log("custom-val", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func publish9() {
        /*
         Record 是 Combine 框架中的一个发布者，用于记录一系列值和完成事件，然后在订阅时发布这些值。Record 通常用于测试和调试目的，它允许你预先定义一个数据流，并在需要时重放这些数据。
         主要属性和方法
         output: [Output] 一个数组，包含发布者将发布的所有值。
         completion: Subscribers.Completion<Failure> 发布者完成时的状态（完成或失败）。
         使用场景
         测试：在单元测试中模拟发布者行为，预先定义发布的值和完成状态。
         调试：重放特定的数据流，验证管道中的操作符是否按预期工作。
         预定义数据流：当你希望在某个点发布一组预定义的值时。
         */
        // eg. https://juejin.cn/post/7383990445050216487#heading-15

        let recordPublisher = Record<Int, Never>(output: [1, 2, 3, 4, 5], completion: .finished)
        // let recordPublisher = Record<Int, MyError>(output: [1, 2, 3, 4, 5], completion: .failure(.somethingWentWrong))
        let subscription = recordPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("record-finish")
                    case .failure(let error):
                        debug.log("record-error", error)
                }
            } receiveValue: { val in
                debug.log("record-val:", val)
            }
        subscription.store(in: &cancelSet)

        let recordData = recordPublisher.recording
        debug.log("record-output", recordData.output)
        debug.log("record-completion", recordData.completion)
    }

    func publish8() {
        // Timer 发布者会在指定的时间间隔发布值。使用 Timer 发布者定时刷新数据，例如每秒更新一次当前时间显示
        // https://juejin.cn/post/7383990445050216487#heading-14
    }

    func publish7() {
        // PassthroughSubject 、CurrentValueSubject
        // https://juejin.cn/post/7383990445050216487#heading-12
    }

    func publish6() {
        // Future用于表示一个可能在将来某个时间点产生值或失败的异步操作。Future 只会发布一个值或错误，然后完成。
        let futurePublisher = Future<String, MyError> { promise in
            // 模拟异步
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                let success = true
                if success {
                    promise(.success("hello from the future"))
                } else {
                    promise(.failure(MyError.somethingWentWrong))
                }
            }
        }

        let cancellable = futurePublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("future-finish")
                    case .failure(let error):
                        debug.log("future-error", error)
                }
            } receiveValue: { val in
                debug.log("future-val:", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func publish5() {
        // Deferred 是一个发布者，它将订阅延迟到某个条件满足时才执行。该发布者在每次订阅时会创建一个新的发布者。这在你需要根据某些条件动态创建发布者时非常有用。<也可以查看上面的retry 运算符的demo>
        // 当前时间
        func getCurrentTime() -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            return formatter.string(from: Date())
        }
        // 使用 Deferred 包装一个 Just 发布者，确保每次订阅时调用 getCurrentTime
        let deferredPublisher = Deferred {
            return Just(getCurrentTime())
        }

        let cancellable = deferredPublisher
            .sink { val in
                debug.log("deferred-val1:", val)
            }
        cancellable.store(in: &cancelSet)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            let cancellable2 = deferredPublisher
                .sink { val in
                    debug.log("deferred-val2:", val)
                }
            cancellable2.store(in: &cancelSet)
        }
    }

    func publish4() {
        // Fail 是一个发布者，它不发布任何值，只发布一个错误并立即完成。这在测试错误处理路径时非常有用。
        // 区别 catch1()
        let failPublisher = Fail<String, MyError>(error: MyError.somethingWentWrong)
        let cancellable = failPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("failtype-finish")
                    case .failure(let error):
                        debug.log("failtype-error", error)
                }
            } receiveValue: { val in
                debug.log("failtype-val:", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func publish3() {
        // Empty 是一个发布者，它不发布任何值并立即完成。这通常用于需要返回一个发布者但不实际发布任何值的情况。
        let emptyPublisher = Empty<String, Never>()
        let cancellable = emptyPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("empty-finish")
                    case .failure(let error):
                        debug.log("empty-error", error)
                }
            } receiveValue: { val in
                debug.log("empty-val:", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func publish2() {
        // Just 是一个简单的发布者，它在订阅时只会发布一个值，然后完成。这对于测试和简单数据流非常有用。
        let justPublisher = Just("hello,combine")
        let cancellable = justPublisher
            .sink { competion in
                switch competion {
                    case .finished:
                        debug.log("just-finish")
                    case .failure(let error):
                        debug.log("just-error", error)
                }
            } receiveValue: { val in
                debug.log("just-val", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func publish1() {
        // AnyPublisher 是一种类型擦除的发布者，它可以将任何具体的发布者类型封装为一个通用的发布者。这样可以隐藏具体的发布者类型，只暴露 Publisher 协议定义的接口。这在需要返回不同发布者类型的函数中非常有用，因为它统一了返回类型。
        func fetchData(from url: URL) -> AnyPublisher<Data, URLError> {
            URLSession.shared.dataTaskPublisher(for: url)
                .map { data in
                    return data.data
                }
                .eraseToAnyPublisher()
        }

        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let publisher = fetchData(from: url)
        let subscription = publisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("publish1-finish")
                    case .failure(let error):
                        debug.log("publish1-error", error)
                }
            } receiveValue: { val in
                debug.log("publish1-val", val)
            }
        subscription.store(in: &cancelSet)
    }

    func operatorEvent2() {
        // handleEvents 操作符用于在数据流的生命周期中插入事件处理代码，如接收值、接收完成事件、接收订阅、接收取消订阅等。
        let publisher = [1, 2, 3].publisher
        let cancellable = publisher
            .handleEvents { subscription in
                debug.log("event-subscription", subscription)
            } receiveOutput: { val in
                debug.log("event-output", val)
            } receiveCompletion: { completion in
                debug.log("event-completion", completion)
            } receiveCancel: {
                debug.log("event-cancel")
            } receiveRequest: { demand in
                debug.log("event-req", demand)
            }
            .sink { val in
                debug.log("event-res", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func operatorEvent1() {
        // breakpoint 操作符用于在数据流的特定位置设置断点，以便在该位置暂停调试。它不会改变数据流本身，仅用于调试目的。
        let publisher = [1, 2, 3, 4, 5].publisher
        let cancellable = publisher
            .breakpoint(receiveOutput: { val in
                return val == 3
            })
            .sink { val in
                debug.log("received-val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    func catch5() {
        // replaceError 是一种用于处理错误的操作符。它允许我们在遇到错误时，替换为一个默认值以确保数据流继续正常流动。它的作用是将错误替换为指定的输出值 output。
        let numbers = [1, 2, 3, 4, 5]
        let publisher = numbers.publisher
        let trymapPublisher = publisher
            .tryMap { number -> Int in
                if number == 3 {
                    throw MyError.invalidNumber
                }
                return number * 2
            }
        let cancellable = trymapPublisher
            /*
             .catch({ _ in
                Just(99999)
             })
             */
            .replaceError(with: 0)
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("trymap-finish")
                    case .failure(let error):
                        debug.log("trymap-error:\(error)")
                }
            } receiveValue: { val in
                debug.log("trymap-val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    enum OriginalError: Error {
        case somethingWentWrong
    }

    enum MappedError: Error {
        case mappedError
    }

    func catch4() {
        // mapError 用于将错误转换为另一种错误类型。
        let failPublisher = Fail<String, OriginalError>(error: OriginalError.somethingWentWrong)
        let mapErrorPublisher = failPublisher
            .mapError { err in
                return MappedError.mappedError
            }
        let cancellable = mapErrorPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("maperror-finish")
                    case .failure(let error):
                        debug.log("maperror-error:\(error)")
                }
            } receiveValue: { val in
                debug.log("mapError-val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    func catch3() {
        // tryMap 类似于 map，但允许抛出错误。
        let numbers = [1, 2, 3, 4, 5]
        let publisher = numbers.publisher
        let trymapPublisher = publisher
            .tryMap { number -> Int in
                if number == 3 {
                    throw MyError.invalidNumber
                }
                return number * 2
            }
        let cancellable = trymapPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("trymap-finish")
                    case .failure(let error):
                        debug.log("trymap-error:\(error)")
                }
            } receiveValue: { val in
                debug.log("trymap-val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    func catch2() {
        // retry 会在发布者失败时，重新尝试订阅。
        var attemptCount = 0
        let retryPublisher = Deferred {
            Future<String, MyError> { promise in
                attemptCount += 1
                if attemptCount < 3 {
                    promise(.failure(MyError.somethingWentWrong))
                } else {
                    promise(.success("success after (attemptCount) attempts"))
                }
            }
        }
        .retry(3)

        let cancellable = retryPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("retry-finish")
                    case .failure(let error):
                        debug.log("retry-error:\(error)")
                }
            } receiveValue: { val in
                debug.log("retry-val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    enum MyError: Error {
        case somethingWentWrong
        case invalidNumber
    }

    func catch1() {
        let failPublisher = Fail<String, MyError>(error: MyError.somethingWentWrong)
        let catchPublisher = failPublisher
            .catch { _ in
                Just("recover error")
            }
        let cancellable = catchPublisher
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("catch-finish")
                    case .failure(let error):
                        debug.log("catch-error:\(error)")
                }
            } receiveValue: { val in
                debug.log("receive-\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    func ts17() {
        // multicast 操作符允许你使用指定的 Subject 将单个发布者的输出分发给多个订阅者。这对于需要多个订阅者共享相同的事件流非常有用。

        // 创建 发布者、Subject
        let publisher = PassthroughSubject<String, Never>()
        let subject = PassthroughSubject<String, Never>()
        // 使用 multicast 操作符将发布者与 Subject 关联，创建一个多播发布者。
        let multicastedPublisher = publisher.multicast(subject: subject)

        // 创建第一个订阅者，并使用 sink 订阅多播发布者。
        let cancellable1 = multicastedPublisher
            .sink { completion in
                debug.log("muticasted1-res", completion)
            } receiveValue: { val in
                debug.log("muticasted1-val", val)
            }
        cancellable1.store(in: &cancelSet)

        // 创建第二个订阅者，并使用 sink 订阅多播发布者。
        let cancellable2 = multicastedPublisher
            .sink { completion in
                debug.log("muticasted2-res", completion)
            } receiveValue: { val in
                debug.log("muticasted2-val", val)
            }
        cancellable2.store(in: &cancelSet)

        // 使用 connect 方法启动多播发布者，将事件传递给订阅者。
        let connection = multicastedPublisher.connect()

        // 通过 publisher.send 发送事件，所有订阅者会接收到相同的事件。
        publisher.send("Hello")
        publisher.send("Combine")

        // 通过 publisher.send(completion: .finished) 完成发布者，所有订阅者会接收到完成事件。
        publisher.send(completion: .finished)

        // 通过 connection.cancel 断开多播连接。
        connection.cancel()
    }

    func ts16() {
        // 使发布者的多个订阅者共享一个订阅。
        let publisher = Just("hello,combine")
        let sharePublisher = publisher.share()
        let cancellable1 = sharePublisher
            .print("share1")
            .sink { val in
                debug.log("share1-val", val)
            }
        cancellable1.store(in: &cancelSet)
        let cancellable2 = sharePublisher
            .print("share2")
            .sink { val in
                debug.log("share2-val", val)
            }
        cancellable2.store(in: &cancelSet)
    }

    func ts15() {
        /*
         measureInterval 是一个用于测量时间间隔的操作符。它可以帮助开发者监测两次元素发出之间的时间间隔，以及订阅者接收到元素之间的时间间隔。这对于性能监控、调试和数据流分析非常有用。
         它接受一个调度器（Scheduler），返回一个 Publishers.MeasureInterval 类型的发布者。这个操作符会在每次接收到元素时记录当前时间，计算出与上次元素接收之间的时间间隔，并将间隔作为元素发出。

         scheduler: 用于计算时间间隔的调度器。通常情况下，可以使用 .main（主队列调度器）或者 .immediate（立即执行）等内置调度器。也可以传入自定义的调度器来控制时间间隔的计算行为。

         主要使用场景有:
         监测数据流的速度和频率： 可以用来监测数据流中元素的发出速度，或者计算连续元素之间的时间间隔。
         性能监控和调试： 可以用来分析和优化 Combine 数据流的性能，以及查找可能存在的延迟或者频率问题。
         */
        let publisher = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .prefix(5)
        let cancellable = publisher
            .measureInterval(using: DispatchQueue.main)
            .sink { completion in
                debug.log("measureInterval-com", completion)
            } receiveValue: { val in
                debug.log("measureInterval-val", val)
            }
        cancellable.store(in: &cancelSet)

        // 当然如果有时候我们希望将时间间隔和发布者的value同时输出，那么就需要通过flatmap将两者结合起来转化成新的publisher
        // 创建一个简单的发布者，每隔一秒发出一个整数
        let publisher2 = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect() // 自动连接
            .prefix(5) // 限制只发出五个元素，用于示例简化

        // 记录上一个值接收的时间
        var lastReceivedTime: Date?

        let cancellable2 = publisher2
            // 使用 flatMap 操作符来转换每个原始值和时间间隔的元组 (Int, TimeInterval)。
            // 在 flatMap 的闭包中，我们计算了当前时间 currentTime，以及上一个值接收时间到当前时间的时间间隔 interval。
            // 然后将值和时间间隔封装成一个元组，并通过 Just 创建一个新的发布者。
            .flatMap { timestamp -> AnyPublisher<(value: String, interval: TimeInterval), Never> in
                let currentTime = Date()
                let interval: TimeInterval = lastReceivedTime.map { currentTime.timeIntervalSince($0) } ?? 0
                lastReceivedTime = currentTime
                return Just((timestamp.customFormatted(), interval)).eraseToAnyPublisher()
            }
            // 使用sink 订阅新的发布者发布的内容
            .sink(receiveCompletion: { completion in
                debug.log("Publisher finished with completion:", completion)
            }, receiveValue: { value, interval in
                debug.log("Received value:", value, ", Interval since last value:", interval)
            })

        // 取消订阅
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            cancellable2.cancel()
        }
    }

    func ts14() {
        let publisher = PassthroughSubject<String, Never>()
        let cancellable = publisher
            .timeout(.seconds(3), scheduler: DispatchQueue.main, customError: nil)
            .sink { completaion in
                switch completaion {
                    case .finished:
                        debug.log("timeout-finish")
                    case .failure(let err):
                        debug.log("timeout-err", err)
                }
            } receiveValue: { val in
                debug.log("timeout", val)
            }
        cancellable.store(in: &cancelSet)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            publisher.send("Some data - sent after a delay of \(3) seconds")
        }
    }

    func ts13() {
        let subject = PassthroughSubject<String, Never>()

        let cancellable = subject
            .delay(for: .seconds(1), scheduler: RunLoop.main)
            .sink { val in
                debug.log("delay", val)
            }
        cancellable.store(in: &cancelSet)
        subject.send("A")
    }

    func ts12() {
        // 指定时间间隔，只允许产生一个值
        let subject = PassthroughSubject<String, Never>()
        let cancellable = subject
            // .print("throttle")
            .throttle(for: .seconds(1), scheduler: RunLoop.main, latest: true)
            .sink { val in
                debug.log("throttle", val)
            }
        cancellable.store(in: &cancelSet)
        subject.send("A")
        subject.send("B")
        subject.send("C")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            subject.send("D")
        }
        /*
         首先，字符串 "A" , "B" 和 "C" 被发送到 subject，但在 1 秒内它们都被发送了，并且设置了latest = true ，throttle操作符只会接收最后一个值，即 "C"。
         在延迟 1.5 秒后，节流操作会接收到 "D" 并打印。
         */
    }

    func ts11() {
        // 指定时间间隔 只取最后一个值
        let subject = PassthroughSubject<String, Never>()
        let cancellable = subject
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { val in
                debug.log("debounce", val)
            }
        cancellable.store(in: &cancelSet)
        subject.send("A")
        subject.send("B")
        subject.send("C")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            subject.send("D")
        }
    }

    func ts10() {
        let publisher = [3, 4, 5].publisher
        let cancellable = publisher
            .prepend(1, 2)
            .sink { val in
                debug.log("prepend:", val)
            }
        cancellable.store(in: &cancelSet)
    }

    // 全部累加然后输出
    func ts9() {
        let numbers = [1, 2, 3, 4, 5]
        let publisher = numbers.publisher
        let cancellable = publisher
            .reduce(0) { accumulated, value in
                accumulated + value
            }
            .sink { val in
                debug.log("reduce-val", val)
            }
        cancellable.store(in: &cancelSet)
    }

    // 每次叠加上一个值
    func ts8() {
        let numbers = [1, 2, 3, 4, 5]
        let publisher = numbers.publisher
        let cancellable = publisher
            .scan(0) { accumulated, value in
                accumulated + value
            }
            .sink { val in
                debug.log("scan-val", val)
            }
        cancellable.store(in: &cancelSet)
    }

    func ts7() {
        let publisher = [1, 2, 3, 4, 5].publisher
        let cancelable = publisher
            .collect()
            .sink { val in
                debug.log("val:\(val)")
            }
        cancelable.store(in: &cancelSet)
    }

    // 必须全局
    var cancelSet = Set<AnyCancellable>()
    func ts6() {
        //
        func fetchDataPublisher(reqNum: Int) -> AnyPublisher<String, Error> {
            return Future<String, Error> { promise in
                DispatchQueue.global().asyncAfter(deadline: .now() + Double(reqNum)) {
                    promise(.success("response from request(reqNum)"))
                }
            }
            .eraseToAnyPublisher()
        }

        let seqPublisher = Publishers.Sequence(sequence: [1, 2, 3])
            .map { reqNum in
                fetchDataPublisher(reqNum: reqNum)
            }
            .switchToLatest()

        let cancellable = seqPublisher
            .print("abc")
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("finisah")
                        debug.log("completed")
                    case .failure(let err):
                        debug.log("err:\(err)")
                }
            } receiveValue: { val in
                debug.log("val:\(val)")
            }
        cancellable.store(in: &cancelSet)
    }

    func ts5() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        let combinedPublisher = Publishers.Zip(publisher1, publisher2)
        let cancellable = combinedPublisher
            // .print("combine")
            .sink { val1, val2 in
                debug.log("Zip val: \(val1) and \(val2)")
            }
        publisher1.send(1)
        publisher2.send("A")
        publisher1.send(2)
        publisher2.send("B")
        cancellable.cancel()
    }

    func ts4() {
        let publisher1 = PassthroughSubject<Int, Never>()
        let publisher2 = PassthroughSubject<String, Never>()
        let combinedPublisher = Publishers.CombineLatest(publisher1, publisher2)
        let cancellable = combinedPublisher
            // .print("combine")
            .sink { val1, val2 in
                debug.log("combine val: \(val1) and \(val2)")
            }
        publisher1.send(1)
        publisher2.send("A")
        publisher1.send(2)
        publisher2.send("B")
        cancellable.cancel()
    }

    func ts3() {
        let publisher1 = [1, 2, 3].publisher
        let publisher2 = [4, 5, 6].publisher

        let mergePublisher = Publishers.Merge(publisher1, publisher2)
        let _ = mergePublisher
            .print("merge")
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("fffffnished")
                    case .failure(let err):
                        debug.log("errrrrror", err)
                }
            } receiveValue: { value in
                debug.log("out:", value)
            }
    }

    private let titleLabel = UILabel()
    func ts2() {
        let publisher = NotificationCenter.Publisher(center: .default, name: .dataLoaded)
            .map { noti -> String? in
                return (noti.object as? ComItem)?.title
            }
        let subscriber = Subscribers.Assign(object: titleLabel, keyPath: \.text)
        publisher.subscribe(subscriber)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let data = ComItem(title: "我是一个标题")
        NotificationCenter.default.post(name: .dataLoaded, object: data)
        debug.log(titleLabel.text ?? "")
    }

    func ts1() {
        let publisher = Just("hello,combine!")
        let cancellable = publisher
            .map { "\($0) world!" }
            .sink { completion in
                switch completion {
                    case .finished:
                        debug.log("finished")
                    case .failure(let err):
                        debug.log("err:\(err)", type: .error)
                }
            } receiveValue: { val in
                debug.log("val", val)
            }
        cancellable.cancel()
    }

    func comThree() {
        let weather = Weather(temperature: 20)
        let cancellable = weather.$temperature
            .sink {
                debug.log("val:", weather.temperature, "Temperature now: \($0)")
            }
        weather.temperature = 25
        cancellable.cancel()
        // weather.temperature = 35
    }

    /*
      立即开始的 Just 和 Future
      对于大部分的 Publisher来说，它们在订阅后才会开始生产事件，但也有一些例外。Just 和 Future 在初始化完成后会立即执行闭包生产事件，这可能会让一些耗时长的操作在不符合预期的时机提前开始，也可能会让第一个订阅错过一些太早开始的事件。
      一个可行的解法是在这类 Publisher 外封装一层 Defferred，让它在接收到订阅之后再开始执行内部的闭包。

     func makeMyPublisher() -> AnyPublisher<Int, Never> {
         Just(calculateTimeConsumingResult())
             .eraseToAnyPublisher()
     }

     func makeMyFuture2() -> AnyPublisher<Int, Never> {
         Deferred {
             Just(calculateTimeConsumingResult())
         }.eraseToAnyPublisher()
     }
     */

    func comTwo() {
        let greetings = PassthroughSubject<String, Never>()
        let names = PassthroughSubject<String, Never>()
        let years = PassthroughSubject<String, Never>()

        let greetingNames = Publishers.CombineLatest(greetings, names)
            .map { "\($1),\($0)" }
        let wholeSentence = Publishers.CombineLatest(greetingNames, years)
            .map { ">:\($0),\($1)" }
            .sink {
                debug.log("out", $0)
            }

        years.send("2025")
        names.send("combine")
        greetings.send("hello")
        wholeSentence.cancel()

        let curSubject = CurrentValueSubject<Int, Never>(0)
        debug.log("CurrentValueSubject===")
        let cancellable = curSubject
            .print("cur=>")
            .map { $0 }
            .sink {
                debug.log("cur:", $0)
            }
        curSubject.value = 1
        curSubject.value = 2
        curSubject.send(completion: .finished)
        cancellable.cancel()
    }

    func comOne() {
        //
        let cancellable = [1, 2, 3, 4, 5].publisher
            .print("第一个")
            .sink { completion in
                debug.log(completion)
            } receiveValue: { value in
                debug.log(value)
            }
        cancellable.cancel()
        //
        let cancellable2 = [1, 2, 3, 4, 5].publisher
            .print("第二个")
            .sink { value in
                debug.log(value)
            }
        cancellable2.cancel()
    }
}

/// 自定义发布者
struct CustomPublisher: Publisher {
    typealias Output = String
    typealias Failure = Never
    func receive<S>(subscriber: S) where S: Subscriber, CustomPublisher.Failure == S.Failure, CustomPublisher.Output == S.Input {
        let subscription = CustomSubscription(subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

class CustomSubscription<S: Subscriber>: Subscription where S.Input == String, S.Failure == Never {
    private var subscriber: S?

    init(subscriber: S) {
        self.subscriber = subscriber
    }

    func request(_ demand: Subscribers.Demand) {
        _ = subscriber?.receive("Custom Publisher Value")
        subscriber?.receive(completion: .finished)
    }

    func cancel() {
        subscriber = nil
    }
}

///
extension Date {
    func customFormatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let formattedTime = formatter.string(from: self)
        return formattedTime
    }
}

///
extension Notification.Name {
    static let dataLoaded = Notification.Name("data_loaded")
}

struct ComItem {
    let title: String
}

///
class Weather {
    @Published var temperature: Double
    init(temperature: Double) {
        self.temperature = temperature
    }
}
