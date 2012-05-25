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

package jp.raohmaru.toolkit.net.data
{
import flash.events.*;

import jp.raohmaru.toolkit.net.DataLoader;

/**
 * Se distribuye tras decodificar y colocar todos los datos recibidos en la propiedad <code>data</code> del objeto ExternalData.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event") ]

/**
 * Se distribuye cuando se produce un error de entrada o salida que provoca que una operación de carga se realice incorrectamente.
 * @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent") ]

/**
 * Se distribuye al recibirse datos mientras progresa una operación de descarga.
 * @eventType flash.events.ProgressEvent.PROGRESS
 */
[Event(name="progress", type="flash.events.ProgressEvent") ]

/**
 * La clase ExternalData representa una objeto que permite cargar y almacenar datos en la instancia, disparando un evento al finalizar o en caso de error.
 * @author raohmaru
 */
public class ExternalData extends SimpleData
{
	/**
	 * Crea una nueva instancia de la clase ExternalData.
	 */
	public function ExternalData ()
	{
	}

	/**
	 * Método abstracto para inicializar la clase. Debe definirse en las clases descendientes.
	 */
	public function init() : void
	{
	}

	/**
	 * Carga datos externos genéricos que luego se almacenarán en la propiedad <code>data</code>.
	 * @param url Dirección URL a cargar.
	 * @param vars Variables a enviar (una cadena con los pares nombre/valor o un objeto URLVariables).
	 * @param method Método POST o GET a utilizar al enviar datos.
	 * @see jp.raohchan.net.DataLoader#load
	 */
	public function load(url : String, vars : Object = null, method : String = "GET") : void
	{
		var data_loader : DataLoader = new DataLoader();
			data_loader.method = method;
			data_loader.addEventListener(Event.COMPLETE, onLoad);
			data_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoad);			data_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			data_loader.load(url, vars);
	}

	/**
	 * @private
	 */
	protected function onLoad(e :Event) : void
	{
		if(e.type == Event.COMPLETE)
			_data = e.target.data;

		dispatchEvent(e);

		e.target.removeEventListener(Event.COMPLETE, onLoad);
		e.target.removeEventListener(IOErrorEvent.IO_ERROR, onLoad);
		e.target.removeEventListener(ProgressEvent.PROGRESS, onProgress);
	}

	/**
	 * @private
	 */
	protected function onProgress(e :ProgressEvent) : void
	{
		dispatchEvent(e);
	}
}
}