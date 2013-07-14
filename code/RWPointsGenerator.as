package  code {
	
	import flash.display.BitmapData;
    import flash.display.Bitmap;
    import flash.geom.Point;
	
	public class RWPointsGenerator {

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
	
}
