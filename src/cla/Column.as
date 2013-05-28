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
		private var _beenActive:uint = 0;
		private var _isActivating:Boolean = false;
		private var _previousActivity:Boolean = false;
		private var _visited:Boolean = false;
		
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
			drawInputs(graphics, xy);
			//trace("draw column["+_index+"] at pos["+pos[0]+","+pos[1]+"] ["+xy[0]+","+xy[1]+"] scale("+Region.scale+")");
			for(var i:uint = 0; i < _cells.length; i++) {
				_cells[i].draw(graphics, xy);
			}
			for(i = _beenActive; i > 0; i--) {
				graphics.beginFill(0x99FFFF, 0.8);
				graphics.drawCircle(x + i * 3, y - i, i + 3);
				graphics.endFill();
			}
		}

		public function drawInputs(graphics:Graphics, xy:Array):void
		{
			var e:Encoder = _region.encoder;
			var bits:Array = e.bits;
			for(var i:uint = 0; i < _inputs.length; i++) {
				var x:Number = xy[0] + 5 + 2 * i;
				var y:Number = xy[1] - 5;

				var connection:Array = _inputs[i];
				var index:uint = connection[0];
				var permanence:Number = connection[1];
				if(bits[index]) {
					graphics.beginFill(0xAA0000,permanence);
				} else {
					graphics.beginFill(0xccccff,permanence);
				}
				if(permanence > Region.permanenceThreshold) {
					graphics.lineStyle(1.0,0xCCFFCC, 1.0);
				} else {
					graphics.lineStyle(1.0,0xCCCCFF, permanence);
				}			
				graphics.drawRect(x, y - permanence * 5, 2, 2);
				graphics.endFill();
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
				if(Region.learnOnes) {
					if(bits[index]) {
						_inputs[i][1] += Region.incSensorPermanence;
					} else if(permanence > Region.permanenceThreshold) {
						_inputs[i][1] -= Region.decSensorPermanence;					
					}					
				} else {
					if(bits[index]) {
						_inputs[i][1] += Region.incSensorPermanence;
					} else {
						_inputs[i][1] -= Region.decSensorPermanence;					
					}
				}
				if(_inputs[i][1] > 1) _inputs[i][1] = 1;
				if(_inputs[i][1] < 0) _inputs[i][1] = 0;
				if(permanence > Region.permanenceThreshold) {
				}
			}			
		}

		public function get beenActive():uint
		{
			return _beenActive;
		}

		public function set beenActive(value:uint):void
		{
			_beenActive = value;
		}

		public function get isActivating():Boolean
		{
			return _isActivating;
		}

		public function set isActivating(value:Boolean):void
		{
			if(value != _isActivating) _previousActivity = _isActivating;
			_isActivating = value;
		}

		public function get visited():Boolean
		{
			return _visited;
		}

		public function set visited(value:Boolean):void
		{
			_visited = value;
		}


	}
}