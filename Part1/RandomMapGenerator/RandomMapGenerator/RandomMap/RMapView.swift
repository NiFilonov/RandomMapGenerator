//
//  RMapView.swift
//  RandomMapGenerator
//
//  Created by NikitaFilonov on 18.02.2021.
//

import UIKit

class RMapView: UIView {
    
    private var columnsCount: Int = 0
    private var rowsCount: Int = 0
    private var cellWidth: CGFloat = 0.0
    private var rooms: [Room] = []
    
    override func draw(_ rect: CGRect) {
        calculateFieldSize(rect)
        drawGrid(rect)
    }
    
    func update() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        rooms = []
        
        calculateFieldSize(self.bounds)
        drawGrid(self.bounds)
        
        generateRooms()
        drawRooms()
    }
    
    private func generateRooms() {
        let randomRoomsCount = columnsCount * rowsCount * 5
        var roomsArray: [Room] = []
        
        for _ in 0...randomRoomsCount {
            let width = Int.random(in: 2...Int(Double(columnsCount) * 0.4))
            let height = Int.random(in: 2...Int(Double(rowsCount) * 0.4))
            let x = Int.random(in: 1...(columnsCount-1)-width)
            let y = Int.random(in: 1...(rowsCount-1)-height)
            
            let room = Room(x: x,
                            y: y,
                            width: width,
                            height: height)
            roomsArray.append(room)
        }
        
        rooms.append(roomsArray.first!)
        
        for room in roomsArray {
            let filteredRooms = rooms.filter { (rm) -> Bool in
                return rm.isCross(with: room)
            }
            if filteredRooms.isEmpty {
                rooms.append(room)
            }
        }
    }
    
    private func drawRooms() {
        
        for room in rooms {
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: convertToCGFloat(room.x),
                                  y: convertToCGFloat(room.y)))
            path.addLine(to: CGPoint(x: convertToCGFloat(room.maxX),
                                     y: convertToCGFloat(room.y)))
            path.addLine(to: CGPoint(x: convertToCGFloat(room.maxX),
                                     y: convertToCGFloat(room.maxY)))
            path.addLine(to: CGPoint(x: convertToCGFloat(room.x),
                                     y: convertToCGFloat(room.maxY)))
            path.addLine(to: CGPoint(x: convertToCGFloat(room.x),
                                  y: convertToCGFloat(room.y)))
            
            path.stroke()
            path.fill()
            
            let pathLayer = CAShapeLayer()
            pathLayer.fillColor = UIColor.brown.cgColor
            pathLayer.backgroundColor = UIColor.brown.cgColor
            pathLayer.path = path.cgPath
            
            self.layer.addSublayer(pathLayer)
        }
        
        
        
    }

    private func calculateFieldSize(_ rect: CGRect) {
        let width = rect.width
        cellWidth = width * 0.07 // CGFloat.random(in: (0.05)...(0.3))
        
        columnsCount = Int(rect.width / cellWidth)
        rowsCount = Int(rect.height / cellWidth)
    }
    
    private func drawGrid(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // сверху вниз
        for i in 0...columnsCount {
            path.move(to: CGPoint(x: cellWidth * CGFloat(i), y: 0))
            path.addLine(to: CGPoint(x: cellWidth * CGFloat(i), y: cellWidth * CGFloat(rowsCount)))
        }
        // слева на право
        for i in 0...rowsCount {
            path.move(to: CGPoint(x: 0, y: cellWidth * CGFloat(i)))
            path.addLine(to: CGPoint(x: cellWidth * CGFloat(columnsCount), y: cellWidth * CGFloat(i)))
        }
        
        let pathLayer = CAShapeLayer()
        pathLayer.lineWidth = 2.0
        pathLayer.strokeColor = UIColor.black.cgColor
        pathLayer.path = path.cgPath
        
        self.layer.addSublayer(pathLayer)
    }
    
    private func convertToCGFloat(_ val: Int) -> CGFloat {
        return CGFloat(val) * cellWidth
    }
    
}

struct Room {
    var x: Int
    var y: Int
    var width: Int
    var height: Int
    
    var maxX: Int {
        return x + width
    }
    
    var maxY: Int {
        return y + height
    }
    
    func isCross(with room: Room) -> Bool {
        return (x...maxX).overlaps(room.x...room.maxX) &&
            (y...maxY).overlaps(room.y...room.maxY)
    }
}
