package com.cc.ui.xbaux.errors
{
	public class ContractError extends Error
	{
		public function ContractError(message:String, underlyingError:ContractError = null)
		{
			if (underlyingError)
			{
				message += "/" + underlyingError.message;
			}

			super(message);
		}
	}
}