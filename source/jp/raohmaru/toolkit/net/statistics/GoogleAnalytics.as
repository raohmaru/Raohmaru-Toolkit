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
import flash.external.ExternalInterface;

/**
 * La clase GoogleAnalytics permite enviar peticiones de medición a la API de Google Analytics.
 * Una instancia de GoogleAnalytics se comunica directamente con el JavaScript ubicado en la página HTML contenedora, y envía peticiones de medición invocando al
 * método <code>_gaq.push()</code>.<br>
 * Para que funcione la llamada al JavaScript de Google Analytics, se debe añadir al objeto Flash en la página HTML el parámetro
 * <code>allowScriptAccess</code> igual a "always".
 * @see http://code.google.com/apis/analytics/docs/flashTrackingIntro.html
 * @author raohmaru
 */
public class GoogleAnalytics implements IMedition
{
	private var _url : String,
				_enabled : Boolean,
				_log : Boolean;


	/**
	 * La URL que se va a solicitar.
	 * @default "_gaq.push"
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
	 * Define o obtiene el estado de la instancia GoogleAnalytics. Si es <code>false</code>, se desactivarán las llamadas a <code>GoogleAnalytics.send()</code>
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
	 * Define si debe mostrarse cada petición realizada con <code>GoogleAnalytics.send()</code> en la consola de salida.
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
	 * Crea un nuevo objeto GoogleAnalytics y define la propiedad <code>url</code> a "_gaq.push".
	 * @param enabled Define el estado de la instancia GoogleAnalytics.
	 * @param log Define si debe mostrarse cada petición realizada con <code>GoogleAnalytics.send()</code> en la consola de salida.
	 * @param url La URL que se va a solicitar.
	 */
	public function GoogleAnalytics(enabled :Boolean=true, log :Boolean=false, url :String="_gaq.push")
	{
		this.enabled = enabled;		this.log = log;		this.url = url;
	}

	/**
	 * Envía una petición de medición de página vista a Google Analytics. La comunicación se establece a través de <code>ExternalInterface.call()</code>.
	 * @param data Cadena con la página a medir
	 * @see flash.external.ExternalInterface
	 * @example
	 <listing version="3.0">
import jp.raohmaru.toolkit.net.statistics.GoogleAnalytics;

var ga : GoogleAnalytics = new GoogleAnalytics();
    ga.send("/home/boton_enviar");</listing>
	 */
	public function send(data :Object) : void
	{
		if(_log) trace("@trackPageview: " + data);
		if(_enabled) ExternalInterface.call(url, ["_trackPageview", data]);
	}

	/**
	 * Alias of <code>send()</code>.
	 * @param data Cadena con la página a medir
	 * @see #send()
	 */
	public function trackPageview(data :String) : void
	{
		send(data);
	}

	/**
	 * Envía una petición de seguimiento de eventos a Google Analytics. La comunicación se establece a través de <code>ExternalInterface.call()</code>.
	 * @param category Categoría de eventos general.
	 * @param action Acción del evento.
	 * @param label Descriptor opcional del evento.
	 * @see flash.external.ExternalInterface
	 * @example
	 <listing version="3.0">
import jp.raohmaru.toolkit.net.statistics.GoogleAnalytics;

var ga : GoogleAnalytics = new GoogleAnalytics();
    ga.trackEvent("Menu", "Ayuda", "Etiqueta_1");</listing>
	 */
	public function trackEvent(category :String, action :String, label :String=null) : void
	{
		if(_log) trace( "@trackEvent: " + category + " > " + action + (label!=null ? " > "+label : "") );
		if(_enabled) ExternalInterface.call(url, ["_trackEvent", category, action, label]);
	}
}
}