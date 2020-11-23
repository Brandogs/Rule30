//
//  Rule30Tests.swift
//  Rule30Tests
//
//  Created by Brandon G. Smith on 11/20/20.
//

import XCTest
@testable import Rule30

class Rule30Tests: XCTestCase {
    var sut: AutomataViewController!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UIStoryboard(name: "Main", bundle: nil)
          .instantiateViewController(identifier: "AutomataViewControllerID") as? AutomataViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    /**
     Testing that the automata properly updates through multiple iterantions/generations
     */
    func testAutomataGeneration() throws {
        let origin = [false, false, false, true, false, false, false]
        sut.automata = Automata(
            origin: origin,
            generations: Array(
                repeating: [false, false, false, false, false, false, false],
                count: 4
            )
        )
        sut.isIncrementalRefresh = false
        sut.generateAutomataMatrix()
        
        let expected = [
                        origin,
                        [false, false, true, true, true, false, false],
                        [false, true, true, false, false, true, false],
                        [true, true, false, true, true, true, true]
                       ]
        
        XCTAssertEqual(sut.automata.generations, expected)
    }
    
    /**
     Ensuring no errors is automata attempted to be generated before setting up arrays
     */
    func testEmptyOriginGeneration() {
        let expected = Automata(origin: [], generations: [[]])
        sut.automata = expected
        sut.isIncrementalRefresh = false
        sut.generateAutomataMatrix()
        
        XCTAssertEqual(sut.automata.generations, expected.generations)
    }
    
    /**
     Testing the performance of the generation of the automata.
     The orgin array and number of generations are roughly the maxium that can appear on any device.
     */
    func testAutomataGenerationPerformance() throws {
        let origin = [false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false,
                      false, false, false, true, false, false, false, true, true, false]
        sut.automata = Automata(
            origin: origin,
            generations: Array(repeating: origin, count: 28)
        )
        sut.isIncrementalRefresh = false
        self.measure {
            sut.generateAutomataMatrix()
        }
    }

}
