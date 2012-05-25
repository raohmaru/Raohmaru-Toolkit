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

package jp.raohmaru.toolkit.events
{
import flash.events.Event;

/**
 * La clase AssetLoaderEvent define eventos asociados a un objeto AssetLoader.
 * Incluyen lo siguiente:
<ul>
	<li><code>AssetLoaderEvent.PROGRESS</code>: se distribuye cuando se actualiza el progreso de la operación de descarga.</li>
	<li><code>AssetLoaderEvent.COMPLETE</code>: se distribuye cuando ha finalizado la carga de un archivo de la lista.</li>
	<li><code>AssetLoaderEvent.IO_ERROR</code>: se distribuye cuando se produce un error de entrada o salida en un archivo de la lista que provoca que una operación de carga se realice incorrectamente.</li>
</ul>
 * @see jp.raohchan.net.AssetLoader
 * @author raohmaru
 */
public class AssetLoaderEvent extends Event
{
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>assetLoaderProgress</code>.
	 */
	public static const PROGRESS : String = "assetLoaderProgress";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>assetLoaderComplete</code>.
	 */
	public static const COMPLETE : String = "assetLoaderComplete";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>assetLoaderIOError</code>.
	 */
	public static const IO_ERROR : String = "assetLoaderIOError";

	private var	_asset_name :String,
				_progress :Number,
				_overall_progress :Number;

	/**
	 * Obtiene el nombre identificativo del objeto Asset activo.
	 */
	public function get assetName() :String
	{
		return _asset_name;
	}
	/**
	 * Obtiene un número con el progreso de la descarga actual. Representa un valor que va del 0 (inicio) al 1 (descargado completamente).
	 * @see jp.raohchan.net.AssetLoader.progress
	 */
	public function get progress() :Number
	{
		return _progress;
	}
	/**
	 * Obtiene un número con el progreso de la descarga global. Un valor que va del 0 (inicio) al 1 (todos los recursos de la lista
	 * se han descargado correctamente).
	 * @see jp.raohchan.net.AssetLoader.overallProgress
	 */
	public function get overallProgress() :Number
	{
		return _overall_progress;
	}


	/**
	 * Crea un nuevo objeto AssetLoaderEvent con los parámetros especificados.
	 * @param type Tipo de evento; este valor identifica la acción que ha activado el evento.
	 * @param assetName Nombre identificativo del recurso activo.
	 * @param progress Progreso de la descarga del recurso activo.
	 * @param overallProgress Progreso de la descarga global.
	 */
	public function AssetLoaderEvent(type :String, assetName :String, progress :Number, overallProgress :Number)
	{
		_asset_name = assetName;
		_progress = progress;
		_overall_progress = overallProgress;

		super(type, bubbles, cancelable);
	}

	/**
	 * Devuelve una cadena con todas las propiedades del objeto AssetLoaderEvent.
	 * La cadena tiene el siguiente formato:
	 *
	 * <p>[<code>AssetLoaderEvent type=<em>value</em> assetName=<em>value</em>
	 * progress=<em>value</em> overallProgress=<em>value</em> cancelable=<em>value</em>
     * bubbles=<em>value</em></code>]</p>
	 *
     * @return Una representación de cadena del objeto DragEvent
	 */
	override public function toString() :String
	{
		return formatToString("AssetLoaderEvent", "type", "assetName", "progress", "overallProgress", "bubbles", "cancelable");
	}

	/**
	 * Crea una copia del objeto AssetLoaderEvent y define el valor de cada parámetro para que coincida con el original.
     * @return Copia de la instancia de AssetLoaderEvent actual.
	 */
	override public function clone() :Event
	{
		return new AssetLoaderEvent(type, _asset_name, _progress, _overall_progress);
	}
}
}
