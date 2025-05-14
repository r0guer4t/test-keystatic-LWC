public with sharing class KeystaticAPIController {
    
    private static final String BASE_URL = 'https://your-keystatic-api.com/api/pages';

    @AuraEnabled(cacheable=true)
    public static String fetchPage(String slug) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL + '/' + EncodingUtil.urlEncode(slug, 'UTF-8'));
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            throw new AuraHandledException('Error fetching page: ' + res.getBody());
        }
    }

    @AuraEnabled
    public static String createPage(String slug, String content, String title) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(BASE_URL);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        Map<String, Object> body = new Map<String, Object>{
            'slug' => slug,
            'title' => title,
            'content' => content
        };

        req.setBody(JSON.serialize(body));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200 || res.getStatusCode() == 201) {
            return 'Success';
        } else {
            throw new AuraHandledException('Error creating page: ' + res.getBody());
        }
    }
}
