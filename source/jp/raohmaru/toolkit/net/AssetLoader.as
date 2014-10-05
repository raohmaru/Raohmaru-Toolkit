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
import jp.raohmaru.toolkit.events.AssetLoaderEvent;

import flash.display.Sprite;
import flash.events.*;
import flash.net.URLRequestHeader;
import flash.utils.Dictionary;

/**
 * Se distribuye en cada fotograma informando del progreso de la operación de descarga actual y del progreso de
 * descarga global.
 * @eventType jp.raohmaru.toolkit.events.AssetLoaderEvent.PROGRESS
 */
[Event(name="assetLoaderProgress", type="jp.raohmaru.toolkit.events.AssetLoaderEvent") ]

/**
 * Se distribuye cuando ha finalizado la carga de un archivo de la lista.
 * @eventType jp.raohmaru.toolkit.events.AssetLoaderEvent.COMPLETE
 */
[Event(name="assetLoaderComplete", type="jp.raohmaru.toolkit.events.AssetLoaderEvent") ]

/**
 * Se distribuye cuando se produce un error de entrada o salida en un archivo de la lista que provoca que una operación de carga se realice incorrectamente.
 * @eventType jp.raohmaru.toolkit.events.AssetLoaderEvent.IO_ERROR
 */
[Event(name="assetLoaderIOError", type="jp.raohmaru.toolkit.events.AssetLoaderEvent") ]

/**
 * Se distribuye cuando ha finalizado la carga de archivos de la lista, aunque existan errores de lectura.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event") ]

/**
 * Se distribuye cuando se produce un error de entrada o salida en un archivo de la lista que provoca que una operación de carga se realice incorrectamente.
 * @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent") ]

/**
 * Se distribuye cuando se realiza una solicitud de red a través de HTTP y Flash Player puede detectar el código de estado HTTP.
 * Esta operación se realiza por cada archivo en la lista de descarga.
 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
 */
[Event(name="httpStatus", type="flash.events.HTTPStatusEvent") ]

/**
 * Se distribuye si se intenta cargar datos de un servidor situado fuera del entorno limitado de seguridad.
 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent") ]

/**
 * Se distribuye cuando se inicia la operación de carga de un archivo en la lista de descarga.
 * @eventType flash.events.Event.OPEN
 */
[Event(name="open", type="flash.events.Event") ]

/**
 * Se distribuye al recibirse datos mientras progresa una operación de descarga.
 * Es distribuido por el archivo de la lista en proceso de descarga.
 * @eventType flash.events.ProgressEvent.PROGRESS
 */
[Event(name="progress", type="flash.events.ProgressEvent") ]

/**
 * Se distribuye cuando las propiedades y métodos de un archivo SWF cargado están accesibles.
 * Cada archivo SWF de la lista de descarga distribuye este evento.
 * @eventType flash.events.Event.INIT
 */
[Event(name="init", type="flash.events.Event") ]

/**
 * La clase AssetLoader permite crear listas de descargas de recursos de manera secuencial. Controla el proceso de descarga
 * de cada recurso de la lista, emite eventos según su estado y mantiene un índice con el progreso de la descarga
 * individual y global.
 * @example
<listing version="3.0">
import jp.raohmaru.toolkit.net.AssetLoader;
import jp.raohmaru.toolkit.events.AssetLoaderEvent;
import flash.events.*;
import flash.display.Bitmap;
import flash.display.BitmapData;

var assetloader :AssetLoader = new AssetLoader();

    assetloader.addAsset("http://www.helpexamples.com/flash/images/image1.jpg", "image1");
    assetloader.addAsset("http://www.helpexamples.com/flash/images/image2.jpg", "image2", 2);
    assetloader.addAsset("http://www.helpexamples.com/flash/sound/song1.mp3", "song1");

    assetloader.addEventListener(AssetLoaderEvent.PROGRESS, assetHandler);
    assetloader.addEventListener(AssetLoaderEvent.COMPLETE, assetHandler);
    assetloader.addEventListener(AssetLoaderEvent.IO_ERROR, assetHandler);

    assetloader.addEventListener(Event.OPEN, eventHandler);
    assetloader.addEventListener(Event.INIT, eventHandler);
    assetloader.addEventListener(Event.COMPLETE, eventHandler);
    assetloader.addEventListener(ProgressEvent.PROGRESS, eventHandler);
    assetloader.addEventListener(IOErrorEvent.IO_ERROR, eventHandler);

    assetloader.load();

function assetHandler(e: AssetLoaderEvent) :void
{
    var arr :Array = ["type", "assetName", "progress", "overallProgress"];
    trace("ASSET_LOADER_EVENT:" )
    for(var i:int; i&lt;arr.length; i++)
        trace( "\t" + arr[i] + ": " + e[arr[i]] );

    if(e.type == AssetLoaderEvent.COMPLETE)
    {
        var bmp :Bitmap = assetloader.getContentByName(assetloader.getCurrentAsset().name) as Bitmap;
        addChild(bmp);
    }
}

function eventHandler(e :Event)
{
    trace("LOADER_EVENT: " + e.type, assetloader.getCurrentAsset().name);
}</listing>
 * @author raohmaru
 */
