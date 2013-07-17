package  code
{
	import flash.geom.Point;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.events.Event;
    import flash.display.BitmapData;
    import flash.display.Bitmap;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.BlurFilter;
	import flash.filters.*;
	import flash.geom.Rectangle;
	import flash.geom.ColorTransform;
	
	
	

	
    import flash.display.Sprite;
    import fl.controls.NumericStepper;
	
	 
	
	public class draw extends Sprite {

		
		//private var pointsGenerator:RWPointsGenerator = new RWPointsGenerator();
		
		
        public static const WIDTH:uint = 1000;  
        public static const HEIGHT:uint = 1000;        
        
		public static const V_MAX:Number = 1;
		public static const D_MAX:Number = 10;
		
        public static const PARTICLES:uint = 6200;
        
        
        
		
        
        private var __screen:Bitmap;   
        private var __blankBitmapData:BitmapData;
        
        private var __lastMouse:Point = new Point();      
        private var __mouseIsDown:Boolean = false;
        
        //private var __info:Info = new Info();
        //private var __debug:Debug = new Debug();
		
		private var filter:BlurFilter = new BlurFilter(3,3,BitmapFilterQuality.HIGH);

		//private var darn:BitmapData = new inna();
		//private var dude:BitmapData = new cat();
		
		private var inputImage:BitmapData = new inna();
		
		
		
		private var WEIGHT:Number = 0;
		
		
		
		var generator:RWPointsGenerator;
		
		var randomWalkModel:RWModel;
		
		

		//private var pointsGenerator:RWPointsGenerator;
		
		public function draw() {
			
			if(stage!=null){
                __init()
            }else{
                addEventListener(Event.ADDED_TO_STAGE,__onAddedToStage);
            }			
			
		}
		
		private function __onAddedToStage($e:Event):void{
            removeEventListener(Event.ADDED_TO_STAGE,__onAddedToStage);
            __init();
        }
        
        /**
        * Setup Bitmaps and stuff
        **/
        private function __init():void{
            __screen = new Bitmap(new BitmapData(WIDTH,HEIGHT,true,0xFF000000),"auto",true);
            //__blankBitmapData = new BitmapData(WIDTH,HEIGHT,true,0x02000000);               
			__blankBitmapData = new BitmapData(WIDTH,HEIGHT,true,0xFF000000);               
			
            // adding the Screen
            addChild(__screen);  
            //addChild(__debug);            
            //__info.x = (WIDTH-__info.width)/2;
            //__info.y = (HEIGHT-__info.height)/2;
            //addChild(__info);
            
            // smooth motion please                   
            stage.frameRate = 60;
            // some listeners
            stage.addEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);           
            stage.addEventListener(Event.ENTER_FRAME,__onEnterFrame);          
			
			randomWalkModel = new RWModel(inputImage, inputImage, inputImage, WIDTH, HEIGHT, PARTICLES, 3, 10);
			//randomWalkModel.updateGenerator(inputImage, inputImage, 1);


			
        }           
       
		
		private function __render():void{  
			__screen.bitmapData.draw(__blankBitmapData);
			
			var dWeight:Number = 0.1;
			
			if (__mouseIsDown && WEIGHT < 1){
				//WEIGHT += dWeight;
				//randomWalkModel.updateMergeWeight(WEIGHT);
				//randomWalkModel.paletteR += 0.1;
				
				
				}
				
			if (!__mouseIsDown && WEIGHT > 0){
				//randomWalkModel.paletteR += 0.1;
				//WEIGHT -= dWeight;
				//randomWalkModel.updateMergeWeight(WEIGHT);
				}
				
			//randomWalkModel.paletteR += 0.1;
				
			randomWalkModel.nextIteration();
			randomWalkModel.drawModel(__screen.bitmapData, 3);
			
			//__screen.bitmapData.applyFilter(__screen.bitmapData, __screen.bitmapData.rect, new Point(0,0), filter);
			

		}
			
		 // Listeners
		private function __onEnterFrame($e:Event):void{   
            __render();
        }  
        
		private function __onMouseDown($e:MouseEvent):void{
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
            stage.addEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
            __mouseIsDown = true;
        }
        
        private function __onMouseUp($e:MouseEvent):void{
            stage.removeEventListener(MouseEvent.MOUSE_UP,__onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_DOWN,__onMouseDown);
            __mouseIsDown = false;
		
        }
		
		
	}   
        
       
		
		
	
}
	


import flash.filters.DropShadowFilter;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.text.TextField;


internal class Pixel{
    public var color:uint = 0xFF000000;
    public var x:Number;
    public var y:Number;
	
	public var vx:Number;
    public var vy:Number;
	
	
	
	//public var vx:Number = .0;
    //public var vy:Number = .0;
	
    public var v:Number = .0;
    public var direction:Number = .0;
	
    public function Pixel($x:Number,$y:Number, $v:Number, $dir:Number){
        x=$x;
        y=$y;
		
		v = $v;
		direction = $dir;
		
		
		
        //color = $color;       
    }
}


/**
* Info Field
**/
internal class Info extends TextField{    
    public var format:TextFormat = new TextFormat("_sans",32,0x333388,true);
    public function Info(){               
        filters = [new DropShadowFilter(2,45,0,.7,6,6,1.5,3)];           
        selectable = false;
        defaultTextFormat = format;
        autoSize = TextFieldAutoSize.LEFT;
        text="MOVE WHILE DOWN!";
    }
}

/**
* Debug Field
**/
internal class Debug extends TextField{
    public var format:TextFormat = new TextFormat("_sans",16,0x333388,true);
    public function Debug(){        
        filters = [new DropShadowFilter(2,45,0,.7,6,6,1.5,3)];   
        selectable = false;      
        defaultTextFormat = format;
        autoSize = TextFieldAutoSize.LEFT;
        text="0 Particles";
    }
    
    public function set particles($amount:uint):void {
        text=$amount+" Particles";
    }

}
/*
danilova@spb.bcs.ru
680 27 27 
8 921 647 27 79  анастасия 
*/
