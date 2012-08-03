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
import flash.display.Loader;
import flash.events.*;
import flash.net.URLRequest;
import flash.system.LoaderContext;

/**
 * Se distribuye cuando los datos se han cargado correctamente. El evento <code>complete</code> siempre se distribuye después del evento <code>init</code>.
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
 * Se distribuye cuando las propiedades y métodos de un archivo SWF cargado están accesibles.
 * @eventType flash.events.Event.INIT
 */
[Event(name="init", type="flash.events.Event") ]

/**
 * Se distribuye mediante un objeto LoaderInfo cuando un objeto cargado se elimina utilizando el método <code>unload()</code> del objeto Loader o cuando el mismo
 * objeto Loader realiza una segunda carga y el contenido original se elimina antes de que comience la carga.
 * @eventType flash.events.Event.UNLOAD
 */
[Event(name="unload", type="flash.events.Event") ]

/**
 * Clase proxy para cargar y visualizar archivos externos (swf o de imagen). Crea una contenedor que luego debe añadirse a la lista de visualización.<br><br>
 * En el ejemplo siguiente se carga una imagen externa con <code>FileLoader.fload()</code> y se le registra el evento <code>Event.COMPLETE</code>; a continuación
 * se genera un Bitmap con el objeto de visualización que se cargó (<code>content</code>), y finalmente se descarga (se elimina  el elemento secundario del objeto
 * FileLoader) con el método heredado <code>Loader.unload()</code>.
 * @example
<listing version="3.0">
import flash.display.*;import flash.events.Event;import jp.raohmaru.toolkit.net.FileLoader;

var floader :FileLoader = new FileLoader();
	floader.addEventListener(Event.COMPLETE, onPicLoad);	floader.addEventListener(IOErrorEvent.IO_ERROR, onError);
	floader.fload("http://www.adobe.com/lib/com.adobe/template/gnav/adobe-hq.png");

function onPicLoad(e :Event) : void
{
	var bmd:BitmapData = new BitmapData(e.target.content.width, e.target.content.height, false, 0xFFFFFF);
		bmd.draw(e.target.content);
	addChild( new Bitmap(bmd, "auto", true) );

	FileLoader(e.target).unload();
	e.target.removeEventListener(Event.COMPLETE, onPicLoad);
	e.target.removeEventListener(IOErrorEvent.IO_ERROR, onError);
}function onError(e :IOErrorEvent) : void
{
	// ...
}</listing>
 * @see flash.display.Loader
 * @author raohmaru
 */
public class FileLoader extends Loader
{
	/**
	 * Obtiene el progreso de la descarga (0 -&gt; nada descargado, 1 -&gt; 100% descargado)
	 */
	public function get loaded() : Number
	{
		return contentLoaderInfo.bytesLoaded/contentLoaderInfo.bytesTotal;
	}

	/**
	 * Nuevo FileLoader que puede añadirse a la lista de visualización.
	 */
	public function FileLoader()
	{
		contentLoaderInfo.addEventListener(Event.OPEN, eventHandler);
		contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
		contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventHandler);
		contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler);
		contentLoaderInfo.addEventListener(Event.INIT, eventHandler);
		contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
		contentLoaderInfo.addEventListener(Event.UNLOAD, eventHandler);
	}

	/**
	 * Carga un archivo externo (archivos SWF, JPEG, JPEG progresivo, GIF sin animar o PNG).
	 * @param file URL del archivo
	 * @param context Un objeto LoaderContext
	 * @see flash.display.Loader#load()
	 */
	public function fload(file : String, context : LoaderContext = null) : void
	{
		load( new URLRequest(file), context );
	}

	private function eventHandler(e : Event) : void
	{
		dispatchEvent(e);
	}
}
}