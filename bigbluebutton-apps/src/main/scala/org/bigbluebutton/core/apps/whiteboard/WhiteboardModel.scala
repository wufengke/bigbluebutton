package org.bigbluebutton.core.apps.whiteboard

import org.bigbluebutton.core.apps.whiteboard.vo.AnnotationVO
import scala.collection.mutable.ArrayBuffer

class WhiteboardModel {
  private var _whiteboards = new scala.collection.immutable.HashMap[String, Whiteboard]()
  
  private var _enabled = true
    
  private def saveWhiteboard(wb: Whiteboard) {
    _whiteboards += wb.id -> wb
  }
  
  def getWhiteboard(id: String):Option[Whiteboard] = {
    _whiteboards.values.find(wb => wb.id == id)
  }
  
  
  def addAnnotationToShape(wb: Whiteboard, shape: AnnotationVO) = {
//    println("Adding shape to wb [" + wb.id + "]. Before numShapes=[" + wb.shapes.length + "].")
    val newWb = wb.copy(shapes=(wb.shapes :+ shape))
//    println("Adding shape to page [" + wb.id + "]. After numShapes=[" + newWb.shapes.length + "].")
    saveWhiteboard(newWb)
  }
  
  def addAnnotation(wbId:String, shape: AnnotationVO) {
    getWhiteboard(wbId) match { 
      case Some(wb) =>
        addAnnotationToShape(wb, shape)
      case None => {
        val vec = scala.collection.immutable.Vector.empty
        val wb = new Whiteboard(wbId, vec :+ shape)
        saveWhiteboard(wb)
      }
    }     
  }
  
  private def modifyTextInPage(wb: Whiteboard, shape: AnnotationVO) = {
    val removedLastText = wb.shapes.dropRight(1)
    val addedNewText = removedLastText :+ shape
    val newWb = wb.copy(shapes=addedNewText)
    saveWhiteboard(newWb)   
  }
  
  def modifyText(wbId:String, shape: AnnotationVO) {
     getWhiteboard(wbId) foreach { wb =>
        modifyTextInPage(wb, shape) 
    }   
  }
   
  def history(wbId:String):Option[Whiteboard] = {
    getWhiteboard(wbId)
  }
  
  def clearWhiteboard(wbId:String) {
    getWhiteboard(wbId) foreach { wb =>
        val clearedShapes = wb.shapes.drop(wb.shapes.length)
        val newWb = wb.copy(shapes= clearedShapes)
        saveWhiteboard(newWb)         
    }    
  }
  
  def undoWhiteboard(wbId:String):Option[AnnotationVO] = {
    var last:Option[AnnotationVO] = None
    getWhiteboard(wbId) foreach { wb =>
      if (!wb.shapes.isEmpty) {
        last = Some(wb.shapes.last)
        val remaining = wb.shapes.dropRight(1)
        val newWb = wb.copy(shapes=remaining)
        saveWhiteboard(newWb)
      }
    }
    last
  }
    
  def enableWhiteboard(enable: Boolean) {
    _enabled = enable
  }
  
  def isWhiteboardEnabled():Boolean = {
    _enabled
  }
}