@isTest
private class AutorizacionDeDesembolsoTest
{
	@isTest
	static void itShouldGenerateTheLetter()
	{
		//Set the world
		Id accId = TestDataFactory.createAccount('12345678'); 
		Id oppId = TestDataFactory.createOpportunity(accId);
		
		PageReference pageRef = Page.autorizacion_de_desembolso;
		Test.setCurrentPage(pageRef);

		AutorizacionDeDesembolsoCtrl autorizacionCtrl = new AutorizacionDeDesembolsoCtrl();

		// Verify that the page fails without parametes


		// Then

	}
}