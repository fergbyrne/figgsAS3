package encoder
{
	import flash.display.Sprite;

	public class MouseEncoder extends Encoder
	{
		private var _sprite:Sprite;
		private var _max:Number = 1024;
		private var _min:Number = 0;		
		
		public function MouseEncoder(subEncoders:Array=null)
		{
			super(subEncoders);
		}
		
		override public function encode():void {
			if(!_sprite) return;
			var mouseX:Number = encoding(_sprite.mouseX);
			var bitMask:String = "";
			for(var i:uint = 0; i < _width; i++) {
				//trace("bit "+i+" vs "+mouseX);
				_values[i] = value(i);
				if(Math.abs(i - mouseX) <= (_bucketWidth / 2)) {
					//trace("bit "+i+" set");
					_bits[i] = true;
				} else {
					_bits[i] = false;
				}
				bitMask = "" + bitMask + ((_bits[i]) ? "1" : "0");
			}
			//trace(bitMask+"\t"+mouseX);
		}

		public function encoding(value:Number):int
		{
			//return value * _width / _sprite.width; // 0-1 * #bits = bit index of mouse X
			return value * _width / (_max - _min);
		}
		
		public function value(bit:uint):Number
		{
			return bit * (_max - _min) / _width;
		}
		
		public function get sprite():Sprite
		{
			return _sprite;
		}

		public function set sprite(value:Sprite):void
		{
			_sprite = value;
		}


	}
}