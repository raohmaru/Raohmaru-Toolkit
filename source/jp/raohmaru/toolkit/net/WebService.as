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
import flash.net.*;
import flash.events.*;

/**
 * Se distribuye tras decodificar y colocar todos los datos recibidos en la propiedad data del objeto URLLoader. Es posible acceder a los datos recibidos
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
 * La clase WebService transfiere y descarga datos de servicios web siguiendo el protocolo SOAP.
 * Un servicio web es un conjunto de protocolos y estándares que sirven para intercambiar datos entre aplicaciones.
 * @author raohmaru
 * @example
<listing version="3.0">
var new_ns :Namespace = new Namespace("http://schemas.namespaces.com/some/");

var ws : WebService = new WebService(new_ns);
    ws.connect("http://www.test.com/Services.asmx");
    ws.addEventListener(Event.COMPLETE, onLoadService);
    ws.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
    ws.callMethod("getSomeMethod", new URLVariables("id=100"));

function onLoadService(e : Event) : void
{
    trace(ws.data);
}

function onIOError(e : IOErrorEvent) : void
{
    trace(e);
}
</listing>
 */
public class WebService extends EventDispatcher
{
	private var _loader : URLLoader,
				_service_url :String,
				_method :String,
				_namespace :Namespace = tempuri;
	/**
	 * Espacio de nombres del protocolo SOAP.
	 * @default SOAP 1.2.
	 */
	public static var soap : Namespace = new Namespace("http://www.w3.org/2003/05/soap-envelope");

	/**
	 * Versión del protocolo SOAP utilizado.
	 * @default 1.2.
	 */
	public static var soapVersion : Number = 1.2;

	/**
	 * Los datos recibidos del servicio web en la última petición, en formato XML.
	 */
	public function get data() : XML
	{
		if(_loader && _loader.data)
		{
			XML.ignoreComments = true;
			XML.ignoreWhitespace = true;
			return new XML(_loader.data);
		}
		else
		{
			return null;
		}
	}

	/**
	 * Indica el número de bytes cargados hasta ese momento durante la operación de carga.
	 */
	public function get bytesLoaded() : uint
	{
		return _loader.bytesLoaded;
	}

	/**
	 * Indica el número total de bytes de los datos descargados. Esta propiedad contiene 0 si la operación de carga está en curso y se llena cuando la operación ha finalizado.
	 */
	public function get bytesTotal() : uint
	{
		return _loader.bytesTotal;
	}

	/**
	 * Obtiene el nombre del método utilizado en la última petición con <code>callMethod</code>.
	 * @see #callMethod()
	 */
	public function get method() :String
	{
		return _method;
	}

	/**
	 * Define u obtiene el espacio de nombres que se utilizará en el cuerpo de la petición.
	 * @default "http://tempuri.org/"
	 */
	public function get nameSpace() :Namespace
	{
		return _namespace;
	}
	public function set nameSpace(value :Namespace) : void
	{
		_namespace = value;
	}


	/**
	 * Crea un objeto WebService.
	 * @param nameSpace Define el espacio de nombres que se utilizará en el cuerpo de la petición. Por defecto es "http://tempuri.org/".
	 */
	public function WebService(nameSpace :Namespace = null)
	{
		if(nameSpace) _namespace = nameSpace;
	}

	/**
	 * Conecta con un proveedor de servicios web.
	 * @param service_url Dirección URL del servicio web.
	 * @example
	<listing version="3.0">var ws : WebService = new WebService();
ws.connect("http://www.test.com/Services.asmx");</listing>
	 */
	public function connect(service_url : String) : void
	{
		_service_url = service_url;
	}

	/**
	 * Realiza una petición al servicio web siguiendo el protocolo SOAP, especificando el nombre del método y los posibles argumentos a enviar.
	 * @param method Nombre del método a solicitar.
	 * @param vars URLVariables a adjuntar en la petición como argumentos.
	 * @example
	<listing version="3.0">var ws : WebService = new WebService();
ws.connect("http://www.test.com/Services.asmx");
ws.addEventListener(Event.COMPLETE, onLoadService);
ws.callMethod("getList", new URLVariables("id=2&amp;user=grol"));<br>
function onLoadService(e : Event) : void
{
	trace(e.target.data);
}</listing>
	 */
	public function callMethod(method :String, vars :URLVariables=null) : void
	{
		_method = method;

		var urlRequest:URLRequest = new URLRequest(_service_url);
			urlRequest.data = parseRequest(method, vars, _namespace);
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.requestHeaders.push(
				new URLRequestHeader("Content-Type", "application/soap+xml; charset=utf-8"),
				new URLRequestHeader("pragma", "no-cache")
			);

		if(_loader != null)
		{
			_loader.removeEventListener(Event.OPEN, eventHandler);
			_loader.removeEventListener(Event.COMPLETE, eventHandler);
			_loader.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
			_loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
		}

		_loader = new URLLoader();
		_loader.dataFormat = URLLoaderDataFormat.TEXT;
		//_loader.dataFormat = "e4x";

		_loader.addEventListener(Event.OPEN, eventHandler);
		_loader.addEventListener(Event.COMPLETE, eventHandler);
		_loader.addEventListener(ProgressEvent.PROGRESS, eventHandler);
		_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
		_loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
		_loader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);

		_loader.load(urlRequest);
	}

	private function eventHandler(e : Event) : void
	{
		dispatchEvent(e);
	}



	/**
	 * Encapsula el nombre de un método y las variables a transferir al servicio web en el formato de una solicitud SOAP.
	 * @param method Nombre del método a solicitar
	 * @param vars URLVariables a adjuntar en la petición como argumentos
	 * @param nameSpace Espacio de nombres a utilizar en el cuerpo de la petición.
	 */
	public static function parseRequest(method :String, vars :URLVariables=null, nameSpace :Namespace=tempuri) : XML
	{
		var soap_tag :String = (soapVersion == 1.2) ? "soap12" : "soap";

		var xml :XML = new XML('<' + soap_tag + ':Envelope xmlns:' + soap_tag + '="' + soap.uri + '"' +
			' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">' +
			'<'+soap_tag+':Body/>' +
			'</'+soap_tag+':Envelope>');

		xml.soap::Body.appendChild( <{method} xmlns={nameSpace.uri}/> );

		if(vars != null)
		{
			for (var i : String in vars)
			{
				var value : * = vars[i];
				xml.soap::Body.children()[0].appendChild( <{i}>{value}</{i}> );
			}
		}

		return xml;
	}
}
}