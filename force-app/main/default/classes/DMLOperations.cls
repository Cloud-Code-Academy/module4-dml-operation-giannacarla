/**
 * The DMLOperations class serves as a deep dive into Data Manipulation Language (DML) in Apex.
 * It covers fundamental DML operations such as insert, update, upsert, and delete.
 *
 * This class introduces developers to the concept of manipulating Salesforce records in Apex.
 * It discusses how to use DML operations to create, update, and delete records.
 * This class uses standard Salesforce objects like Account, Contact, and Opportunity for demonstration.
 *
 * Topics covered in this class include:
 * - Understanding how to use insert DML operation to create records in Salesforce.
 * - Understanding how to use update and upsert DML operations to update existing records in Salesforce.
 * - Understanding how to use delete DML operation to remove records from Salesforce.
 *
 * Users of this class can expect to gain a strong understanding of DML operations in Apex and
 * be prepared for more advanced topics in Salesforce development.
 *
 * The methods within this class serve as practical examples of different DML operations,
 * allowing developers to learn through practice and examples.
 *
 * @author Gianna Carla Q. Delacruz
 */


public with sharing class DMLOperations {

    /**
     * Question 1
     * Create a new Account object and inserts it into the database.
     * The Account will have a random name for uniqueness.
     * @return The Id of the newly created Account.
     */
    public static Id insertNewAccount() {
        Account acc = new Account(Name = 'My testing account3');
        acc.Phone = '1234567890';
        acc.Fax = '0123456789';
        acc.Website = 'salesforce.com';
        insert acc;
        return acc.Id;
    }

    /**
     * Question 2
     * Create a new Account with the specified name and industry provided.
     * @param name The name of the account to be created.
     * @param industry The industry of the account to be created.
     */
    public static void createAccount(String name, String industry) {
        Account acc = new Account(Name = name);
        acc.Industry = industry;
        insert acc;
    }

    
    /**
     * Question 3
     * Create a new Contact and link it to the Account id provided then inserts it into the database.
     * @param accountId The Id of the Account to link the Contact to.
     * @return The Id of the newly created Contact.
     */
    public static Id insertNewContact(Id accountId) {
        Contact cont = new Contact(LastName = 'Barolo');
        cont.FirstName = 'Paola';
        cont.Phone = '5552223337';
        cont.Birthdate = Date.newInstance(1994, 12, 3);
        cont.AccountId = accountId;
        insert cont;
        return cont.Id;
    }

    /**
     * Question 4
     * Update the last name of a Contact in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param contactId The Id of the Contact to update.
     * @param newLastName The new last name for the Contact.
     */
    public static void updateContactLastName(Id contactId, String newLastName) {
        Contact con = [SELECT Id FROM Contact WHERE Id = :contactId];
        con.LastName = newLastName;
        update con;
    }

    /**
     * Question 5
     * Update the stage of an Opportunity in the database.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param oppId The Id of the Opportunity to update.
     * @param newStage The new stage for the Opportunity.
     */
    public static void updateOpportunityStage(Id oppId, String newStage) {

        Opportunity opp = [SELECT Id FROM Opportunity WHERE id = :oppId];
        opp.StageName = newStage;
        update opp;
    }

    /**
     * Question 6
     * Update the Account's Name and Industry given an Account Id.
     * Resource: https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm
     * @param accountId The Id of the account to be updated.
     * @param newName The new name for the account.
     * @param newIndustry The new industry for the account.
     */
    public static void updateAccountFields(Id accountId, String newName, String newIndustry) {
        Account acc = [SELECT Id FROM Account WHERE id = :accountId];
        acc.Name = newName;
        acc.Industry = newIndustry ; 
        update acc;
    }


    /**
     * Question 7
     * Create or updates an Opportunities
     * The Opportunity's Stage is set to Qualification.
     * The Opportunity's Close Date is set to 3 months from today.
     * The Opportunity's Amount is set to 50000.
     * @param list of Opportunities to be changed then upserted.
     */
    public static void upsertOpportunityList(List<Opportunity> opportunities) {
        for (Opportunity o : opportunities){
            o.StageName = 'Qualification';
            o.CloseDate = Date.today().addMonths(3);
            o.Amount = 50000;
        }
        upsert opportunities;
    }

    /**
     * Question 8
     * Insert or update opportunities from list of names.
     * Associate the Opportunities with account that has the name accountName.
     * There should be an Opportunity for each name provided in the list.
     * HINT: The account may or may not exists in the database but is required for opportunity creation. Consider how upsert operation can help 
    with this.
     * HINT: There should not be duplicate opportunities based on the name
     * @param accountName The name of the Account.
     * @param oppNames The list of Opportunity names.
     */
    public static void upsertOpportunities(String accountName, List<String> oppNames) {
        List<Opportunity> oppList = new List<Opportunity>();
        Account account = new Account(Name = accountName);
        insert account;
        for (String o : oppNames){
            Opportunity opp = new Opportunity();
            opp.Name = o;
            opp.StageName = 'Qualificaiton';
            opp.CloseDate = Date.today().addMonths(3);
            opp.Amount = 50000;
            opp.AccountId = account.Id;
            oppList.add(opp);
        }
        upsert oppList;
    }
    /**
     * Question 9
	 * Upserts an Account with the specified name.
	 * If an Account with the given name already exists, update the description to "Updated Account".
	 * If no such Account exists, it creates a new one and sets the description to "New Account".
	 * @param accountName The name of the Account to be upserted.
	 * @return The Account that was upserted.
	 */
	public static Account upsertAccount(String accountName) {
		List<Account> accounts = [SELECT Id FROM Account WHERE Name = :accountName];
        Account accWithAccountName;
        if (!accounts.isEmpty()){
            accWithAccountName = accounts[0];
            accWithAccountName.Description = 'Updated Account';
        } else {
            Account acc = new Account();
            acc.Name = accountName;
            acc.Description = 'New Account';
            accWithAccountName = acc;
        }
		upsert accWithAccountName;
		return accWithAccountName;
	}

    /**
     * Question 10
	 * Manage the association between Contacts and Accounts
	 * Ensure that for each Contact in the provided list, there is a corresponding Account Name that matches the Contact's last name.
	 * If such an Account does not exist, the method creates it; if it does, the method ensures the Contact is associated with it. (Hint: use previous upsertAccount method - this may cause bad practices but for learning purposes it's okay.)
     * Example Contact.LastName = 'Doe' Link to Account.Name = 'Doe' 
     * Example Contact.LastName = 'Jane' Link to Account.Name = 'Jane'
	 * @param contactsToUpsert List of Contacts to be upserted and linked to accounts.
	 */
	public static void upsertAccountsWithContacts(List<Contact> contactsToUpsert) {
    List<Contact> contactList = new List<Contact>();
    for (contact c : contactsToUpsert){
        String accountName = c.LastName;
        Account acc = upsertAccount(accountName);
        c.AccountId = acc.Id;
        contactList.add(c);
        }     
    upsert contactList;
	}

    /**
     * Question 11
     * Insert a list of Leads and then deletes them.
     * @param leadNames The list of Lead names to be inserted.
     */
    public static void insertAndDeleteLeads(List<String> leadNames) {
        List<Lead> leadList = new List<Lead> ();
        // Loop through each Lead name
        for(String name: leadNames){
            Lead lead = new Lead();
            lead.LastName = name;
            lead.Company = 'Test';
            leadList.add(lead);
        }
        insert leadList;
        delete leadList;
    }


    /**
     * Question 12
     * Dynamically create the number of cases and relate it to the accountId, then deletes them.
     * @param accountId The account for which the cases will be created and then deleted.
     * @param numOfCases The number of cases to create.
     */
    public static void createAndDeleteCases(String accountId, Integer numOfCases) {
        // Insert the cases
        List<Case> caseList = new List<Case>();
        for (integer i = 0; i < numOfCases; i++){
            Case ca = new Case();
            ca.AccountId = accountId;
            caseList.add(ca);
        }
        insert caseList;
        delete caseList;
    }
}