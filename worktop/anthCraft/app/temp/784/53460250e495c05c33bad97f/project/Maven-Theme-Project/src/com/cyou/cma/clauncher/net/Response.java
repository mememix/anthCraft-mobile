package com.cyou.cma.clauncher.net;

import java.io.UnsupportedEncodingException;

/**
 * Holds data about the response message returning from HTTP request.
 * 
 * @author Connor
 *
 */
public class Response {
	/**
     * The HTTP status code
     */
    public int status;
    
    /**
     * The HTTP response message
     */
    public String message;
    
    /**
     * The response body, if any
     */
    public byte[] body;
    
    public String exception;
    
    /**
     * Constructor
     * 
     * @param status
     * @param message
     * @param body
     */
    protected Response(int status, String message, byte[] body) {
		this.status = status;
		this.message = message;
		this.body = body;
	}
    
	@Override
	public String toString() {
		String ret = "";
		ret += "status-code: " + status;
		ret += " message: " + message;
		String bodyContent = null;
		try {
			bodyContent = new String(body, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ret += " body: " + bodyContent;
		return ret;
	}
}
