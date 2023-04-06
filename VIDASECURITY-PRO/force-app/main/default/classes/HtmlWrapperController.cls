public with sharing class HtmlWrapperController {

    public String htmlText {get; set;}
    private EmailMessage emailMsg { get; set;}

    public HtmlWrapperController(ApexPages.StandardController controller) {
        System.debug('HtmlWrapperController ctor');

         if (!Test.isRunningTest())
	        controller.addFields(new String[] {'htmlBody'});
        this.emailMsg = (EmailMessage)controller.getRecord();

        

        try {
            htmlText =  this.emailMsg.htmlBody;
            // String msgBody = msg.HtmlBody;
            // msgBody = msgBody.replace('<html><style>p{margin-top:0px; margin-bottom:0px;}</style><body class="setupTab"  style=" background-color:#CCCCCC; bEditID:b1st1; bLabel:body;"><center >', '');
            // msgBody = msgBody.replace('</body>','');
            // msgBody = msgBody.replace('</html>','');
            //ApexPages.currentPage().getParameters().get('htmlText');
        } catch (Exception e) {
            System.debug('EXCEPTION CAPTURADA');
            System.debug(e);
        }
        
    }
}