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
		
		private var DV:uint = 1;
		private var eps:Number = 0.9;
		
		public var bitmap:BitmapData;
		private var template:BitmapData;

		public var quantum:Vector.<RWQuantum> = new Vector.<RWQuantum>; 
		
		//public var generator:RWPointsGenerator;
		public var generator:RWMergeGenerator;
		
		private var invertion:Boolean = false;

		
		private var ratio:Point = new Point();
		
		public var merge:Boolean = false;

		
		public function RWModel(_bitmap:BitmapData, _template1, _template2:BitmapData, _width:uint, _height:uint, _capacity:uint, _vmax:Number = 1, _dmax:Number = 10) {
			// constructor code
			
			bitmap = _bitmap;
			template = _template1;
			capacity = _capacity;
			modelWidth = _width;
			modelHeight = _height;
			vMax = _vmax;
			dMax = _dmax;
			
			
			ratio.x = (bitmap.width-1)/(modelWidth);
			ratio.y = (bitmap.height-1)/(modelHeight);
			
			
			//generator = new RWPointsGenerator(template);
			generator = new RWMergeGenerator(_template1, _template2, 0);
			
			for(var k:uint=0; k<capacity; k++){
					var point:Point = generator.generatePoint();

					var pix:RWQuantum = new RWQuantum(point.x, point.y, 0.5, Math.random()*Math.PI*2);
					quantum.push(pix);
				}
			
			
			
		}
		
		public function  nextIteration(){
			
			
			var pwr:Number = 0.1;
			var pnt:Point = new Point(0,0);
			
			
			var row, col:uint;
			var val, valR, valG, valB :Number;
			var r, R, area:Number;
			R = modelWidth/2;
			
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
				
				quantum[i].direction += (Math.random() - 0.5)*Math.PI * dMax*vMax/180;
				
				quantum[i].vx = quantum[i].v * Math.cos(quantum[i].direction);
				quantum[i].vy = quantum[i].v * Math.sin(quantum[i].direction);
				
				
				quantum[i].x += quantum[i].vx;
				quantum[i].y += quantum[i].vy;
				
				
				
				//r = (quantum[i].x - modelWidth/2)*(quantum[i].x - modelHeight/2) + (quantum[i].y - modelWidth/2)*(quantum[i].y - modelHeight/2);
				//r = Math.pow(r,0.5)/R;
				//r = Math.pow(r,10);
				
				//r = Math.pow((quantum[i].v - eps)/vMax, 40);
				r = 0.1;
				
				if (Math.random() < r) {
					
					var point:Point = generator.generatePoint();
					quantum[i].x = point.x;
					quantum[i].y = point.y;
					quantum[i].v = 0.01;
					
					
				}
				
				
			}

			
		}
		
		public function drawModel(bitmapDataDst:BitmapData, tail:uint = 5){
			
			var ln:Number = tail;
			var clrPow:Number = 5;
			var clr:Number; 
			
			for(var i:uint=0; i<capacity; i++){
				
				for (var l:int = 0; l<ln; l++){
					clr = 1;// - Math.pow((quantum[i].v-eps)/vMax/DV, clrPow);
					bitmapDataDst.setPixel(Math.round(quantum[i].x - quantum[i].vx * l/ln), 
												 Math.round(quantum[i].y - quantum[i].vy * l/ln),
												 Math.round(clr * 000) * (256*256)  +  
												 Math.round(clr * 200) * (256)  +  
												 Math.round(clr * 250) * (1));
					
					
				}
			}

		}
		
		
		public function updateGenerator(_template1, _template2:BitmapData, _weight:Number, dns:uint = 5){
			
			generator = new RWMergeGenerator(_template1, _template2, _weight, dns);
			
		}
		
		public function updateMergeWeight(_weight:Number){
			
			generator.weight = _weight;
			
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
    import flash.geom.Matrix;
    
    import flash.display.BitmapData;
    import flash.display.Bitmap;

 internal class RWPointsGenerator {

		public var binaryMask:BitmapData;
		public var density:int;
		
		public var generator:Vector.<Point> = new Vector.<Point>;
		
		
		public function RWPointsGenerator(bmp:BitmapData, dns:int = 5) {
			
			density = dns;
			//density = 50;
			
			var valueR, valueG, valueB:Number;
			var p:Point;
			
			for (var x:int = 0; x < bmp.width; x +=density)
				for (var y:int = 0; y < bmp.height; y +=density){
					
					valueR = bmp.getPixel(x,y)%256;
					valueG = bmp.getPixel(x,y)%(256*256)/256;
					valueB = bmp.getPixel(x,y)/256/256;
					
					//if (bmp.getPixel(x,y) != 0)
					if ((valueR>50)||(valueG>50)||(valueB>50)){
						p = new Point(Math.round(x + (Math.random()-0.5)*density),
											Math.round(y + (Math.random()-0.5)*density));
						generator.push(p);
					}
					
				}
			
		}
		
		public function generatePoint():Point {
			
			var index:int = Math.round(Math.random()*(generator.length - 1));
			return generator[index];
			
		}
		
		

}

internal class RWMergeGenerator{
	
	public var generator1:RWPointsGenerator;
	public var generator2:RWPointsGenerator;
	public var weight:Number;
	
	public function RWMergeGenerator(bmp1, bmp2:BitmapData, _weight:Number, dns:int = 5) {
			generator1 = new RWPointsGenerator(bmp1, dns);
			generator2 = new RWPointsGenerator(bmp2, dns);
			weight = _weight;
	}
	
	public function generatePoint():Point {
			var index:int;
			if (Math.random() > weight){
				return generator1.generatePoint();
			} else {
				return generator2.generatePoint();
			}
			
			
		} 

}
	