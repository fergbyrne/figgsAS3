package cla
{
	import encoder.Encoder;
	
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class Region
	{
		private var _columns:Array;
		private var _width:uint;
		private var _encoder:Encoder;
		private var _drawing:Boolean = false;
		private var _activeColumns:Array;	// sorted list of top columns by activity
		
		public static var regionWidth:uint = 32;
		public static var columnCells:uint = 16;
		public static var cellDendrites:uint = 16;
		public static var dendriteSize:uint = 16;
		public static var permanenceThreshold:Number = 0.2;
		public static var columnInputs:uint = 50; // percent of encoder bits feeding each column
		public static var stage:Sprite;
		public static var scale:Number = 1.0;
		public static var sparcity:Number = 2.0; // percent of columns which will be chosen as active
		public static var incSensorPermanence:Number = 0.01;
		public static var decSensorPermanence:Number = 0.002;
		public static var inhibitionDistance:Number = 10;
		public static var learnConnections:Boolean = false;

		public function Region(n:uint = 0)
		{
			trace("Region");
			_width = (n == 0) ? Region.regionWidth : n;
			_columns = new Array(_width * _width * 2);
			for(var i:uint = 0; i < _columns.length; i++) {
				_columns[i] = new Column(this, i);
			}
			var activeSize:uint = _columns.length * (sparcity / 100.0);
			_activeColumns = new Array(activeSize);
			for(i = 0; i < _activeColumns.length; i++) {
				_activeColumns[i] = -1;
			}
		}

		public function get encoder():Encoder
		{
			return _encoder;
		}

		public function set encoder(value:Encoder):void
		{
			if(_encoder == value) return;
			_encoder = value;
			for(var i:uint = 0; i < _columns.length; i++) {
				_columns[i].connectEncoder();
			}
		}

		public function spatialPooler():void
		{
			var topCol:Column, lastCol:Column;
			var activation:uint = 0;
			var a:uint = 0;
			// clear the array of top active columns
			for(var j:uint = 0; j < _activeColumns.length; j++) {
				var col:int = _activeColumns[j];
				var xy:Array = columnGridPosition(col);
				//trace("active ["+col+"] at ("+xy[0]+","+xy[1]+")");
				_activeColumns[j] = -1;
			}
			for(var i:uint = 0; i < _columns.length; i++) {
				var thisColumn:Column = _columns[i];
				thisColumn.readInputs();
				var thisXY:Array = columnGridPosition(i);
				var thatXY:Array;
				activation += thisColumn.activeInputs;
				for(j = 0; j < _activeColumns.length; j++) {
					if(_activeColumns[j] == -1) { // empty position
						_activeColumns[j] = i;
						j = _activeColumns.length;
					} else {
						var thatColumn:Column = _columns[_activeColumns[j]];
						//trace("checking column ["+i+"] ("+thisColumn.activeInputs+") vs ["+_activeColumns[j]+"] ("+thatColumn.activeInputs+")"); 
						if(thisColumn.activeInputs >= thatColumn.activeInputs) {
							thatXY = columnGridPosition(_activeColumns[j]);
							if(Math.abs(thisXY[0] - thatXY[0] + thisXY[1] - thatXY[1]) > Region.inhibitionDistance) {
								// shove the lower-activation columns down the list
								for(var k:uint = _activeColumns.length - 1; k > j; k--) {
									_activeColumns[k] = _activeColumns[k - 1];
								}
							}
							// insert this column in the list
							_activeColumns[j] = i;
							if(learnConnections) thisColumn.strengthenInputs();
							// end the search
							j = _activeColumns.length;
						}
					}
				}
			
			}
			topCol = _columns[_activeColumns[0]];
			lastCol = _columns[_activeColumns[_activeColumns.length - 1]];
			var average:Number = activation / _columns.length;
			//trace(""+_activeColumns.length+"/"+_columns.length+" active columns ["+lastCol.activeInputs+"-"+topCol.activeInputs+"] avg = "+average);
		}

		public function draw():void
		{
			if(_drawing) return;
			_drawing = true;
			var offset:Array = columnGridPosition(0);
			offset[0] += 50; offset[1] += 50;
			scale = stage.width / (_width * 2);
			scale = 1024.0 / (_width * 2.0);
			//trace("stage.width = "+stage.width+" so scale is "+scale+".");
			var graphics:Graphics = stage.graphics;
			for(var i:uint = 0; i < _activeColumns.length; i++) {
				if(_activeColumns[i] > -1) {
					var column:Column = _columns[_activeColumns[i]];
					column.draw(graphics, offset);					
				}
			}
			_encoder.draw(graphics);
			_drawing = false;
		}
		
		public function columnGridPosition(i:uint):Array {
			var ix:uint = (i / (_width * 2));
			var iy:uint = i % _width;
			//trace("grid for "+i+" at ("+ix+","+iy+")");
			var result:Array = new Array(2);
			result[0] = ix; result[1] = iy;
			return result;
		}

		public function get drawing():Boolean
		{
			return _drawing;
		}

		public function set drawing(value:Boolean):void
		{
			_drawing = value;
		}

	}
}