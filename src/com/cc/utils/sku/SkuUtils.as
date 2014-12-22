package com.cc.utils.sku
{
	import com.cc.purchase.PlayerItemManager;
	import com.cc.sku.Balance;
	import com.cc.sku.BalancesDictionary;
	import com.cc.utils.SecNum;
	import com.kixeye.net.proto.transactions.LineItem;
	import com.kixeye.net.proto.transactions.TransactionReceipt;

	/*
	*	Utility Function for working with SKU related proto message
	*/
	public class SkuUtils
	{
		public static function getLineItemForSku( balances:Vector.<LineItem>, sku:String):LineItem
		{
			for each(var item:LineItem in balances)
			{
				if(item != null && item.sku == sku)
				{
					return item;
				}
			}
			
			return null;
		}
		/*
		public static function getLineItemFromReceiptsForSku(receipts:Vector.<TransactionReceipt>, skuName:String):LineItem
		{
			if (receipts != null 
				&& receipts.length > 0  
				&& skuName != PlayerItemManager.INVALID_SKU)
			{
				for each (var receipt:TransactionReceipt in receipts)
				{
					var lineItem:LineItem = getLineItemForSku(receipt.received);
					if(lineItem!= null)
					{
						return lineItem;
					}
				}	
			}
			
			return false;
		}*/
		
		public static function doesReceiptContianSKU(receipt:TransactionReceipt, skuName:String):Boolean
		{
			if (receipt != null 
				&& receipt.received != null 
				&& skuName != PlayerItemManager.INVALID_SKU)
			{
				for each (var lineItemObj:Object in receipt.received)
				{
					var lineItem:LineItem = lineItemObj as LineItem;
					if (lineItem != null && lineItem.sku == skuName)
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function doesReceiptListContainSKU(receipts:Vector.<TransactionReceipt>, skuName:String):Boolean
		{
			if (receipts != null 
				&& receipts.length > 0  
				&& skuName != PlayerItemManager.INVALID_SKU)
			{
				for each (var receipt:TransactionReceipt in receipts)
				{
					if (doesReceiptContianSKU(receipt,skuName))
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function setValue(balances:BalancesDictionary, sku:String, value:SecNum) : void
		{
			if (sku && value)
			{
				var points:Balance = balances.balances[sku];
				
				if (points != null)
				{
					value.Set(points.quantity.Get());
				}
			}
		}		
	}
}