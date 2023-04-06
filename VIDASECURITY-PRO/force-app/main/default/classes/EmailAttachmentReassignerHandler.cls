public class EmailAttachmentReassignerHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		for( Attachment a : (Attachment[])trigger.new ) {
		// Check the parent ID - if it's 02s, this is for an email message
			if( a.parentid == null )
				continue;
		
			String s = string.valueof( a.parentid );
		
			if( s.substring( 0, 3 ) == '02s' )
				a.parentid = [select parentID from EmailMessage where id = :a.parentid].parentID;
			
		}
	}
}