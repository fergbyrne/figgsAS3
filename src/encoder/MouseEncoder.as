package encoder
{
	import flash.display.Sprite;

	public class MouseEncoder extends Encoder
	{
		private var _sprite:Sprite;
		
		public function MouseEncoder(subEncoders:Array=null)
		{
			super(subEncoders);
		}
		
		override public function encode():void {
			if(!_sprite) return;
			var mouseX:Number = _sprite.mouseX * _width / _sprite.width; // 0-1 * #bits = bit index of mouse X
			mouseX = _sprite.mouseX * _width / 1024; // 0-1 * #bits = bit index of mouse X
			var bitMask:String = "";
			for(var i:uint = 0; i < _width; i++) {
				//trace("bit "+i+" vs "+mouseX);
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