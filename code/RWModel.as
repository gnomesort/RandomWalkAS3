package  code {
	
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
	

	public class RWModel {
		
		public var capacity:uint;
		
		private var modelWidth:uint = 1000;  
        private var modelHeight:uint = 1000;        
        
		private var vMax:Number = 1;
		private var dMax:Number = 10;
		
		private var bitmap:BitmapData;
		private var template:BitmapData;

		public var quantum:Vector.<RWQuantum> = new Vector.<RWQuantum>; 
		public var generator:RWPointsGenerator;
		
		private var invertion:Boolean = false;

		
		private var ratio:Point = new Point();

		
		public function RWModel(_bitmap:BitmapData, _template:BitmapData, _width:uint, _height:uint, _capacity:uint, _vmax:Number = 1, _dmax:Number = 10) {
			// constructor code
			
			bitmap = _bitmap;
			template = _template;
			capacity = _capacity;
			modelWidth = _width;
			modelHeight = _height;
			vMax = _vmax;
			dMax = _dmax;
			
			
			ratio.x = (bitmap.width-1)/(modelWidth);
			ratio.y = (bitmap.height-1)/(modelHeight);
			
			
			generator = new RWPointsGenerator(template);
			
			for(var k:uint=0; k<capacity; k++){
					var point:Point = generator.generatePoint();

					var pix:RWQuantum = new RWQuantum(point.x, point.y, 0.5, Math.random()*Math.PI*2);
					quantum.push(pix);
				}
			
			
			
		}
		
		public function  nextIteration(){
			
			var DV:uint = 5;
			var eps:Number = 0.9;
			var pwr:Number = 10.0;
			var pnt:Point = new Point(0,0);
			
			
			var row, col:uint;
			var val, valR, valG, valB :Number;
			var r, R, area:Number;
			R = modelWidth/2;
			area = 30;
			
			for(var i:uint=0; i<capacity; i++){
			
				row = Math.round(quantum[i].y * ratio.y);
				col = Math.round(quantum[i].x * ratio.x);
				
			
				
				valR = 1 - bitmap.getPixel(col,row)%256;
				valG = 1 - bitmap.getPixel(col,row)%(256*256)/256;
				valB = 1 - bitmap.getPixel(col,row)/256/256;
				
				val = 1 - bitmap.getPixel(col,row)%256/256;
				
				if (invertion == true) val = 1 - val;
				
				quantum[i].v = vMax * Math.pow(val, pwr) * DV + eps;
				
				//if ( dude.getPixel(ClR,RwR) == 40931) 
				//	pixelsR[i].v = 1;
				
				quantum[i].direction += (Math.random() - 0.5)*Math.PI * dMax/180;
				
				quantum[i].vx = quantum[i].v * Math.cos(quantum[i].direction);
				quantum[i].vy = quantum[i].v * Math.sin(quantum[i].direction);
				
				
				quantum[i].x += quantum[i].vx;
				quantum[i].y += quantum[i].vy;
				
				
				
				r = (quantum[i].x - modelWidth/2)*(quantum[i].x - modelHeight/2) + (quantum[i].y - modelWidth/2)*(quantum[i].y - modelHeight/2);
				r = Math.pow(r,0.5)/R;
				r = Math.pow(r,10);
				
				if (Math.random() < r) {
					
					var point:Point = generator.generatePoint();
					quantum[i].x = point.x;
					quantum[i].y = point.y;
					quantum[i].v = 0.01;
					
					
				}
				
				
			}

			
		}
		
		public function drawModel(bitmapDataDst:BitmapData){
			
			var ln:Number = 2;
			var clrPow:Number = 5;
			var clr:Number; 
			
			for(var i:uint=0; i<capacity; i++){
				
				for (var l:int = 0; l<ln; l++){
					clr = 1; //= - Math.pow((pixelsR[i].v-eps)/V_MAX/DV, clrPow);
					bitmapDataDst.setPixel(Math.round(quantum[i].x - quantum[i].vx * l/ln), 
												 Math.round(quantum[i].y - quantum[i].vy * l/ln),
												 Math.round(clr * 000) * (256*256)  +  
												 Math.round(clr * 200) * (256)  +  
												 Math.round(clr * 250) * (1));
					
					
				}
			}

		}

	}
	
}

internal class RWQuantum {
    public var color:uint = 0xFF000000;
    public var x:Number;
    public var y:Number;
	
	public var vx:Number;
    public var vy:Number;
	
	
	
	//public var vx:Number = .0;
    //public var vy:Number = .0;
	
    public var v:Number = .0;
    public var direction:Number = .0;
	
    public function RWQuantum($x:Number,$y:Number, $v:Number, $dir:Number){
        x=$x;
        y=$y;
		
		v = $v;
		direction = $dir;
		
		
		
        //color = $color;       
    }
}

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

internal class RWPointsGenerator {

		public var binaryMask:BitmapData;
		public var density:int;
		
		private var generator:Vector.<Point> = new Vector.<Point>;
		
		
		public function RWPointsGenerator(bmp:BitmapData, dns:int = 5) {
			
			density = dns;
			for (var x:int = 0; x < bmp.width; x +=density)
				for (var y:int = 0; y < bmp.height; y +=density){
					if (bmp.getPixel(x,y) != 0)
						generator.push(new Point(x,y));
					}
			
		}
		
		public function generatePoint():Point {
			
			var index:int = Math.round(Math.random()*(generator.length - 1));
			return generator[index];
			
		}

	}