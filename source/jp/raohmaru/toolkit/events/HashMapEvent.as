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
 * La clase HashMapEvent representa un evento que es distribuido cuando el objeto HashMap asociado es modificado.
 * Incluye los siguientes tipos:
<ul>
	<li><code>HashMapEvent.HASHMAP_CHANGE</code>: se distribuye cuando se realiza un cambio en los elementos del objeto HashMap.</li>
	<li><code>HashMapEvent.HASHMAP_ADD</code>: se distribuye cuando se añade un elemento al objeto HashMap.</li>
	<li><code>HashMapEvent.HASHMAP_REMOVE</code>: se distribuye cuando se elimina un elemento del objeto HashMap.</li>
	<li><code>HashMapEvent.HASHMAP_REPLACE</code>: se distribuye cuando se reemplaza un elemento del objeto HashMap.</li>
	<li><code>HashMapEvent.HASHMAP_RESET</code>: se distribuye cuando se reestablecen  los valores de un objeto HashMap.</li>
</ul>
 * @see jp.raohchan.collections.HashMap
 * @author raohmaru
 */
public class HashMapEvent extends Event
{
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>hashMapChange</code>.
	 */
	public static const HASHMAP_CHANGE :String = "hashMapChange";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>hashMapAdd</code>.
	 */
	public static const HASHMAP_ADD :String = "hashMapAdd";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>hashMapRemove</code>.
	 */
	public static const HASHMAP_REMOVE :String = "hashMapRemove";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>hashMapReplace</code>.
	 */
	public static const HASHMAP_REPLACE :String = "hashMapReplace";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>hashMapReset</code>.
	 */
	public static const HASHMAP_RESET:String = "hashMapReset";


	private var _key :*,
				_value :*;

	/**
	 * Obtiene la clave del objeto HashMap que se ha modificado.
	 */
	public function get key() :*
	{
		return _key;
	}

	/**
	 * Obtiene el valor asociado a la clave del objeto HashMap que se ha modificado.
	 */
	public function get value() :*
	{
		return _value;
	}



	/**
	 * Crea un nuevo objeto HashMapEvent con los parámetros especificados.
	 * @param type Tipo de evento; este valor identifica la acción que ha activado el evento.
	 * @param key La clave del objeto HashMap que se ha modificado.
	 * @param value El valor asociado a la clave del objeto HashMap que se ha modificado.
	 */
	public function HashMapEvent(type :String, key :*, value :*)
	{
		_key = key;		_value = value;

		super(type, bubbles, cancelable);
	}

	/**
	 * Devuelve una cadena con todas las propiedades del objeto HashMapEvent.
	 * La cadena tiene el siguiente formato:
	 *
	 * <p>[<code>HashMapEvent type=<em>value</em> key=<em>value</em>
	 * value=<em>value</em> cancelable=<em>value</em>
     * bubbles=<em>value</em></code>]</p>
	 *
     * @return Una representación de cadena del objeto DragEvent
	 */
	override public function toString() :String
	{
		return formatToString("HashMapEvent", "type", "key", "value", "bubbles", "cancelable");
	}

	/**
	 * Crea una copia del objeto HashMapEvent y define el valor de cada parámetro para que coincida con el original.
     * @return Copia de la instancia de HashMapEvent actual.
	 */
	override public function clone() :Event
	{
		return new HashMapEvent(type, _key, _value);
	}
}
}
