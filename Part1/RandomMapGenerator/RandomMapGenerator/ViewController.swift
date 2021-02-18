//
//  ViewController.swift
//  RandomMapGenerator
//
//  Created by NikitaFilonov on 18.02.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var generateButton: UIButton?
    private var saveButton: UIButton?
    private var rMap: RMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addButtons()
        addRandomMap()
    }

    private func addButtons() {
        let screenWidth = self.view.frame.width
        
        generateButton = UIButton(frame: CGRect(x: 0,
                                                y: 60,
                                                width: screenWidth/2,
                                                height: 50))
        generateButton?.setTitle("generate", for: .normal)
        generateButton?.addTarget(self, action: #selector(updateMap), for: .touchUpInside)
        generateButton?.backgroundColor = .green
        
        saveButton = UIButton(frame: CGRect(x: screenWidth/2,
                                            y: 60,
                                            width: screenWidth/2,
                                            height: 50))
        saveButton?.setTitle("save", for: .normal)
        saveButton?.backgroundColor = .red
        
        [generateButton, saveButton].forEach({ self.view.addSubview($0!) })
    }
    
    private func addRandomMap() {
        rMap = RMapView(frame: CGRect(x: 0,
                                      y: 110,
                                      width: self.view.bounds.width,
                                      height: self.view.bounds.height - 110))
        self.view.addSubview(rMap!)
    }
    
    @objc private func updateMap() {
        rMap?.update()
    }

}

