//
//  CGPoint+Ext.swift
//  SpriteKit Games
//
//  Created by Aparna Tati on 20/02/23.
//

import Foundation

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return  CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func += (left: inout CGPoint, right: CGPoint) {
    left = left + right
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return  CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func -= (left: inout CGPoint, right: CGPoint) {
    left = left - right
}

func * (point: CGPoint, scaler: CGPoint) -> CGPoint {
    return  CGPoint(x: point.x * scaler.x, y: point.y * scaler.y)
}

func *= (point: inout CGPoint, scaler: CGPoint) {
    point = point * scaler
}

func / (point: CGPoint, scaler: CGPoint) -> CGPoint {
    return  CGPoint(x: point.x / scaler.x, y: point.y / scaler.y)
}

func /= (point: inout CGPoint, scaler: CGPoint) {
    point = point / scaler
}
