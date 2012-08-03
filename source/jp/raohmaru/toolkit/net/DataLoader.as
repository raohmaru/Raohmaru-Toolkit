/*
Copyright (c) 2012 Raohmaru

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
*/

package jp.raohmaru.toolkit.net
{
import flash.utils.ByteArray;
import flash.events.*;
import flash.net.*;

/**
 * Se distribuye tras decodificar y colocar todos los datos recibidos en la propiedad <code>data</code> del objeto URLLoader. Es posible acceder a los datos recibidos
 * una vez distribuido este evento.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event") ]

/**
 * Se distribuye cuando se produce un error de entrada o salida que provoca que una operación de carga se realice incorrectamente.
 * @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent") ]

/**
 * Se distribuye cuando se realiza una solicitud de red a través de HTTP y Flash Player puede detectar el código de estado HTTP.
 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
 */
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent") ]

/**
 * Se distribuye cuando se inicia la operación de carga.
 * @eventType flash.events.Event.OPEN
 */
[Event(name="open", type="flash.events.Event") ]

/**
 * Se distribuye al recibirse datos mientras progresa una operación de descarga.
 * @eventType flash.events.ProgressEvent.PROGRESS
 */
[Event(name="progress", type="flash.events.ProgressEvent") ]

/**
 * Se distribuye si se intenta cargar datos de un servidor situado fuera del entorno limitado de seguridad.
 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent") ]

/**
 * Clase proxy para cargar datos externos. Simplifica el proceso, así como permite cargar datos en formato de texto, variables con codificación URL o archivos binarios.
<listing version="3.0">
import flash.display.*;
import flash.events.Event;import flash.net.URLRequestMethod;
import jp.raohmaru.toolkit.net.DataLoader;

var dloader : DataLoader = new DataLoader();
	dloader.method = URLRequestMethod.POST;	dloader.addEventListener(Event.COMPLETE, onLoadComplete);
	dloader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
	dloader.loadXML("gallery.xml");

function onLoadComplete(e : Event) : void
{
	trace(e.target.data);
}
function onLoadError(e : Event) : void
{
	trace(e);
}</listing>
 * @author raohmaru
 */
public class DataLoader extends EventDispatcher
{
	private var _loader : URLLoader,
				_data : *,
				_type : String,
				_method : String,
				_headers : Array = [],
				_dataFormat : String;

	private const 	XML_TYPE : String = "xml",
					VARS_TYPE : String = "vars",
					BINARY_TYPE : String = "binary";

	/**
	 * Obtiene los datos cargados en el siguiente formato:
	 * <ul>
	 * <li>un <b>XML</b> si se utilizó el método <code>loadXML</code>,</li>
	 * <li>un <b>URLVariables</b> si se utilizó el método <code>loadVars</code>,</li>
	 * <li>un <b>ByteArray</b> si se utilizó el método <code>loadBin</code>,</li>
	 * <li>un <b>String</b> si se utilizó el método <code>load</code> sin haber invocado previamente ninguno de los métodos anteriores.</li>
	 * </ul>
	 */	public function get data() : *
	{
		if(_type == XML_TYPE)
		{
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			return new XML(_data);
		}

		if(_type == VARS_TYPE) return new URLVariables( _data );

		if(_type == BINARY_TYPE) return ByteArray(_data);

		return _data;
	}

	/**
	 * Define u obtiene el método (POST o GET) utilizado al enviar datos.
	 * @default URLRequestMethod.GET
	 * @see flash.net.URLRequestMethod
	 */
	public function get method() : String
	{
		return _method;
	}
	public function set method(value : String) : void
	{
		_method = value;
	}

	/**
	 * Define u obtiene las cabeceras de solicitud HTTP.
	 * @see flash.net.URLRequestHeader
	 */
	public function get headers() : Array
	{
		return _headers;
	}
	public function set headers(value : Array) : void
	{
		_headers = value;
	}

	/**
	 * Define u obtiene el formato en el que se reciben los datos descargados.
	 * @default "text"
	 * @see flash.net.URLLoaderDataFormat
	 */
	public function get dataFormat() : String
	{
		return _dataFormat;
	}
	public function set dataFormat(value : String) : void
	{
		_dataFormat = value;
	}

	/**
	 * Obtiene el progreso de la descarga (0 -&gt; nada descargado, 1 -&gt; 100% descargado)
	 */
	public function get loaded() : Number
	{
		return (_loader) ? _loader.bytesLoaded/_loader.bytesTotal : 0;
	}

	/**
	 * Indica el número de bytes cargados hasta ese momento durante la operación de carga.
	 */
	public function get bytesLoaded() : uint
	{
		return (_loader) ? _loader.bytesLoaded : 0;
	}

	/**
	 * Indica el número total de bytes de los datos descargados.
	 */
	public function get bytesTotal() : uint
	{
		return (_loader) ? _loader.bytesTotal : 0;
	}

	/**
	 * Obtiene una referencia al objeto URLLoader interno.
	 */
	public function get loader() : URLLoader
	{
		return _loader;
	}

	/**
	 * Especifica si el objeto DataLoader está activo y si actualmente se están cargando datos.
	 * Devuelve <code>true</code> (está activo) si se ha invocado alguno de los métodos de carga (<code>load</code>, <code>loadXML</code>,
	 * <code>loadVars</code> o <code>loadBin</code>). Devuelve <code>false</code> (no está activo) cuando ha finalizado la carga o ha ocurrido
	 * un error, y después de llamar al método <code>close</code>.
	 *
	 */
	public function get loading() :Boolean
	{
		return _loader != null;
	}


	/**
	 * Crea un nuevo DataLoader con las siguientes propiedades.
	 * @param method Método POST o GET al enviar datos
	 * @param headers Cabeceras de solicitud HTTP
	 * @param dataFormat Formato en que se reciben los datos descargados
	 */
	public function DataLoader(method : String = "GET", headers : Array = null, dataFormat : String = "text")
	{
		_method = method;
		if(headers) _headers = headers;
		_dataFormat = dataFormat;
	}

	/**
	 * Carga un archivo XML y establece el formato de datos apropiado (<code>dataFormat = URLLoaderDataFormat.TEXT</code>)
	 * @param url Dirección del archivo XML
	 * @param vars Variables a enviar
	 */
	public function loadXML(url : String, vars : Object = null) : void
	{
		_type = XML_TYPE;
		dataFormat = URLLoaderDataFormat.TEXT;

		load(url, vars);
	}

	/**
	 * Carga variables con codificación URL y establece el formato de datos apropiado (<code>dataFormat = URLLoaderDataFormat.VARIABLES</code>)
	 * @param url Dirección URL a cargar
	 * @param vars Variables a enviar
	 */
	public function loadVars(url : String, vars : Object = null) : void
	{
		_type = VARS_TYPE;
		dataFormat = URLLoaderDataFormat.VARIABLES;

		load(url, vars);
	}

	/**
	 * Carga un archivo binario sin formato y establece el formato de datos apropiado (<code>dataFormat = URLLoaderDataFormat.BINARY</code>)
	 * @param url Dirección URL a cargar
	 * @param vars Variables a enviar
	 */
	public function loadBin(url : String, vars : Object = null) : void
	{
		_type = BINARY_TYPE;
		dataFormat = URLLoaderDataFormat.BINARY;

		load(url, vars);
	}

	/**
	 * Carga datos externos genéricos. El formato de datos es el mismo que el de la última llamada a cualquiera de los métodos
	 * <code>loadXML</code>, <code>loadVars</code> o <code>loadBin</code>.
	 * @param url Dirección URL a cargar
	 * @param vars Variables a enviar
	 */
	public function load(url : String, vars : Object = null) : void
	{
		_data = undefined;

		var urlRequest:URLRequest = new URLRequest(url);
			urlRequest.data = vars;
			urlRequest.method = method;
			urlRequest.requestHeaders = headers;

		_loader = new URLLoader();
		_loader.dataFormat = dataFormat;

		_loader.addEventListener(Event.COMPLETE, eventHandler);
        _loader.addEventListener(Event.OPEN, eventHandler);
        _loader.addEventListener(ProgressEvent.PROGRESS, eventHandler);
        _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
        _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
        _loader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);

		_loader.load( urlRequest );
	}

	/**
	 * Cierra la operación de carga en curso. Se detendrá inmediatamente cualquier operación de carga en curso.
	 * @see flash.net.URLLoader.close()
	 */
	public function close() : void
	{
		if(_loader)
		{
			_loader.close();
			_loader = null;
		}
	}


	/**
	 * Gestiona todos los eventos
	 */
	private function eventHandler(e : Event) : void
	{
		if(e.type == Event.COMPLETE)
			_data = _loader.data;

		if(e.type == Event.COMPLETE || e.type == IOErrorEvent.IO_ERROR)
			_loader = null;

		dispatchEvent(e);
	}
}
}