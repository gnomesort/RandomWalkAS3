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
		
        public static const PARTICLES:uint = 500;
        
        
        private var pixelsR:Vector.<Pixel> = new Vector.<Pixel>
		private var pixelsG:Vector.<Pixel> = new Vector.<Pixel>
		private var pixelsB:Vector.<Pixel> = new Vector.<Pixel>
		
        
        private var __screen:Bitmap;   
        private var __blankBitmapData:BitmapData;
        
        private var __lastMouse:Point = new Point();      
        private var __mouseIsDown:Boolean = false;
        
        //private var __info:Info = new Info();
        //private var __debug:Debug = new Debug();
		
		private var filter:BlurFilter = new BlurFilter(3,3,BitmapFilterQuality.HIGH);
		
		private var dude:BitmapData = new dudaism();
		
		

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
            __blankBitmapData = new BitmapData(WIDTH,HEIGHT,true,0x02000000);               
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
			
			
			for(var k:uint=0; k<PARTICLES; k++){
				//var pix:Pixel = new Pixel(Math.random()*WIDTH, Math.random()*HEIGHT, Math.random()*V_MAX, Math.random()*Math.PI*2);
				var pix:Pixel = new Pixel(WIDTH/2, HEIGHT/2, Math.random()*V_MAX, Math.random()*Math.PI*2);
				pixelsR.push(pix);
			}
			
			for(var k:uint=0; k<PARTICLES; k++){
				//var pix:Pixel = new Pixel(Math.random()*WIDTH, Math.random()*HEIGHT, Math.random()*V_MAX, Math.random()*Math.PI*2);
				var pix:Pixel = new Pixel(WIDTH/2, HEIGHT/2 - 0, Math.random()*V_MAX, Math.random()*Math.PI*2);
				pixelsG.push(pix);
			}
			
			for(var k:uint=0; k<PARTICLES; k++){
				//var pix:Pixel = new Pixel(Math.random()*WIDTH, Math.random()*HEIGHT, Math.random()*V_MAX, Math.random()*Math.PI*2);
				var pix:Pixel = new Pixel(WIDTH/2, HEIGHT/2, Math.random()*V_MAX, Math.random()*Math.PI*2);
				pixelsB.push(pix);
			}

			
        }           
        
        /**
        * Render the particles
        **/        
        private function __render():void{  
			
			__screen.bitmapData.draw(__blankBitmapData);
			
			
		
			var DV:uint = 5;
			var eps:Number = 0.9;
			var pwr:Number = 10.0;
			var pnt:Point = new Point(0,0);
			var dmax:Number = 50;
			var valInv = false;
			
			//var generator1:Point = new Point(390,408);
			//var generator2:Point = new Point(615,402);
			
			var generator1:Point = new Point(500,500);
			var generator2:Point = new Point(500,500);
			
			
			
			
			for(var i:uint=0; i<PARTICLES; i++){
				
				/*
				var eyeColor:Number = dude.getPixel(400,400); // 429511
				
				var eyeColor1:Number = dude.getPixel(401,400); //40931
				var eyeColor2:Number = dude.getPixel(402,401);
				var eyeColor3:Number = dude.getPixel(402,402);
				*/
				
				
				var ratioX:Number = (dude.width-1)/(WIDTH);
				var ratioY:Number = (dude.height-1)/(HEIGHT);
				
				
				var iW:uint = dude.width;
				var iH:uint = dude.height;
				
								
				//    ------------------- RED ------------------     //
				
				
				var RwR:uint = Math.round(pixelsR[i].y * ratioY);
				var ClR:uint = Math.round(pixelsR[i].x * ratioX);
				
				var valR:Number = 1 - dude.getPixel(ClR,RwR)%256 / 256.0;
				
				var valR_:Number = 1 - dude.getPixel(ClR,RwR)%256;
				var valG_:Number = 1 - dude.getPixel(ClR,RwR)%(256*256)/256;
				var valB_:Number = 1 - dude.getPixel(ClR,RwR)/256/256;
				
				if (valInv == true) valR = 1 - valR;
				
				

				pixelsR[i].v = V_MAX * Math.pow(valR, pwr) * DV + eps;
				
				//if ( dude.getPixel(ClR,RwR) == 40931) 
				//	pixelsR[i].v = 1;
				
				pixelsR[i].direction += (Math.random() - 0.5)*Math.PI * dmax/180;
				
				pixelsR[i].vx = pixelsR[i].v * Math.cos(pixelsR[i].direction);
				pixelsR[i].vy = pixelsR[i].v * Math.sin(pixelsR[i].direction);
				
				
				pixelsR[i].x += pixelsR[i].vx;
				pixelsR[i].y += pixelsR[i].vy;
				
				/*
				if (pixelsR[i].x<0) pixelsR[i].x += WIDTH;
				if (pixelsR[i].y<0) pixelsR[i].y += HEIGHT;
				
				if (pixelsR[i].x>WIDTH-1) pixelsR[i].x -= WIDTH;
				if (pixelsR[i].x>HEIGHT-1) pixelsR[i].y -= HEIGHT;
				*/
				
				var R:Number = WIDTH/2;
				var area:Number = 30;
				
				var r:Number = (pixelsR[i].x - WIDTH/2)*(pixelsR[i].x - WIDTH/2) + (pixelsR[i].y - HEIGHT/2)*(pixelsR[i].y - HEIGHT/2);
				r = Math.pow(r,0.5)/R;
				r = Math.pow(r,10);
				
				
				//var r = (pixelsR[i].v -eps)/V_MAX/DV;
				//var r = Math.pow((pixelsR[i].v-eps)/V_MAX/DV, 1);
				
				//var eyeL:Point =  new Point(WIDTH/2 + 240 , HEIGHT/2 + 200);
				//var eyeR:Point =  new Point(WIDTH/2 + 005 , HEIGHT/2 + 23);
				
				var eyeL:Point =  generator1;
				var eyeR:Point =  generator2;
				
				
				if (Math.random() < r) {
					
					if (Math.random()>0.5){
						pixelsR[i].x = eyeL.x + (Math.random() - 0.5)*area;
						pixelsR[i].y = eyeL.y + (Math.random() - 0.5)*area;
					}
					else {
						pixelsR[i].x = eyeR.x + (Math.random() - 0.5)*area;
						pixelsR[i].y = eyeR.y + (Math.random() - 0.5)*area;;
					}
					
				}
				
				//    ------------------- GREEN ------------------     //
	 			
				var RwG:uint = Math.round(pixelsG[i].y * ratioY);
				var ClG:uint = Math.round(pixelsG[i].x * ratioX);
				
				var valG:Number = 1 - dude.getPixel(ClG,RwG)%(256.0*256.0)/256.0 / 256.0;
				if (valInv == true) valG = 1 - valG;

				
				pixelsG[i].v = V_MAX * Math.pow(valG, pwr) * DV + eps;
				//if (dude.getPixel(ClR,RwR) == 40931) 
				//	pixelsG[i].v = 0.5;
				pixelsG[i].direction += (Math.random() - 0.5)*Math.PI * dmax/180;
				
				pixelsG[i].vx = pixelsG[i].v * Math.cos(pixelsG[i].direction);
				pixelsG[i].vy = pixelsG[i].v * Math.sin(pixelsG[i].direction);
				
				pixelsG[i].x += pixelsG[i].vx;
				pixelsG[i].y += pixelsG[i].vy;
				
				/*
				if (pixelsG[i].x<0) pixelsG[i].x += WIDTH;
				if (pixelsG[i].y<0) pixelsG[i].y += HEIGHT;
				
				if (pixelsG[i].x>WIDTH-1) pixelsG[i].x -= WIDTH;
				if (pixelsG[i].x>HEIGHT-1) pixelsG[i].y -= HEIGHT;
				*/
				
				R = WIDTH/2;
				area = 300;
				r = (pixelsG[i].x - WIDTH/2)*(pixelsG[i].x - WIDTH/2) + (pixelsG[i].y - HEIGHT/2)*(pixelsG[i].y - HEIGHT/2);
				r = Math.pow(r,0.5)/R;
				r = Math.pow(r,10);
				//eyeL =  new Point(WIDTH/2 + 240 , HEIGHT/2 + 200);
				//eyeR =  new Point(WIDTH/2 + 005 , HEIGHT/2 + 23);
				
				eyeL =  generator1;
				eyeR =  generator2;
				
				
				if (Math.random() < r && pixelsG[i].v > 0.1) {
					
					if (Math.random()>0.5){
						pixelsG[i].x = eyeL.x + (Math.random() - 0.5)*area;
						pixelsG[i].y = eyeL.y + (Math.random() - 0.5)*area;;
					}
					else {
						pixelsG[i].x = eyeR.x + (Math.random() - 0.5)*area;
						pixelsG[i].y = eyeR.y + (Math.random() - 0.5)*area;;
					}
					
				}
				
				//    ------------------- BLUE ------------------     //
				
				
				var RwB:uint = Math.round(pixelsB[i].y * ratioY);
				var ClB:uint = Math.round(pixelsB[i].x * ratioX);
				
				var valB:Number = 1 - dude.getPixel(ClB,RwB)/(256.0*256.0) / 256.0;
				if (valInv == true) valB = 1 - valB;
				
				pixelsB[i].v = V_MAX * Math.pow(valB, pwr) * DV + eps;
				//if (dude.getPixel(ClR,RwR) == 429511) 
				//	pixelsB[i].v = 0.05;
				pixelsB[i].direction += (Math.random() - 0.5)*Math.PI * dmax /180;
				
				pixelsB[i].vx = pixelsB[i].v * Math.cos(pixelsB[i].direction);
				pixelsB[i].vy = pixelsB[i].v * Math.sin(pixelsB[i].direction);
				
				pixelsB[i].x += pixelsB[i].vx;
				pixelsB[i].y += pixelsB[i].vy;

				
				R = WIDTH/2;
				area = 300;
				r = (pixelsB[i].x - WIDTH/2)*(pixelsB[i].x - WIDTH/2) + (pixelsB[i].y - HEIGHT/2)*(pixelsB[i].y - HEIGHT/2);
				r = Math.pow(r,0.5)/R;
				r = Math.pow(r,10);
				//eyeL =  new Point(WIDTH/2 + 240 , HEIGHT/2 + 200);
				//eyeR =  new Point(WIDTH/2 + 005 , HEIGHT/2 + 23);
				
				eyeL =  generator1;
				eyeR =  generator2;
				
				//eyeL =  new Point(500 , 300);
				//eyeR =  eyeL;
				
				
				if (Math.random() < r && pixelsB[i].v>0.1) {
					
					if (Math.random()>0.5){
						pixelsB[i].x = eyeL.x + (Math.random() - 0.5)*area;
						pixelsB[i].y = eyeL.y + (Math.random() - 0.5)*area;;
					}
					else {
						pixelsB[i].x = eyeR.x + (Math.random() - 0.5)*area;
						pixelsB[i].y = eyeR.y + (Math.random() - 0.5)*area;;
					}
					
				}
				
				
				/*
				if (pixelsB[i].x<0) pixelsB[i].x += WIDTH;
				if (pixelsB[i].y<0) pixelsB[i].y += HEIGHT;
				
				if (pixelsB[i].x>WIDTH-1) pixelsB[i].x -= WIDTH;
				if (pixelsB[i].x>HEIGHT-1) pixelsB[i].y -= HEIGHT;
				*/
				//var r:Number = 
				//var trp:Number = Math.cos();
				
				//__screen.bitmapData.setPixel(Math.round(pixelsR[i].x), Math.round(pixelsR[i].y), 00 * (256*256)  +  150 * (256)  +  250 * (1));
				//__screen.bitmapData.setPixel(Math.round(pixelsG[i].x), Math.round(pixelsG[i].y), 00 * (256*256)  +  200 * (256)  +  250 * (1));
				//__screen.bitmapData.setPixel(Math.round(pixelsB[i].x), Math.round(pixelsB[i].y), 00 * (256*256)  +  100 * (256)  +  200 * (1));
				

				var ln:Number = 2;
				var clrPow:Number = 5;
				var clrR:Number = 1;// - Math.pow((pixelsR[i].v-eps)/V_MAX/DV, clrPow);
				var clrG:Number = 1;// - Math.pow((pixelsG[i].v-eps)/V_MAX/DV, clrPow);
				var clrB:Number = 1;// - Math.pow((pixelsB[i].v-eps)/V_MAX/DV, clrPow);
				
				
				for (var l:int = 0; l<ln; l++){
					
					__screen.bitmapData.setPixel(Math.round(pixelsR[i].x - pixelsR[i].vx * l/ln), 
												 Math.round(pixelsR[i].y - pixelsR[i].vy * l/ln),
												 Math.round(clrR * 000) * (256*256)  +  
												 Math.round(clrR * 200) * (256)  +  
												 Math.round(clrR * 250) * (1));
					
					/*
					__screen.bitmapData.setPixel(Math.round(pixelsG[i].x - pixelsG[i].vx * l/ln), 
												 Math.round(pixelsG[i].y - pixelsG[i].vy * l/ln), 
												 Math.round(clrG * 00) * (256*256)  +  
												 Math.round(clrG * 200) * (256)  +  
												 Math.round(clrG * 250) * (1));
					
					
					__screen.bitmapData.setPixel(Math.round(pixelsB[i].x - pixelsB[i].vx * l/ln), 
												 Math.round(pixelsB[i].y - pixelsB[i].vy * l/ln), 
												 Math.round(clrB * 250) * (256*256)  +  
												 Math.round(clrB * 200) * (256)  +  
												 Math.round(clrB * 000) * (1));
								*/			 
					
				}
               
			}
			//__screen.bitmapData.applyFilter(__screen.bitmapData, __screen.bitmapData.rect, pnt, filter);

			

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

