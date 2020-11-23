//
//  AutomataViewController.swift
//  Rule30
//
//  Created by Brandon G. Smith on 11/22/20.
//

import UIKit

private let reuseIdentifier = "AutomatonCell"

class AutomataViewController: UIViewController {
    /// Collection where the user sets the inital generation of the automata
    @IBOutlet weak var selectionCollectionView: UICollectionView!
    /// Collection that displays multiple generations of the automata
    @IBOutlet weak var generationCollectionView: UICollectionView!
    
    /// Determines if refresh should appear instantly or incrementally with a delay
    var isIncrementalRefresh = true
    /// Delay between updating automata generations, when incrementalRefresh is true
    var rowRefreshDelay = 0.1
    
    /// Collection View Cell sizes
    let cellSize = CGSize(width: 44.0, height: 44.0)
    /// Minimum spacing between Collection View Cells in a row
    let itemSpacing: CGFloat = 0.0
    /// Spacing between Collection View Cell lines
    let lineSpacing: CGFloat = 0.0
    
    /// Automata model
    var automata: Automata = Automata(origin: [], generations: [[]])
    /// Buffer size for Automata array to simulate infinite array
    var automataBuffer = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // General Collection Views Setup
        selectionCollectionView.delegate = self
        selectionCollectionView.dataSource = self
        selectionCollectionView.tag = CollectionType.selection.rawValue
        selectionCollectionView.register(
            AutomatonCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        generationCollectionView.delegate = self
        generationCollectionView.dataSource = self
        generationCollectionView.tag = CollectionType.generation.rawValue
        generationCollectionView.register(
            AutomatonCollectionViewCell.self,
            forCellWithReuseIdentifier: reuseIdentifier
        )
        
        // Flow Layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = cellSize
        flowLayout.minimumInteritemSpacing = itemSpacing
        flowLayout.sectionInset = UIEdgeInsets(
            top: lineSpacing,
            left: lineSpacing,
            bottom: lineSpacing,
            right: lineSpacing
        )
        selectionCollectionView.collectionViewLayout = flowLayout
        generationCollectionView.collectionViewLayout = flowLayout
        
        // Determine number of automaton cells
        let rowCount = Int((UIScreen.main.bounds.width-20.0)/cellSize.width)
        automataBuffer = rowCount
        let columnCount = Int((UIScreen.main.bounds.height-selectionCollectionView.frame.height-100.0)/cellSize.height)
        
        // Generate Automata
        let automataArray = Array(repeating: false, count: rowCount+(2*automataBuffer))
        automata.origin = automataArray
        automata.generations = Array(repeating: automataArray, count: columnCount)
    }
    
    // MARK: - Automata Generation
    
    /**
     Generates array of automata generations based on inital array selected by the user.
     */
    func generateAutomataMatrix() {
        automata.generations[0] = automata.origin
        if isIncrementalRefresh {
            generationCollectionView.reloadSections(IndexSet(integer: 0))
        }
        generateNextAutomata()
    }
    
    /**
     Creates the next iteration of the automata based on the previous row.
     
     - Parameters:
        - generation: Generation of the automata to be generated if timer is not provided
        - timer:
     */
    @objc private func generateNextAutomata(timer: Timer? = nil, generation: Int = 1) {
        var row = generation
        if let userInfo = timer?.userInfo as? [String: Any?] {
            guard let next = userInfo["row"] as? Int else { return }
            row = next
        }
        
        if row <= 0 || row >= automata.generations.count {
            generationCollectionView.reloadData()
            return
        }
        for i in 0..<automata.generations[row].count {
            let source = automata.generations[row-1]
            let left = i>0 ? source[i-1] : false
            let right = i+1<source.count ? source[i+1] : false
            automata.generations[row][i] = left != (source[i] || right)
        }
        
        if isIncrementalRefresh {
            // Generating next row on a timer to create delayed affect
            generationCollectionView.reloadSections(IndexSet(integer: row))
            
            Timer.scheduledTimer(
                timeInterval: rowRefreshDelay,
                target: self,
                selector: #selector(generateNextAutomata),
                userInfo: ["row": row+1],
                repeats: false
            )
        } else {
            // Generate next value without a timer
            generateNextAutomata(generation: row+1)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? AutomataRefreshConfigViewController {
            dest.animateRefresh = isIncrementalRefresh
            dest.delayTime = Float(rowRefreshDelay)
        }
    }
    
    @IBAction func unwind( _ segue: UIStoryboardSegue) {
        if let source = segue.source as? AutomataRefreshConfigViewController {
            isIncrementalRefresh = source.animateRefresh
            rowRefreshDelay = Double(source.delayTime)
        }
    }
}

extension AutomataViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Collection Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == CollectionType.selection.rawValue {
            return Int(automata.origin.count-(2*automataBuffer))
        }
        if collectionView.tag == CollectionType.generation.rawValue {
            return Int(automata.generations[section].count-(2*automataBuffer))
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let autoCell = cell as? AutomatonCollectionViewCell {
            if collectionView.tag == CollectionType.selection.rawValue {
                autoCell.setLiving(automata.origin[indexPath.item+automataBuffer])
            }
            if collectionView.tag == CollectionType.generation.rawValue {
                autoCell.setLiving(automata.generations[indexPath.section][indexPath.item+automataBuffer])
            }
            return autoCell
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == CollectionType.selection.rawValue {
            return 1
        }
        if collectionView.tag == CollectionType.generation.rawValue {
            return self.automata.generations.count
        }
        return 0
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == CollectionType.selection.rawValue {
            automata.origin[indexPath.item+automataBuffer].toggle()
            
            if let autoCell = collectionView.cellForItem(at: indexPath) as? AutomatonCollectionViewCell {
                autoCell.setLiving(automata.origin[indexPath.item+automataBuffer])
            }
            
            generateAutomataMatrix()
            generationCollectionView.reloadData()
        }
        
    }
}

// MARK: - Collection Tag Identifiers
/// CollectionType idetifies the purpose of the collections in this View Controller
private enum CollectionType: Int {
    case selection, generation
}
