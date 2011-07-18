package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class Wikistorm extends Sprite{
		
		public var boxes:Array = new Array;
		
		public function Wikistorm() {
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, newBox);
		}
		private function newBox(evt:Event):void{
//			var clash:Boolean = false;
//			for(var i=0; i<stage.numChildren-1; i++)
//			{
//				var obj:TextBox = stage.getChildAt(i);
//				clash = obj.hitTestPoint(mouseX,mouseY,true)
//			}
//			if (obj==false){
			  var box:TextBox = new TextBox();
			  box.x = mouseX;
			  box.y = mouseY;
			  boxes.push(box);
			  addChild(box);
//			}
		}
	}
}

import flash.display.Sprite;
import flash.display.Stage;
import flash.events.*;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.*;

class TextBox extends Sprite
{
	
	private var tf:TextField = new TextField();
	private var resizer:Sprite = new Sprite();
	private var dragger:Sprite = new Sprite();
	private var vector:Point = new Point();
//	private var bounds:Rectangle;
	private var lastMouse:Point = new Point();
	private var mouseMoved:Point = new Point();
	
	public function TextBox()
	{
//		bounds = throwBounds;
		
		tf.width = 100;
		tf.height = 50;
		tf.border = true;
		tf.type = TextFieldType.INPUT;
		tf.text = "Resize me by dragging the gray triangle in the corner";
		addChild(tf);
		
		resizer.graphics.beginFill(0xCCCCCC, 1);
		resizer.graphics.lineTo(0,-10);
		resizer.graphics.lineTo(-10,0);
		resizer.graphics.endFill();
		addChild(resizer);
		
		resizer.x = tf.x + tf.width;
		resizer.y = tf.y + tf.height;
		
		resizer.buttonMode = true;
		resizer.addEventListener(MouseEvent.MOUSE_DOWN, initDrag);
		resizer.addEventListener(MouseEvent.MOUSE_UP, removeDrag);
		
		dragger.graphics.beginFill(0xCCCCCC, 1);
		dragger.graphics.lineTo(10,0);
		dragger.graphics.lineTo(0,10);
		dragger.graphics.endFill();
		addChild(dragger);
		
		dragger.x = tf.x;
		dragger.y = tf.y;
		
		dragger.buttonMode = true;
		
		dragger.addEventListener(MouseEvent.MOUSE_DOWN, grabBall);
		dragger.addEventListener(MouseEvent.MOUSE_UP, releaseBall);
	}
	
	private function initDrag(e:MouseEvent):void
	{
		resizer.startDrag();
		addEventListener(Event.ENTER_FRAME, resizeTF);
	}
	private function removeDrag(e:MouseEvent):void
	{
		resizer.stopDrag();
		resizer.x = tf.x + tf.width;
		resizer.y = tf.y + tf.height;
		removeEventListener(Event.ENTER_FRAME, resizeTF);
	}
	private function resizeTF(e:Event):void
	{
		var currWidth:int = tf.width;
		var currHeight:int = tf.height;
		if((resizer.x - tf.x)>10)
		{
		    tf.width = resizer.x - tf.x
		}
		else{
		    tf.width = 20
		}
		if((resizer.y - tf.y)>10){
		    tf.height = resizer.y - tf.y;
		}
		else{
		    tf.height = 20
		}
		var clash:Boolean = false;
		for each(var bx:TextBox in (parent as Wikistorm).boxes)
		{
            clash = bx.tf.hitTestObject(tf);
			if (clash==true)
			{
				break;
			}
		}
		if (clash==true)
		{
			tf.width = currWidth;
			tf.height = currHeight;
	    }
	}
	
	private function grabBall(evt:MouseEvent):void {
		startDrag();
		lastMouse = new Point(mouseX, mouseY);
		
		addEventListener(Event.ENTER_FRAME, moveBall);
		moveBall(new Event(Event.ENTER_FRAME));
	}
	
	private function releaseBall(evt:MouseEvent):void {
		stopDrag();
		
		removeEventListener(Event.ENTER_FRAME, moveBall);
	}
	
	private function moveBall(evt:Event):void {
		var currMouse:Point = new Point(mouseX, mouseY);
		mouseMoved = currMouse.subtract(lastMouse);
		lastMouse = currMouse;
	}
	
}