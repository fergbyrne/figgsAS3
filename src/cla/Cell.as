package cla
{
	import flash.display.Graphics;

	public class Cell
	{
		private var _dendrites:Array;
		private var _column:Column;
		private var _index:uint;
		
		public function Cell(column:Column, index:uint)
		{
			_column = column;
			_index = index;
			_dendrites = new Array(Region.cellDendrites);
			for(var i:uint = 0; i < _dendrites.length; i++) {
				_dendrites[i] = new Dendrite(this, i);
			}
		}
		
		public function draw(graphics:Graphics, offset:Array):void {
			var xy:Array = new Array(2);
			xy[0] = offset[0] + _index; xy[1] = offset[1] + (_index * Region.scale / Region.columnCells);
			//trace("draw cell["+_index+"] at ["+xy[0]+","+xy[1]+"]");
			graphics.moveTo(xy[0], xy[1]);
			graphics.lineStyle(1.0,0xCCCCCC, 0.8);
			if(Math.random() > 0.8) {
				graphics.beginFill(0x99FF99, 0.5);
			} else if(Math.random() > 0.8) {
				graphics.beginFill(0xFFFFFF, 0.5);
			} else {
				graphics.beginFill(0xFF9999, 0.5);
			}
			
			graphics.drawCircle(xy[0], xy[1], 2 + Region.scale * 0.5 / Region.columnCells);
			graphics.endFill();
		}
		
	}
}