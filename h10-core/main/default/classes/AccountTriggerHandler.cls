public with sharing class AccountTriggerHandler {

    public void beforeUpdate() {

        for (Account eachAccount : this.accounts) {
            
            if ( shouldIntegrate(eachAccount) ) {
                eachAccount.Integration_Status__c = IntegrationConstants.REQUESTED;
            }
        }

    }

    public void afterUpdate() {

        List<Account> accountsToIntegrate = new List<Account>();

        for (Account eachAccount : this.accounts) {

            if ( isIntegrationRequested(eachAccount) ) {
                accountsToIntegrate.add(eachAccount);
            }
        }

        if (accountsToIntegrate.isEmpty() == false) {
            System.enqueueJob( new AccountIntegrationQueue( accountsToIntegrate ) );
        }

    }

    public static void run() {
        AccountTriggerHandler ath = new AccountTriggerHandler( (List<Account>) Trigger.new, (Map<Id, Account>) Trigger.oldMap);

        if (Trigger.isBefore && Trigger.isUpdate) {
            ath.beforeUpdate();
        }

        if (Trigger.isAfter && Trigger.isUpdate) {
            ath.afterUpdate();
        }
    }

    private List<Account> accounts;
    private Map<Id,Account> oldMap;

    private AccountTriggerHandler(List<Account> accounts, Map<Id, Account> oldMap) {
        this.accounts = accounts;
        this.oldMap = oldMap;
    }

    private Boolean shouldIntegrate(Account acct) {
        return acct != null
            && hasTypeChanged(acct);
    }

    private Boolean hasTypeChanged(Account acct) {
        return acct != null
            && oldMap.get(acct.Id)?.Type != acct.Type;
    }

    private Boolean isIntegrationRequested(Account acct) {
        return acct?.Integration_Status__c == IntegrationConstants.REQUESTED;
    }
}
