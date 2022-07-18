public class AccountIntegrationQueue implements Queueable, Database.AllowsCallouts {

    private List<Account> accts;

    public AccountIntegrationQueue(List<Account> accts) {
        this.accts = accts;
    }

    public void execute(QueueableContext context) {
        
        if (this.accts?.isEmpty() == false) {
            
            for (Account eachAccount : this.accts) {

                if ( String.isBlank(eachAccount.External_Id__c) ) {

                    AccountRESTClient.getInstance().createAccount(eachAccount);

                } else {
                    
                    AccountRESTClient.getInstance().updateAccount(eachAccount);
                }
            }
        }
    }

    
}
