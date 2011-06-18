package com.errolzz.abstract 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Errol Schwartz
	 */
	public class OrthoGrid extends Sprite
	{
		
		/**
		 * 
		 * @param	tile The class of the tile to use in the board.
		 * @param	boardSize The number of tiles per side in the board.
		 * @param	tileWidth The width of the top surface of the tile.
		 * @param	tileHeight The height of the top surface of the tile.
		 * @param	tileSpacing The spcace between tiles.
		 */
		public function OrthoGrid(tile:Class, boardSize:int, tileWidth:Number, tileHeight:Number, tileSpacing:Number = 0) 
		{
			var hw:Number = tileWidth * .5 + tileSpacing;
			var hh:Number = tileHeight * .5 + tileSpacing;
			
			for (var i:int = 0; i < boardSize; i++) 
			{
				for (var j:int = 0; j < boardSize; j++) 
				{
					var t:Sprite = new tile();
					
					//move left the row number times half the width of a tile
					//move right the column number times half the width of a tile
					t.x = (i * -hw) + (j * hw);
					
					//move down the row number times half the height of a tile
					//move down the column number times half the height of a tile
					t.y = (i * hh) + (j * hh);
					
					addChild(t);
				}
			}
		}
		
	}

}