public without sharing class Callout {

    private Callout(){}

    private static Callout instance;

    public static Callout getInstance(){
        if (instance == null) { instance = new Callout(); }
        return instance;
    }

    public HttpResponse send(HttpRequest request, Id relatedTo) {

        try {
            Http http = new Http();

            Long requestStart = System.Now().getTime();
            HttpResponse response = http.send(request);
            Long requestEnd = System.Now().getTime();

            insert new Callout_Log__c(
                          Related_To__c = relatedTo,
                            Endpoint__c = request.getEndpoint(),
                              Method__c = request.getMethod(),
                        Request_Body__c = request.getBody()?.left(131072),
                       Response_Body__c = response.getBody()?.left(131072),
                Response_Status_Code__c = response.getStatusCode(), 
                        Callout_Time__c = (requestEnd - requestStart) / 1000
            );

            return response;

        } catch (Exception calloutEx) {
        
            System.debug(LoggingLevel.ERROR, calloutEx.getMessage());
            
            throw calloutEx;
        }
    }
}
