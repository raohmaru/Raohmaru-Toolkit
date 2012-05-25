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
 * La clase CollectionEvent representa un evento que es distribuido cuando el objeto Collection asociado es modificado.
 * Incluye los siguientes tipos:
<ul>
	<li><code>CollectionEvent.COLLECTION_CHANGE</code>: se distribuye cuando se realiza un cambio en los elementos de la colección.</li>
	<li><code>CollectionEvent.COLLECTION_ADD</code>: se distribuye cuando se añade un elemento a la colección.</li>
	<li><code>CollectionEvent.COLLECTION_REMOVE</code>: se distribuye cuando se elimina un elemento de la colección.</li>
	<li><code>CollectionEvent.COLLECTION_REPLACE</code>: se distribuye cuando se reemplaza un elemento de la colección.</li>
</ul>
 * @see jp.raohchan.collections.Collection
 * @author raohmaru
 * @source Basado en la clase mx.events.CollectionEvent de Adobe [http://livedocs.adobe.com/flex/3/langref/mx/events/CollectionEvent.html]
 */
public class CollectionEvent extends Event
{
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>collectionChange</code>.
	 */
	public static const COLLECTION_CHANGE :String = "collectionChange";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>collectionAdd</code>.
	 */
	public static const COLLECTION_ADD :String = "collectionAdd";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>collectionRemove</code>.
	 */
	public static const COLLECTION_REMOVE :String = "collectionRemove";
	/**
	 * Define el valor de la propiedad <code>type</code> para un objeto de evento <code>collectionReplace</code>.
	 */
	public static const COLLECTION_REPLACE :String = "collectionReplace";


	private var _position :int,
				_items :Array;

	/**
	 * Obtiene el valor del índice de la colección donde se ha efectuado una modificación.
	 */
	public function get position() :int
	{
		return _position;
	}

	/**
	 * Una matriz que contiene los elementos añadidos, eliminados o reemplazados del objeto Collection.
	 */
	public function get items() :Array
	{
		return _items;
	}


	/**
	 * Crea un nuevo objeto CollectionEvent con los parámetros especificados.
	 * @param type Tipo de evento; este valor identifica la acción que ha activado el evento.
	 * @param position El valor del índice de la colección donde se ha efectuado una modificación.
	 * @param items Una matriz que contiene los elementos modificados del objeto Collection.
	 */
	public function CollectionEvent(type :String, position :int, items :Array)
	{
		_position = position;		_items = items;

		super(type, bubbles, cancelable);
	}

	/**
	 * Devuelve una cadena con todas las propiedades del objeto CollectionEvent.
	 * La cadena tiene el siguiente formato:
	 *
	 * <p>[<code>CollectionEvent type=<em>value</em> position=<em>value</em>
	 * items=<em>value</em> cancelable=<em>value</em>
     * bubbles=<em>value</em></code>]</p>
	 *
     * @return Una representación de cadena del objeto DragEvent
	 */
	override public function toString() :String
	{
		return formatToString("CollectionEvent", "type", "position", "items", "bubbles", "cancelable");
	}

	/**
	 * Crea una copia del objeto CollectionEvent y define el valor de cada parámetro para que coincida con el original.
     * @return Copia de la instancia de CollectionEvent actual.
	 */
	override public function clone() :Event
	{
		return new CollectionEvent(type, _position, _items);
	}
}
}
