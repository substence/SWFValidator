package messages
{
	import com.cc.messenger.Message;
	
	public class SaveDirectory extends Message
	{
		private var _directory:String;
		
		public function SaveDirectory(directory:String)
		{
			_directory = directory;
		}

		public function get directory():String
		{
			return _directory;
		}
	}
}