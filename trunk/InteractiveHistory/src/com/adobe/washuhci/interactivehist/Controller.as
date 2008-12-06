package com.adobe.washuhci.interactivehist
{
	public class Controller
	{
		private _map:InteractiveMap;
		//private _searcher:Searcher;
		//private _timeline:Timeline;
		
		public function Controller(map:InteractiveMap/*, searcher:Searcher, timeline:Timeline*/)
		{
			_map = map;
			
			setupListeners();
		}
		
		private function setupListeners():void {
		
			/** Listeners needed:
			 * when you change date on timeline, map updates
			 * when you click on map item, timeline updates,
			 * 	sidebar updates
			 * when you click on search result, timeline updates,
			 *  map updates, sidebar updates
			 * 
			 * Handle in main UI file:
			 * bindings from timeline time to map
			 * bindings from selected map item to selected timeline item?
			 * 
			 * Have big 'changeFocus' method that handles
			 * when something else is selected
			 * */
		}

	}
}