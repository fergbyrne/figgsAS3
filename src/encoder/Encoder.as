package encoder
{
	import flash.display.Graphics;

	public class Encoder
	{
		protected var _bits:Array;
		protected var _width:uint = 128;
		protected var _bucketWidth:uint = 28;
		protected var _subEncoders:Array;
		
		public function Encoder(subEncoders:Array = null)
		{
			_bits = new Array(_width);
			_subEncoders = subEncoders;
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


	}
}