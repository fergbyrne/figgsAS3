package
{
	import cla.Region;
	
	import encoder.*;
	
	import flash.display.Sprite;
	import flash.events.Event;
	[SWF (backgroundColor="0xEEFFFF", width="1024", height="568", frameRate="60")]	
	public class FBCLA extends Sprite
	{
		private var _region:Region;
		private var _encoder:Encoder;
		private var _frames:uint = 0;
		private var _done:uint = 0;
		
		public function FBCLA()
		{
			init();
		}
		
		protected function init():void {
			Region.stage = this;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_region = new Region();
			//_encoder = new RandomEncoder();
			var mEncoder:MouseEncoder = new MouseEncoder();
			mEncoder.sprite = this;
			_encoder = mEncoder;
			_region.encoder = _encoder;
			_region.draw();
		}
		
		protected function onEnterFrame(e:Event):void {
			//return;
			_frames += 1;
			if(_region && !_region.drawing) {
				_encoder.encode();
				if(_encoder.changed) {
					_region.spatialPooler();
					graphics.clear();
					_region.draw();
					_done += 1;					
				}
			}
			if(_frames == 25) {
				trace("FPS = "+_done);
				_done = 0;
				_frames = 0;
			}
		}
	}
}