//
//  CoreAnimationKeyPath.swift
//
//
//  Created by 刘万林 on 2021/2/5.
//

import Foundation

public struct CoreAnimationKeyPath {
    
    private init() {}

    //  MARK: - 1. 几何属性 (Geometry Properties)

    /// 按x轴旋转的弧度    Set to an NSNumber object whose value is the rotation, in radians, in the x axis.
    static public var transform_rotation_x = "transform.rotation.x"

    /// 按y轴旋转的弧度    Set to an NSNumber object whose value is the rotation, in radians, in the y axis.
    static public var transform_rotation_y = "transform.rotation.y"

    /// 按z轴旋转的弧度    Set to an NSNumber object whose value is the rotation, in radians, in the z axis.
    static public var transform_rotation_z = "transform.rotation.z"

    /// 按z轴旋转的弧度, 和transform.rotation.z效果一样    Set to an NSNumber object whose value is the rotation, in radians, in the z axis. This field is identical to setting the rotation.z field.
    static public var transform_rotation = "transform.rotation"

    /// 在x轴按比例放大缩小    Set to an NSNumber object whose value is the scale factor for the x axis.
    static public var transform_scale_x = "transform.scale.x"

    /// 在x轴按比例放大缩小    Set to an NSNumber object whose value is the scale factor for the y axis.
    static public var transform_scale_y = "transform.scale.y"

    /// 在z轴按比例放大缩小    Set to an NSNumber object whose value is the scale factor for the z axis.
    static public var transform_scale_z = "transform.scale.z"

    /// 按比例放大缩小    Set to an NSNumber object whose value is the average of all three scale factors.
    static public var transform_scale = "transform.scale"

    /// 沿x轴平移    Set to an NSNumber object whose value is the translation factor along the x axis.
    static public var transform_translation_x = "transform.translation.x"

    /// 沿y轴平移    Set to an NSNumber object whose value is the translation factor along the y axis.
    static public var transform_translation_y = "transform.translation.y"

    /// 沿z轴平移    Set to an NSNumber object whose value is the translation factor along the z axis.
    static public var transform_translation_z = "transform.translation.z"

    /// x,y 坐标均发生改变    Set to an NSValue object containing an NSSize or CGSize data type. That data type indicates the amount to translate in the x and y axis.
    static public var transform_translation = "transform.translation"

    /// CATransform3D 4*4矩阵
    static public var transform = "transform"

    /// layer大小
    static public var bounds = "bounds"

    /// layer位置
    static public var position = "position"

    /// 锚点位置
    static public var anchorPoint = "anchorPoint"

    /// 圆角大小
    static public var cornerRadius = "cornerRadius"

    /// z轴位置
    static public var zPosition = "zPosition"

    //  MARK: - 2.背景属性 (Background Properties)

    /// 背景颜色
    static public var backgroundColor = "backgroundColor"

    //  MARK: - 3.Layer内容 (Layer Content)

    /// Layer内容，呈现在背景颜色之上
    static public var contents = "contents"

    ///    The rectangle, in the unit coordinate space, that defines the portion of the layer’s contents that should be used.
    static public var contentsRect = "contentsRect"

    ///    setting the layer’s masksToBounds property to YES does cause the layer to clip to its corner radius
    static public var masksToBounds = "masksToBounds"

    //  MARK: - 4.子Layer内容 (Sublayers Content)

    /// 子Layer数组
    static public var sublayers = "sublayers"

    /// 子Layer的var Transform = "Transform"             //Specifies the transform to apply to sublayers when rendering.
    static public var sublayerTransform = "sublayerTransform"

    //  MARK: - 5.边界属性 (Border Attributes)

    static public var borderColor = "borderColor"

    static public var borderWidth = "borderWidth"

    //  MARK: - 6.阴影属性 (Shadow Properties)

    /// 阴影颜色
    static public var shadowColor = "shadowColor"

    /// 阴影偏移距离
    static public var shadowOffset = "shadowOffset"

    /// 阴影透明度
    static public var shadowOpacity = "shadowOpacity"

    /// 阴影圆角
    static public var shadowRadius = "shadowRadius"

    /// 阴影路径
    static public var shadowPath = "shadowPath"

    //  MARK: - 7.透明度 (Opacity Property)

    /// 透明度
    static public var opacity = "opacity"

    static public var hiden = "hiden"

    //  MARK: - 8.遮罩 (Mask Properties)

    static public var mask = "mask"

    //  MARK: - 9.ShapeLayer属性 (ShapeLayer)

    static public var fillColor = "fillColor"

    static public var strokeColor = "strokeColor"

    /// 从无到有
    static public var strokeStart = "strokeStart"

    /// 从有到无
    static public var strokeEnd = "strokeEnd"

    /// 路径的线宽
    static public var lineWidth = "lineWidth"

    /// 相交长度的最大值
    static public var miterLimit = "miterLimit"

    /// 虚线样式
    static public var lineDashPhase = "lineDashPhase"
}
