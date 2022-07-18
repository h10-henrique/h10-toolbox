public without sharing class AccountRESTClient {
    
    public String createAccount(Account acct) {

        HttpRequest request = getHttpRequest('create_account');
                
        // create payload
        request.setBody( JSON.serializePretty(acct) );

        // call Callout class
        HttpResponse response = Callout.getInstance().send(request, acct.Id);

        if ( isSuccess(response) ) {
            AccountResource rsrc = (AccountResource) JSON.deserialize(response.getBody(), AccountResource.class);

            update new Account(
                Id = acct.Id,
                Integration_Status__c = IntegrationConstants.SUCCESS,
                External_Id__c = rsrc.Id
            );
        } else {
            update new Account(
                Id = acct.Id,
                Integration_Status__c = IntegrationConstants.ERROR
            );
        }

        return response.getStatus();
    }

    public String updateAccount(Account acct) {

        HttpRequest request = getHttpRequest('update_account');
        request.setEndpoint( request.getEndpoint().replace('{id}', acct.External_Id__c) );
                
        // create payload
        request.setBody( JSON.serializePretty(acct) );

        // call Callout class
        HttpResponse response = Callout.getInstance().send(request, acct.Id);

        if ( isSuccess(response) ) {
            update new Account(
                Id = acct.Id,
                Integration_Status__c = IntegrationConstants.SUCCESS
            );
        } else {
            update new Account(
                Id = acct.Id,
                Integration_Status__c = IntegrationConstants.ERROR
            );
        }

        return response.getStatus();
    }

    public AccountResource getAccount(String externalId) {

        HttpRequest request = getHttpRequest('get_account');
        request.setEndpoint( request.getEndpoint().replace('{id}', externalId) );
                
        // call Callout class
        HttpResponse response = Callout.getInstance().send(request, null);

        AccountResource rsrc = (AccountResource) JSON.deserialize(response.getBody(), AccountResource.class);
        return rsrc;
    }

    public String deleteAccount(String externalId) {

        HttpRequest request = getHttpRequest('delete_account');
        request.setEndpoint( request.getEndpoint().replace('{id}', externalId) );
                
        // call Callout class
        HttpResponse response = Callout.getInstance().send(request, null);

        return response.getStatus();
    }

    private HttpRequest getHttpRequest(String integrationName) {
        HttpRequest request = new HttpRequest();

        Integration__mdt integration = Integration__mdt.getInstance(integrationName);

        if (integration.Named_Credential__c != null) {
            request.setEndpoint('callout:' + integration.Named_Credential__c + StringUtils.defaultString(integration.Endpoint__c, ''));
        } else {
            request.setEndpoint(integration.Endpoint__c);
        }
        request.setMethod(integration.Method__c);
        request.setTimeout(Integer.valueOf(integration.Timeout__c));
        request.setHeader('Content-Type', integration.Content_Type__c);

        return request;
    }

    private Boolean isSuccess(HttpResponse response) {
        return response.getStatusCode() < 300;
    }

    private AccountRESTClient() {}

    private static AccountRESTClient instance;
    public static AccountRESTClient getInstance() {
        if (instance == null) instance = new AccountRESTClient();

        return instance;
    }

    public class AccountResource {
        public String id {get; set;}
        public String name {get; set;}
    }
}
