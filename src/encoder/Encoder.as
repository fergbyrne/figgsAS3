package encoder
{
	import flash.display.Graphics;
	import flash.net.SharedObject;

	public class Encoder
	{
		protected var _bits:Array;
		protected var _values:Array;
		protected var _width:uint = 128;
		protected var _bucketWidth:uint = 28;
		protected var _subEncoders:Array;
		protected var _max:Number = 1024;
		protected var _min:Number = 0;	
		protected var _lastEncoding:uint;
		protected var _changed:Boolean = true;
		protected var _SOcode:String = "encoderSO";
		protected var _recording:SharedObject;
		protected var _recordedValues:Array;
		protected var _loadedValues:Array;
		protected var _recordLoaded:Boolean = false;
		
		public function Encoder(subEncoders:Array = null)
		{
			_bits = new Array(_width);
			_values = new Array(_width);
			_subEncoders = subEncoders;
			_recording = SharedObject.getLocal(_SOcode);
			_loadedValues = _recording.data.mouseValues;
			_recordedValues = new Array();
			if(_loadedValues == null) _recordLoaded = true;
			else {
				trace("loading recording "+_loadedValues.length+" items");
			}
		}
		
		public function encode():void {
			if(_subEncoders) {
				var i:uint = 0;
				for(var j:uint = 0; j < _subEncoders.length; j++) {
					var sub:Encoder = _subEncoders[j];
					if(sub) {
						sub.encode();
						for(var k:uint = 0; k < sub.bits.length; k++) {
							_bits[i] = sub.bits[k];
							_values[i] = sub.values[k];
							i++;
						}
					}
				}
			}
		}
		
		public function draw(graphics:Graphics):void {
			graphics.lineStyle(1.0,0xCCCCCC, 0.8);
			for(var i:uint = 0; i < _width; i++) {
				if(_bits[i]) {
					graphics.beginFill(0x99FF99, 0.5);
				} else {
					graphics.beginFill(0xFF9999, 0.5);
				}
				graphics.drawCircle(6 * i, 6, 3);
				graphics.endFill();
			}
		}

		public function get bits():Array
		{
			return _bits;
		}

		public function set bits(value:Array):void
		{
			_bits = value;
		}

		public function get width():uint
		{
			return _width;
		}

		public function set width(value:uint):void
		{
			_width = value;
		}

		public function get values():Array
		{
			return _values;
		}

		public function set values(value:Array):void
		{
			_values = value;
		}
		public function get changed():Boolean
		{
			return _changed;
		}
		
		public function set changed(value:Boolean):void
		{
			_changed = value;
		}

		public function get recordLoaded():Boolean
		{
			return _recordLoaded;
		}

		public function set recordLoaded(value:Boolean):void
		{
			_recordLoaded = value;
		}


	}
}