public class AssetLoader extends EventDispatcher
{
	/**
	 * La constante AssetLoader.FILE define el valor de la propiedad <code>type</code> de un objeto Asset.
	 * Indica que debe cargarse un archivo externo con el método <code>FileLoader.load()</code>.
	 * @see jp.raohmaru.toolkit.net.FileLoader#load()
	 */
	public static const FILE :String = "file";

	/**
	 * La constante AssetLoader.DATA define el valor de la propiedad <code>type</code> de un objeto Asset.
	 * Indica que debe cargarse datos con el método <code>DataLoader.load()</code>.
	 * @see jp.raohmaru.toolkit.net.DataLoader#load()
	 */
	public static const DATA :String = "data";

	/**
	 * La constante AssetLoader.DATA_XML define el valor de la propiedad <code>type</code> de un objeto Asset.
	 * Indica que debe cargarse datos XML con el método <code>DataLoader.loadXML()</code>.
	 * @see jp.raohmaru.toolkit.net.DataLoader#loadXML()
	 */
	public static const DATA_XML :String = "xml";

	/**
	 * La constante AssetLoader.BINARY define el valor de la propiedad <code>type</code> de un objeto Asset.
	 * Indica que debe cargarse datos XML con el método <code>DataLoader.loadBin()</code>.
	 * @see jp.raohmaru.toolkit.net.DataLoader#loadBin()
	 */
	public static const BINARY :String = "binary";

	private var _file_loader :FileLoader,
				_data_loader :DataLoader,
				_loader :Object,
				_list :Array,
				_assets :Dictionary,
				_idx :uint,
				_engine :Sprite,
				_progress :Number,
				_overall_progress :Number = 0,
				_loaded :Number = 0;

	/**
	 * Índice con el progreso de la descarga actual. Representa un valor que va del 0 (inicio) al 1 (descargado completamente).
	 */
	public function get progress() :Number
	{
		return _progress;
	}

	/**
	 * Índice con el progreso de la descarga global. Un valor que va del 0 (inicio) al 1 (todos los recursos de la lista
	 * se han descargado correctamente).
	 */
	public function get overallProgress() :Number
	{
		return _overall_progress;
	}


	/**
	 * Crea un nuevo objeto AssetLoader.
	 */
	public function AssetLoader()
	{
		_list = [];
		_assets = new Dictionary();
		_engine = new Sprite();
	}

	/**
	 * Añade un nuevo archivo o origen de datos a la lista de descarga.
	 * @param url La URL que señala a un archivo externo o a un origen de datos.
	 * @param name Nombre identificativo para el recurso.
	 * @param importance Valía del recurso para que éste ocupe un rango mayor en la propiedad <code>overallProgress</code>.
	 * @param type Un valor que define el tipo de recurso a descargar. Los posibles valores son:
	 * <ul><li>AssetLoader.FILE (un archivo)</li>
	 * <li>AssetLoader.DATA (un origen de datos, p. ej. un archivo XML)</li></ul>
	 * @param save Indica si los datos descargados deben guardarse en memoria.
	 */
	public function addAsset(url :String, name :String, importance :Number=1, type :String="file", save :Boolean=true) :void
	{
		_list.push( new Asset(url, name, importance, type, save) );

		var asset :Asset,
			t :Number = 0;
		for(var i:int=0; i<_list.length; i++)
		{
			asset = _list[i];
			t += asset.importance;
		}

		for(i=0; i<_list.length; i++)
		{
			asset = _list[i];
			asset.scale = asset.importance / t;
		}
	}

	/**
	 * Inicia la descarga de los recursos de la lista.
	 */
	public function load() :void
	{
		if(_list != null && _list.length > 0)
			loadNext();
	}

	/**
	 * Cancela la operación de descarga iniciada por el método <code>load()</code>.
	 */
	public function close() :void
	{
		if(_file_loader)
			try {
				_file_loader.close();
			}
			catch(err :Error){}

		if(_data_loader)
			try {
				_data_loader.close();
			}
			catch(err :Error){}
	}

	/**
	 * Cancela la operación de descarga, vacía la lista de recursos, elimina todas las referencias y prepara el objeto
	 * para su eliminación.
	 * Después de invocar <code>AssetLoader.dispose()</code>, el objeto AssetLoader ya no se puede utilizar.
	 */
	public function dispose() :void
	{
		close();

		if(_engine)
			_engine.removeEventListener(Event.ENTER_FRAME, update);

		if(_file_loader)
		{
			_file_loader.unload();
			removeListeners(_file_loader);
		}

		if(_data_loader)
			removeListeners(_data_loader);

		_file_loader = null;
		_data_loader = null;
		_loader = null;
		_list = null;
		_assets = null;
		_engine = null;
	}

