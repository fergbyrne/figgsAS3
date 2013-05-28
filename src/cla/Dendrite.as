package cla
{
	public class Dendrite
	{
		private var _synapses:Array;
		private var _cell:Cell;
		private var _index:uint;
		
		public function Dendrite(cell:Cell, index:uint)
		{
			_index = index;
			_cell = cell;
			_synapses = new Array(Region.dendriteSize);
		}
	}
}