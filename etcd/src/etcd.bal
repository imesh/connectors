package org.wso2.ballerina.connectors.etcd;

import ballerina.lang.array;
import ballerina.lang.message;
import ballerina.lang.string;
import ballerina.lang.system;
import ballerina.net.http;
import ballerina.util;

@doc:Description("etcd client connector")
@doc:Param("etcdURL : etcd Server URL")
@doc:Param("username : etcd user")
@doc:Param("password : etcd user's password")
@doc:Param("apiVersion : etcd API version")
connector ClientConnector (string etcdURL, string username, string password, string apiVersion) {

    http:ClientConnector etcdEP = create http:ClientConnector(etcdURL);

    @doc:Description("Get the value for given key")
    @doc:Param("key: key to get the value")
    @doc:Return("response object")
    action getValue(ClientConnector t, string key) (message) {
        
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	path = "/" + apiVersion + "/keys/" + key;
        response = http:ClientConnector.get(etcdEP, path, request);
        return response;
    }

    @doc:Description("Set/Store key/value pair")
    @doc:Param("key: key to set the value")
    @doc:Param("value: value for the key")
    @doc:Return("response object")
    action setKeyValue(ClientConnector t, string key, string value) (message) {
	
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	message:setStringPayload(request, "value=" + value);
	message:setHeader(request, "Content-Type", "application/x-www-form-urlencoded");
	path = "/" + apiVersion + "/keys/" + key;
	response = http:ClientConnector.put(etcdEP, path, request);
	return response;
    }

    @doc:Description("Update the value for given key")
    @doc:Param("key: key to update the value")
    @doc:Param("value: value for the key")
    @doc:Return("response object")
    action updateValue(ClientConnector t, string key, string value) (message) {
	
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	message:setStringPayload(request, "value=" + value);
	message:setHeader(request, "Content-Type", "application/x-www-form-urlencoded");
	path = "/" + apiVersion + "/keys/" + key;
	response = http:ClientConnector.put(etcdEP, path, request);
	return response;
    }

    @doc:Description("Delete the key")
    @doc:Param("key: key to delete")
    @doc:Return("response object")
    action deleteKey(ClientConnector t, string key) (message) {
	
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	path = "/" + apiVersion + "/keys/" + key;
	response = http:ClientConnector.delete(etcdEP, path, request);
	return response;
     }

    @doc:Description("Create a directory")
    @doc:Param("dir: name of the directory")
    @doc:Return("response object")
    action createDir(ClientConnector t, string dir) (message) {
	
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	path = "/" + apiVersion + "/keys/" + dir;
	response = http:ClientConnector.put(etcdEP, path, request);
	return response;
    }

    @doc:Description("List directory")
    @doc:Param("dir: name of the directory")
    @doc:Param("recursive: recursive=true OR recursive=false")
    @doc:Return("response object")
    action listDir(ClientConnector t, string dir, string recursive) (message) {
	
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	path = "/" + apiVersion + "/keys" + dir + "?" + recursive;
        response = http:ClientConnector.get(etcdEP, path, request);
	return response;
    }
    
    @doc:Description("Delete directory")
    @doc:Param("dir: name of the directory")
    @doc:Param("recursive: recursive=true OR recursive=false")
    @doc:Return("response object")
    action deleteDir(ClientConnector t, string dir, string recursive) (message) {
	
	string encodedBasicAuthHeaderValue;
        string path;
        message request= {};
        message response;
	
	if ((string:length(username) > 0) && (string:length(password) > 0) ){
	    encodedBasicAuthHeaderValue = util:base64encode(username + ":" + password);
	    message:setHeader(request, "Authorization", "Basic " + encodedBasicAuthHeaderValue);
	}
	path = "/" + apiVersion + "/keys" + dir + "?" + recursive;
        response = http:ClientConnector.delete(etcdEP, path, request);
	return response;
    }
}

function main (string[] args) {


    string etcdURL = "http://127.0.0.1:2379";
    string username = "root";
    string password = "test123";
    string apiVersion = "v2";
    ClientConnector etcdConnector = create ClientConnector(etcdURL, username, password, apiVersion);
    message etcdResponse;

    // add key/value to the etcd
    if (args[0] == "setKeyValue"){
	if (array:length(args) > 2){
    	    etcdResponse = ClientConnector.setKeyValue(etcdConnector,args[1],args[2]);
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: setKeyValue <key> <value>");
	}
    }
 
    // get value from the etcd for given key
    if (args[0] == "getValue"){
   	if (array:length(args) > 1){ 
    	    etcdResponse = ClientConnector.getValue(etcdConnector,args[1]);
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: getValue <key>");
	}
    }
    
    // update a value for given key
    if (args[0] == "updateValue"){
   	if (array:length(args) > 2){ 
    	    etcdResponse = ClientConnector.updateValue(etcdConnector,args[1],args[2]);
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: updateValue <key> <value>");
	}
    }

    // delete a key from etcd
    if (args[0] == "deleteKey"){
   	if (array:length(args) > 1){ 
    	    etcdResponse = ClientConnector.deleteKey(etcdConnector,args[1]);
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: deleteKey <key>");
	}
    }

    // create directory
    if (args[0] == "createDir"){
	if (array:length(args) > 1){
    	    etcdResponse = ClientConnector.createDir(etcdConnector,args[1]);
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: createDir <dir>");
	}
    }
    
    // list directory
    if (args[0] == "listDir"){
	if (array:length(args) > 1){
	    if (array:length(args) < 3 ){
    	        etcdResponse = ClientConnector.listDir(etcdConnector,args[1],"recursive=false");
	    }else{
    	        etcdResponse = ClientConnector.listDir(etcdConnector,args[1],args[2]);
	    }
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: listDir <dir> [recuresive=true]");
	}
    }
    
    // delete directory
    if (args[0] == "deleteDir"){
 	if (array:length(args) > 1){
	    if (array:length(args) < 3 ){
		etcdResponse = ClientConnector.deleteDir(etcdConnector,args[1],"recursive=false");
	    }else{
		etcdResponse = ClientConnector.deleteDir(etcdConnector,args[1],args[2]);
	    }
    	    system:println(message:getStringPayload(etcdResponse));
	}else{
	    system:println("Usage: deleteDir <dir> [recuresive=true]");
	}
    }
}