public with sharing class IdcException extends Exception {
    public void assert(String message) {
        System.assertEquals(message, this.getMessage(), 'Message not expected');
    }
}