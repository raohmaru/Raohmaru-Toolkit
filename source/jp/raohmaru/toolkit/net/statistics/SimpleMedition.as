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

package jp.raohmaru.toolkit.net.statistics
{
import flash.events.*;
import flash.net.*;

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
 * Se distribuye si se intenta cargar datos de un servidor situado fuera del entorno limitado de seguridad.
 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent") ]

/**
 * La clase SimpleMedition envía datos a una URL con el objeto de ser registrados para una estadística.
 * @example
<listing version="3.0">
import flash.net.URLRequestMethod;import flash.net.URLVariables;import jp.raohmaru.toolkit.net.statistics.SimpleMedition;

var med : SimpleMedition = new SimpleMedition();
	med.url = "http://www.example.org/test.php";	med.method = URLRequestMethod.POST;	med.log = true;
	med.addEventListener(Event.COMPLETE, onLoadComplete);var variables:URLVariables = new URLVariables();
variables.page = "home";med.send(variables);

function onSend(e : Event) : void
{

}</listing>
 * @author raohmaru
 */
public class SimpleMedition extends EventDispatcher implements IMedition
{
	private var _url : String,
				_enabled : Boolean = true,
				_method : String = URLRequestMethod.GET,
				_log : Boolean = false;

	/**
	 * La URL que se va a solicitar.
	 * @see flash.net.URLRequest
	 */
	public function get url() : String
	{
		return _url;
	}
	public function set url(value : String) : void
	{
		_url = value;
	}

	/**
	 * Define o obtiene el estado de la instancia SimpleMedition. Si es <code>false</code>, se desactivarán las llamadas a <code>SimpleMedition.send()</code>
	 * @default true
	 */
	public function get enabled() : Boolean
	{
		return _enabled;
	}
	public function set enabled(value : Boolean) : void
	{
		_enabled = value;
	}

	/**
	 * Define o obtiene si el método de envío HTTP es una operación GET o POST.
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
	 * Define si debe mostrarse el estado cada petición realizada con <code>SimpleMedition.send()</code> en la consola de salida.
	 * @default false
	 */
	public function get log() : Boolean
	{
		return _log;
	}
	public function set log(value : Boolean) : void
	{
		_log = value;
	}



	/**
	 * Crea una nueva instancia de SimpleMedition.
	 * @param url La URL que se va a solicitar
	 */
	public function SimpleMedition(url : String = null)
	{
		_url = url;
	}

	/**
	 * Envía una petición al servidor.
	 * @param data Datos a enviar junto a la petición.
	 * @see flash.net.URLLoader
	 * @example
	 <listing version="3.0">
	 import jp.raohmaru.toolkit.net.statistics.SimpleMedition;

	 var med : SimpleMedition = new SimpleMedition();
	 med.url = "http://www.example.org/medreg.php";	 med.send("page=descargas&amp;st=5");</listing>
	 */
	public function send(data : Object) : void
	{
		if(!enabled) return;

		if(_log)
		{
			trace("SimpleMedition.send()");
			for(var i:String in data)
				trace("  [ " + i + ": " + data[i] + " ]");
		}

		var request : URLRequest = new URLRequest(_url);
			request.data = data;
			request.method = _method;

		var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onSend);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onSend);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSend);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onSend);
			loader.load(request);
	}

	private function onSend(e : Event) : void
	{
		if(e.type == HTTPStatusEvent.HTTP_STATUS)
		{
			if(_log) trace("\t-> HTTP_STATUS: " + HTTPStatusEvent(e).status);
		}
		else if(e.type == Event.COMPLETE)
		{
			if(_log)
			{
				trace("\t-> Send ok!");
				trace("\t\t+> Response: " + e.target.data);
			}
		}
		else
		{
			if(_log) trace("\t-> An error ocurred ("+e.type+")");
		}

		dispatchEvent(e);
	}
}
}