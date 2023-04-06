@isTest
public class EmailTemplateFabricate extends AbstractFabricate {
	public override Sobject default() {
		return new EmailTemplate(
			isActive = true,
			Name = 'name',
			DeveloperName = 'unique_name_addSomethingSpecialHere',
			TemplateType = 'text',
			FolderId = UserInfo.getUserId()
											);
	}
	
	public EmailTemplateFabricate setName(String name) {
		return (EmailTemplateFabricate)set('Name', name);
	}
}