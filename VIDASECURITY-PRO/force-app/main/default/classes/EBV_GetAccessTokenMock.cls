@isTest
public class EBV_GetAccessTokenMock implements HttpCalloutMock{

    public HTTPResponse respond(HttpRequest req){
        HTTPResponse res = new HTTPResponse();

        res.setHeader('Content-Type', 'application/json');
        String body ='{'+
        '     \"access_token\":\"eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJVR1RPYm9QSndQZ04wZFZEYVROdUZxOHNJaEMxU0N3S2ZLcXZ3MmU3Q3YwIn0.eyJleHAiOjE2NTExNjYwODcsImlhdCI6MTY1MTE2MjQ4NywianRpIjoiZTM0MzEyYmYtNDhiNi00MGFjLWE0ZjgtYzQ2YmVjYjA4MjlmIiwiaXNzIjoiaHR0cHM6Ly9zc28uc2VjdXJpdHkuY2wvYXV0aC9yZWFsbXMvVlMtQ2xpZW50cyIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI5NDRjZTQ4My04OWJjLTQ0YTUtOWRkMy0yMjQwYjRlZTE5YjIiLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJ2cy12YWx1ZXRlY2giLCJzZXNzaW9uX3N0YXRlIjoiNmY4YjUzYjAtODBhMC00ZDFmLTllYTgtMzFkZTRjYzA3YWJjIiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJlbWFpbCBwcm9maWxlIiwiY2xpZW50SG9zdCI6IjE4Ni4xMDUuMzMuMTgiLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImNsaWVudElkIjoidnMtdmFsdWV0ZWNoIiwicHJlZmVycmVkX3VzZXJuYW1lIjoic2VydmljZS1hY2NvdW50LXZzLXZhbHVldGVjaCIsImNsaWVudEFkZHJlc3MiOiIxODYuMTA1LjMzLjE4In0.AOnzLnMnPplzfmaM9PeM6aNk2dqj6ibp1DkcC-tGA-RVLErtWcTHtzZaFLbSvbtBls_eifcr5rq_yC5d20-AKizJXyypwFbgMqyRvVaOqRkGaPw52UCbmLrqHa1bfQKaZ24OeTLS_YAt5v7rYvFVo9NC80LDzDXHmK8ffH6yx9t-ldf9wBUrleZjmh2jCx-aEcs8tFz8C128T8KVnyiJvO6T5zeKyI4W3vjKmIZrU-MA3AiFz68eteG6e3a8zD_fz-QA9AkyIXw1-2FRrCtNzjJOVX5oyUq-_M3X0zGN01n2jmW6x3VpIp0MWoOon4Kja2yE1QqWOLgXb-Ez3QahWw\",'+
        '     \"expires_in\":3600,' + 
        '     \"refresh_expires_in\":3600,' + 
        '     \"refresh_token\":\"eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJlNWI5ZjhkZS03MDkzLTRiOTItODdiZi0yZWU0OTI0Y2M1YmMifQ.eyJleHAiOjE2NTExNjYwODcsImlhdCI6MTY1MTE2MjQ4NywianRpIjoiMGZiODViM2EtNGJhOS00MTUxLWEwNGUtZGNhYWE4YmNhNTJlIiwiaXNzIjoiaHR0cHM6Ly9zc28uc2VjdXJpdHkuY2wvYXV0aC9yZWFsbXMvVlMtQ2xpZW50cyIsImF1ZCI6Imh0dHBzOi8vc3NvLnNlY3VyaXR5LmNsL2F1dGgvcmVhbG1zL1ZTLUNsaWVudHMiLCJzdWIiOiI5NDRjZTQ4My04OWJjLTQ0YTUtOWRkMy0yMjQwYjRlZTE5YjIiLCJ0eXAiOiJSZWZyZXNoIiwiYXpwIjoidnMtdmFsdWV0ZWNoIiwic2Vzc2lvbl9zdGF0ZSI6IjZmOGI1M2IwLTgwYTAtNGQxZi05ZWE4LTMxZGU0Y2MwN2FiYyIsInNjb3BlIjoiZW1haWwgcHJvZmlsZSJ9.gzj3ML3AV_RCmexHyWeYn57w5u-4kU37sEs3l9jAXNg\",'+
        '     \"token_type\":\"bearer\",'+
        '     \"not-before-policy\":1607130070,'+
        '     \"session_state\":\"6f8b53b0-80a0-4d1f-9ea8-31de4cc07abc\",'+
        '     \"scope\":\"email profile\"'+
        '}';
        res.setBody(body);
        res.setStatusCode(200);
        return res;


    } 

}