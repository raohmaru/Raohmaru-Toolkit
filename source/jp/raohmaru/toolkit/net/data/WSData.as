/*
Copyright (C) 2012 raohmaru <http://raohmaru.com>

This file is part of Raohmaru Toolkit.

Raohmaru Toolkit is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Raohmaru Toolkit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Raohmaru Toolkit.  If not, see <http://www.gnu.org/licenses/>.
*/

package jp.raohmaru.toolkit.net.data
{
import flash.events.*;
import flash.net.URLVariables;

import jp.raohmaru.toolkit.net.*;

/**
 * El objeto WSData permite cargar datos recibidos tras una petición a un servicio web.
 * @author raohmaru
 */
public class WSData extends XMLData
{
	/**
	 * Crea un nuevo objeto WSData.
	 */
	public function WSData()
	{

	}

	/**
	 * Realiza una petición a un servicio web siguiendo el protocolo SOAP 1.2 y almacena los datos recibidos en la propiedad <code>data</code>.
	 * @param url Dirección URL del proveedor de servicios web.
	 * @param vars Variables a enviar (una cadena con los pares nombre/valor o un objeto URLVariables).
	 * @param method Nombre del método a invocar del servicio web.
	 * @see jp.raohmaru.toolkit.net.WebService#callMethod
	 */
	override public function load(url : String, vars : Object = null, method : String = "") : void
	{
		var ws : WebService = new WebService();
			ws.connect(url);
			ws.addEventListener(Event.COMPLETE, onLoad);
			ws.addEventListener(IOErrorEvent.IO_ERROR, onLoad);
			ws.addEventListener(ProgressEvent.PROGRESS, onProgress);
			ws.callMethod(method, URLVariables(vars));
	}

	/**
	 * @private
	 */
	override protected function onLoad(e : Event) : void
	{
		if(e.type == Event.COMPLETE)
			_data = e.target.data;

		dispatchEvent(e);

		e.target.removeEventListener(Event.COMPLETE, onLoad);
		e.target.removeEventListener(IOErrorEvent.IO_ERROR, onLoad);
		e.target.removeEventListener(ProgressEvent.PROGRESS, onProgress);
	}
}
}