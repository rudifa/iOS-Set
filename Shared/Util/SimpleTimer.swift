//
//  SimpleTimer.swift
//  Set
//
//  Created by Rudolf Farkas on 29.09.21.
//

// adapted from https://swiftuirecipes.com/blog/timers-and-countdowns-in-swiftui

import Combine
import Foundation

class SimpleTimer {
    // the interval at which the timer ticks
    let interval: TimeInterval
    // the action to take when the timer ticks
    typealias Action = () -> Void
    private(set) var onTick: Action?

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    private var subscription: AnyCancellable?

    init(interval: TimeInterval, onTick: Action? = nil) {
        self.interval = interval
        self.onTick = onTick
    }

    var isRunning: Bool {
        timer != nil
    }

    // start the timer and begin ticking
    func start(onTick: @escaping Action) {
        self.onTick = onTick
        timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        subscription = timer?.sink(receiveValue: { _ in
            self.onTick?()
        })
    }

    // cancel the timer and clean up its resources
    func cancel() {
        timer?.upstream.connect().cancel()
        timer = nil
        subscription = nil
    }
}

/*
 Here's an example where the timer ticks every second:

 @State private var remainingTime = 0
 timer = SimpleTimer(interval: 1) {
   self.remainingTime -= 1
 }

 Then, simply start it when needed:

 timer.start()

 And after you don't need it anymore, call cancel:

 timer.cancel()

 Tip: TimerPublisher emits the current date with every tick, and you can optionally consume that value as the parameter in onReceive and sink(receiveValue: blocks.
 
 */
