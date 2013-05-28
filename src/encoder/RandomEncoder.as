package encoder
{
	public class RandomEncoder extends Encoder
	{
		protected var _threshold:Number = 0.3;
		
		public function RandomEncoder(subEncoders:Array=null)
		{
			super(subEncoders);
		}
		
		override public function encode():void {
			for(var i:uint = 0; i < _width; i++) {
				if(Math.random() < _threshold) {
					_bits[i] = true;
				} else {
					_bits[i] = false;
				}
			}
		}
	}
}