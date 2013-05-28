package cla
{
	import encoder.Encoder;
	
	import flash.display.Graphics;

	public class Column
	{
		private var _region:Region;
		private var _cells:Array;
		private var _inputs:Array;
		private var _index:uint;
		private var _activeInputs:uint;
		
		public function Column(region:Region, index:uint)
		{
			_region = region;
			_index = index;
			_cells = new Array(Region.columnCells);
			for(var i:uint = 0; i < _cells.length; i++) {
				_cells[i] = new Cell(this, i);
			}
		}
		
		public function connectEncoder():void {
			var e:Encoder = _region.encoder;
			var bits:Array = e.bits;
			_inputs = new Array();
			for(var i:uint = 0; i < bits.length; i++) {
				if(Math.random() < (Region.columnInputs / 100.0)) {
					var connection:Array = new Array(3);
					connection[0] = i;
					connection[1] = Region.permanenceThreshold * (Math.random() + 0.5);  
					_inputs.push(connection);
				}
			}
		}
		
		public function readInputs():void {
			var e:Encoder = _region.encoder;
			var bits:Array = e.bits;
			_activeInputs = 0;
			for(var i:uint = 0; i < _inputs.length; i++) {
				var connection:Array = _inputs[i];
				var index:uint = connection[0];
				var permanence:Number = connection[1];
				if(permanence > Region.permanenceThreshold) {
					if(bits[index]) {
						_activeInputs++;
					}
				}
			}
		}
		
		public function draw(graphics:Graphics, offset:Array):void {
			var pos:Array = _region.columnGridPosition(_index);
			var xy:Array = new Array(2);
			var x:Number = offset[0] + (1.0 * pos[0] * Region.scale);
			var y:Number = offset[1] + (1.0 * pos[1] * Region.scale);
			xy[0] = x; xy[1] = y;
			var scale:Number = 20.0 / _region.encoder.bits.length;
			graphics.lineStyle(1.0,0xCCCCCC, 0.8);
			graphics.beginFill(0xAA0000,_activeInputs * scale / 20);
			graphics.drawCircle(x, y, _activeInputs * scale + 6);
			graphics.endFill();
			//trace("draw column["+_index+"] at pos["+pos[0]+","+pos[1]+"] ["+xy[0]+","+xy[1]+"] scale("+Region.scale+")");
			for(var i:uint = 0; i < _cells.length; i++) {
				_cells[i].draw(graphics, xy);
			}
		}

		public function get activeInputs():uint
		{
			return _activeInputs;
		}

		public function set activeInputs(value:uint):void
		{
			_activeInputs = value;
		}

		public function strengthenInputs():void
		{
			var e:Encoder = _region.encoder;
			var bits:Array = e.bits;
			_activeInputs = 0;
			for(var i:uint = 0; i < _inputs.length; i++) {
				var connection:Array = _inputs[i];
				var index:uint = connection[0];
				var permanence:Number = connection[1];
				if(bits[index]) {
					_inputs[i][1] += Region.incSensorPermanence;
				} else {
					_inputs[i][1] -= Region.decSensorPermanence;					
				}
				if(permanence > Region.permanenceThreshold) {
				}
			}			
		}
	}
}