	/**
	 * Obtiene una referencia al recurso descargado según su nombre indentificativo.
	 * @param name Nombre identificativo del recurso.
	 */
	public function getContentByName(name :String) :Object
	{
		return _assets[name];
	}

	/**
	 * Devuelve el objeto Asset activo o en proceso de descarga.
	 */
	public function getCurrentAsset() :Asset
	{
		return Asset(_list[_idx-1]).clone();
	}

	/**
	 * Devuelve un objeto Asset por el nombre.
	 * @param name Nombre identificativo del recurso.
	 */
	public function getAssetByName(name :String) :Asset
	{
		var i :int = _list.length;
		while(--i > -1)
		{
			if( Asset(_list[i]).name == name )
				return Asset(_list[i]).clone();
		}
	
		return null;
	}



	private function loadNext(e :Event=null) :void
	{
		_engine.removeEventListener(Event.ENTER_FRAME, update);

		if(e != null)
		{
			var asset :Asset = _list[_idx-1];
			_overall_progress = _loaded + asset.scale;

			if(e.type == Event.COMPLETE)
			{
				_progress = 1;
				if(asset.save)
					_assets[asset.name] = (asset.type == FILE) ? FileLoader(e.target).content : DataLoader(e.target).data;
				dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.COMPLETE, asset.name, _progress, _overall_progress) );
			}
			else
			{
				_progress = 0;
				dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.IO_ERROR, asset.name, _progress, _overall_progress) );
				dispatchEvent(e);
			}

			_loaded += asset.scale;
		}

		if(_idx < _list.length)
		{
			asset = _list[_idx];

			if(asset.type == FILE)
			{
				if(_file_loader == null)
				{
					_file_loader = new FileLoader();
					addListeners(_file_loader);
				}
				_file_loader.fload( asset.url );
				_loader = _file_loader.contentLoaderInfo;
			}
			else
			{
				if(_data_loader == null)
				{
					_data_loader = new DataLoader();
					addListeners(_data_loader);
				}
				_data_loader.headers = [];
				
				if(asset.type == DATA_XML)
					_data_loader.type = DataLoader.XML_TYPE;
				else if(asset.type == BINARY) {
					_data_loader.type = DataLoader.BINARY_TYPE;
					_data_loader.headers.push( new URLRequestHeader("Content-Type", "application/octet-stream") );
				}
				else
					_data_loader.type = DataLoader.TEXT_TYPE;
					
				_data_loader.load( asset.url );
				_loader = _data_loader;
			}
			_idx++;
		}
		else
		{
			complete();
		}
	}

	private function addListeners(target :EventDispatcher) :void
	{
		target.addEventListener(Event.COMPLETE, loadNext);
		target.addEventListener(IOErrorEvent.IO_ERROR, loadNext);
        target.addEventListener(Event.OPEN, openHandler);
		target.addEventListener(Event.INIT, eventHandler);
		target.addEventListener(ProgressEvent.PROGRESS, eventHandler);
        target.addEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
        target.addEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
	}

	private function removeListeners(target :EventDispatcher) :void
	{
		target.removeEventListener(Event.COMPLETE, loadNext);
		target.removeEventListener(IOErrorEvent.IO_ERROR, loadNext);
        target.removeEventListener(Event.OPEN, openHandler);
		target.removeEventListener(Event.INIT, eventHandler);
		target.removeEventListener(ProgressEvent.PROGRESS, eventHandler);
        target.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, eventHandler);
        target.removeEventListener(HTTPStatusEvent.HTTP_STATUS, eventHandler);
	}

	private function openHandler(e :Event) :void
	{
		if(!_engine.hasEventListener(Event.ENTER_FRAME))
			_engine.addEventListener(Event.ENTER_FRAME, update);

		dispatchEvent(e);
	}

	private function complete() :void
	{
		_progress = 1;
		_overall_progress = 1;
		dispatchEvent(new Event(Event.COMPLETE));
	}

	private function update(e :Event) : void
	{
		var asset :Asset = _list[_idx-1];

		_progress = _loader.bytesLoaded / _loader.bytesTotal;
		// Comprobación isNaN super rápida
		if(_progress != _progress)
			_progress = 0;
		_overall_progress = _loaded + asset.scale * _progress;

		dispatchEvent( new AssetLoaderEvent(AssetLoaderEvent.PROGRESS, asset.name, _progress, _overall_progress) );
	}

	private function eventHandler(e :Event) :void
	{
		dispatchEvent(e);
	}
}
}