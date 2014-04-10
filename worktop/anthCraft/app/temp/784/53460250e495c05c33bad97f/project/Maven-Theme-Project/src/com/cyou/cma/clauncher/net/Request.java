package com.cyou.cma.clauncher.net;

import java.io.File;
import java.io.InputStream;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Builder for an HTTP request.
 * 
 * @author Connor
 *
 */
public class Request {
	// request method
	public enum Method {
        GET, POST, PUT, DELETE
    }

	protected String uri;
	protected Method method;
	protected Integer connectTimeout;
    protected Integer readTimeout;
	
	protected Map<String, Object> params;
	protected Map<String, Object> headers;
	protected Object payload;
	protected boolean streamPayload;
	
	// Default method: GET
	public Request(String uri) {
		this(Method.GET, uri);
	}
	
	public Request(Method method, String uri) {
		this.method = method;
		this.uri = uri;
	}
	
	/**
     * Set (or overwrite) a parameter.
     * <br/>
     * The parameter will be used to create a query string for GET-requests and as the body for POST-requests
     * with MIME-type
     * @param name the name of the parameter (it's better to use only contain ASCII characters)
     * @param value the value of the parameter; <code>null</code> will be converted to empty string, for all other
     *              objects to <code>toString()</code> method converts it to String
     * @return <code>this</code> for method chaining (fluent API)
     */
	public Request param(String name, Object value) {
		if (params == null) {
			params = new LinkedHashMap<String, Object>();
		}
		params.put(name, value);
		return this;
	}
	
	/**
     * Set (or overwrite) a HTTP header value.
     * Using <code>null</code> or empty String is not allowed for name and value.
     *
     * @param name name of the header (HTTP-headers are not case-sensitive, but if you want to override your own
     *             headers, you have to use identical strings for the name.
     * @param value the value for the header. Following types are supported, all other types use <code>toString</code>
     *              of the given object:
     *              <ul>
     *              <li>{@link java.util.Date} is converted to RFC1123 compliant String</li>
     *              <li>{@link java.util.Calendar} is converted to RFC1123 compliant String</li>
     *              </ul>
     * @return <code>this</code> for method chaining (fluent API)
     */
	public Request header(String name, Object value) {
		if (headers == null) {
			headers = new LinkedHashMap<String, Object>();
		}
		headers.put(name, value);
		return this;
	}
	
    /**
     * Set the payload for the request.
     * <br/>
     * Using this method together with {@link #param(String, Object)} has the effect of <code>body</code> being
     * ignored without notice. The method can be called more than once: the value will be stored and converted
     * to bytes later.
     *
     * @param body the payload
     * @return <code>this</code> for method chaining (fluent API)
     */
	public Request body(Object body) {
        if (method == Method.GET || method == Method.DELETE) {
            throw new IllegalStateException("body not allowed for request method " + method);
        }
        this.payload = body;
        this.streamPayload = body instanceof File || body instanceof InputStream;
        return this;
    }
	
	/**
     * See <a href="http://docs.oracle.com/javase/7/docs/api/java/net/URLConnection.html#setConnectTimeout(int)">
     *     URLConnection.setConnectTimeout</a>
     * @param connectTimeout sets a specified timeout value, in milliseconds. <code>0</code> means infinite timeout.
     * @return <code>this</code> for method chaining (fluent API)
     */
    public Request connectTimeout(int connectTimeout) {
        this.connectTimeout = connectTimeout;
        return this;
    }

    /**
     * See <a href="http://docs.oracle.com/javase/7/docs/api/java/net/URLConnection.html#setReadTimeout(int)">
     *     </a>
     * @param readTimeout Sets the read timeout to a specified timeout, in milliseconds.
     *                    <code>0</code> means infinite timeout.
     * @return <code>this</code> for method chaining (fluent API)
     */
    public Request readTimeout(int readTimeout) {
        this.readTimeout = readTimeout;
        return this;
    }
}
