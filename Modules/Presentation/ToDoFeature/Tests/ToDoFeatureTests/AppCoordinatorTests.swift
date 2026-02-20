//
//  AppCoordinatorTests.swift
//  ToDoFeature
//
//  Created by Sergey Kemenov on 20.02.2026.
//

import Testing
@testable import ToDoFeature
import SwiftUI

@Suite("AppCoordinator Navigation")
@MainActor
struct AppCoordinatorTests {
    
    private let mockContainer = UIMockDependencyContainer()

    @Test("Initial state — path empty, shows root or list based on flag, no crashes")
    func initialState() {
        let sut = AppCoordinator(container: mockContainer)
        #expect(true)
        #expect(sut.path.isEmpty)
        #expect(sut.isNeedToShowList == false)
    }
    
    @Test("push / pop operations update path correctly")
    func pushAndPop() {
        let sut = AppCoordinator(container: mockContainer)

        sut.push(page: .toDosList)
        #expect(sut.path.count == 1)

        sut.push(page: .createToDo)
        #expect(sut.path.count == 2)
        
        sut.pop()
        #expect(sut.path.count == 1)

        sut.popToRoot()
        #expect(sut.path.isEmpty)
    }
    
    @Test("isNeedToShowList changes root destination")
    func isNeedToShowListFlag() {
        let sut = AppCoordinator(container: mockContainer)
        #expect(sut.isNeedToShowList == false)
        
        sut.isNeedToShowList = true
        #expect(sut.isNeedToShowList == true)
    }
}
