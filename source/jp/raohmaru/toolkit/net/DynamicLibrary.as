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
import flash.errors.IllegalOperationError;
import flash.events.*;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;

/**
 * La clase DynamicLibrary permite cargar archivos SWF y acceder a las clases vínculadas a esos archivos.
 * @example
<listing version="3.0">
import jp.raohchan.net.DynamicLibrary;

var dll :DynamicLibrary = new DynamicLibrary();
	dll.addEventListener(Event.COMPLETE, completeHandler);
	dll.addEventListener(ProgressEvent.PROGRESS, progressHandler);
	dll.load("assets/dll_assets.swf");

function completeHandler(e :Event) :void
{
	trace( "domain: " + dll.domain );
	trace( "isLoading: " + dll.isLoading() );

	var classRef :Class = dll.getClass("Penta");

	// ...
}

function progressHandler(e :ProgressEvent) :void
{
	trace( "loaded: " + dll.loaded );
}</listing>
 * @see flash.display.Loader
 * @author raohmaru
 */
public class DynamicLibrary extends EventDispatcher
{
	private var _loader :Loader = null;

	/**
	 * Obtiene el dominio de la aplicación del archivo SWF cargado.
	 * @see flash.display.LoaderInfo.applicationDomain
	 */
	public function get domain() :ApplicationDomain
	{
		return _loader.contentLoaderInfo.applicationDomain;
	}

	/**
	 * Obtiene el progreso de la descarga (0 -&gt; nada descargado, 1 -&gt; 100% descargado)
	 */
	public function get loaded() : Number
	{
		return _loader.contentLoaderInfo.bytesLoaded/_loader.contentLoaderInfo.bytesTotal;
	}



	/**
	 * Crea un nuevo objeto DynamicLibrary para la carga de clases externas.
	 */
	public function DynamicLibrary()
	{
		_loader = new Loader();
	}

	/**
	 * Carga un archivo SWF.
	 * @param swf URL absoluta o relativa del archivo SWF.
	 */
	public function load(swf :String) :void
	{
		close();

		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, eventHandler);		_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, eventHandler);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);
		_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);

		_loader.load( new URLRequest(swf) );
	}

	/**
	 * Cancela una operación de carga que está actualmente en curso.
	 */
	public function close() :void
	{
		if(isLoading())
		{
			removeListeners();
			_loader.close();
		}
	}

	/**
	 * Elimina el objeto SWF que se cargó utilizando el método <code>load()</code>.
	 */
	public function unload() :void
	{
		close();

		try
		{
			_loader.unload();
		}
		catch ( e :Error ){}
	}

	/**
	 * Obtiene una clase pública del dominio del SWF cargado.
	 * @param name Nombre de la definición de la clase.
	 * @return Una referencia a la clase. En caso de no existir la clase en el dominio de la aplicación genera un error <code>IllegalOperationError</code>.
	 * @see flash.system.ApplicationDomain.getDefinition()
	 */
	public function getClass( name :String ) :Class
	{
		try
		{
			return _loader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
		}
		catch ( e :Error )
		{
			throw new IllegalOperationError(name + " definition not found in ");
		}
		return null;
	}

	/**
	 * Determina si hay una operación de carga en curso.
	 * @return Valor booleano que indica si hay una carga en curso.
	 */
	public function isLoading() :Boolean
	{
		return _loader.contentLoaderInfo.willTrigger(Event.COMPLETE);
	}



	private function eventHandler(e :Event) :void
	{
		if(e.type != ProgressEvent.PROGRESS)
			removeListeners();

		dispatchEvent(e);
	}

	private function removeListeners() :void
	{
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, eventHandler);
		_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, eventHandler);
		_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
	}
}
}