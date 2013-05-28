package encoder
{
	import flash.display.Sprite;
	import flash.net.SharedObject;

	public class MouseEncoder extends Encoder
	{
		private var _sprite:Sprite;
		
		public function MouseEncoder(subEncoders:Array=null)
		{
			_SOcode ="mouseSO";
			super(subEncoders);
			_max = 1024;
			_min = 0;
		}
		
		override public function encode():void {
			var mouseX:Number;
			var x:Number;
			if(_recordLoaded) {
				if(!_sprite) return;
				x = _sprite.mouseX;
			} else {
				if(_recordedValues && _loadedValues.length > 0) {
					x = _loadedValues.shift();
					//trace("popped "+x+" ["+_loadedValues.length+"]");
				} else {
					_recordLoaded = true;
					trace("loaded mouse log ["+_recordedValues.length+"]");
					return;
				}
			}
			mouseX = encoding(x);
			if(mouseX == _lastEncoding) {
				_changed = false;
				return;
			}
			_recordedValues.push(x);
			if(_recordedValues.length % 100 == 0) {
				trace("saving mouse log ["+_recordedValues.length+"]");
				_recording.setProperty("mouseValues",_recordedValues);
			}
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
			_lastEncoding = mouseX;
			_changed = true;
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