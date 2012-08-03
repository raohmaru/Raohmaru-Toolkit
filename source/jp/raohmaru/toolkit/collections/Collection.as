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

package jp.raohmaru.toolkit.collections
{
import flash.events.*;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

import jp.raohmaru.toolkit.events.CollectionEvent;
import jp.raohmaru.toolkit.utils.ArrayUtil;

/**
 * Se distribuye cuando se realiza un cambio en los elementos del objeto Collection.
 * @eventType jp.raohmaru.toolkit.events.CollectionEvent.COLLECTION_CHANGE
 */
[Event(name="collectionChange", type="jp.raohmaru.toolkit.events.CollectionEvent") ]
/**
 * Se distribuye cuando se añade un elemento en el objeto Collection.
 * @eventType jp.raohmaru.toolkit.events.CollectionEvent.COLLECTION_ADD
 */
[Event(name="collectionAdd", type="jp.raohmaru.toolkit.events.CollectionEvent") ]
/**
 * Se distribuye cuando se elimina un elemento del objeto Collection.
 * @eventType jp.raohmaru.toolkit.events.CollectionEvent.COLLECTION_REMOVE
 */
[Event(name="collectionRemove", type="jp.raohmaru.toolkit.events.CollectionEvent") ]
/**
 * Se distribuye cuando se reemplaza un elemento del objeto Collection.
 * @eventType jp.raohmaru.toolkit.events.CollectionEvent.COLLECTION_REPLACE
 */
[Event(name="collectionReplace", type="jp.raohmaru.toolkit.events.CollectionEvent") ]

/**
 * La clase Collection le permite guardar datos en una colección y realizar operaciones sobre la misma.
 * Un objeto Collection distribuye eventos CollectionEvent cuando se realizan modificaciones sobre los datos contenidos.<br><br>
 * Esta clase permite además utilizar el operador de acceso a matriz [] para acceder a los métodos <code>getItemAt()</code> y <code>setItemAt()</code>.
 * @see jp.raohmaru.toolkit.events.CollectionEvent
 * @example
<listing version="3.0">
import jp.raohmaru.toolkit.collections.Collection;
import jp.raohmaru.toolkit.events.CollectionEvent;var col :Collection = new Collection();
	col.addEventListener(CollectionEvent.COLLECTION_ADD, collectionHandler);
	col.addItem(541);
	col.addItem(12.2);
	col.addItem(true);
	col.addItem(0xFF0071);trace( col.getItemAt(1) );  // 12.2trace( col[1] );  // 12.2col[1] = "orange";trace( col );  // 541,orange,true,16711793function collectionHandler(e :CollectionEvent)
{
	trace(e.target.length);	// Salida: 1	// 			2	// 			3	// 			4
}
</listing>
 * @author raohmaru
 * @source Basado en la clase mx.collections.ListCollectionView de Adobe [http://livedocs.adobe.com/flex/3/langref/mx/collections/ListCollectionView.html]
 * @source Basado en la clase ca.newcommerce.data.ArrayCollection de Eric J. Feminella [http://www.newcommerce.ca/]
 */
public class Collection extends Proxy implements IEventDispatcher, Iterable
{
	/**
	 * @private
	 */
	protected var	_dispatcher :EventDispatcher,
					_data :Array,
					_integrity_rule :Class;

	/**
	 * Obtiene el número de elementos de la colección.
	 */
	public function get length() :uint
	{
		return _data.length;
	}

	/**
	 * Obtiene un nuevo iterador para la colección de datos asociada.
	 * @return Una nueva instancia de Iterator
	 * @see ArrayIterator
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;
	import jp.raohmaru.toolkit.collections.Iterator;

	var collection :Collection = new Collection();		collection.addItem(0);		collection.addItem(1);		collection.addItem(2);		collection.addItem(3);		collection.addItem(4);
	var iterator:Iterator = collection.iterator;

	while( iterator.hasNext() )
	{
		trace( iterator.next() );
		// salida:
		//				0
		//				1
		//				2
		//				3
		//				4
	}
	</listing>
	 */
	public function get iterator() :Iterator
	{
		return new ArrayIterator( toArray() );
	}

	/**
	 * Establece una clase que será utilizada como regla de identidad, comparándola con el tipo de los nuevos datos a introducir.
	 * Si el tipo (la clase del dato) no coincide, el nuevo dato no será añadido a la colección y en la consola de salida se mostrará un mensaje
	 * de alerta.<br>
	 * Si la regla de identidad se establece en una colección que ya tiene datos, se chequeará y los se eliminarán los datos que no coincidan con
	 * el nuevo tipo
	 * @example En el siguiente ejemplo se crea una colección que sólo acepta datos del tipo uint.
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var uint_collection = new Collection();
		uint_collection.integrityRule = uint;

		uint_collection.addItem(15.7);  // Producirá un Warning
		uint_collection.addItem(2);
		uint_collection.addItem(-11);  // Producirá un Warning		uint_collection.addItem(11);		uint_collection.integrityRule = String;  // Cambia las reglas de identidad, eliminando los datos que no sean del tipo String
	</listing>
	 */
	public function get integrityRule() : Class
	{
		return _integrity_rule;
	}
	public function set integrityRule(rule :Class) : void
	{
		_integrity_rule = rule;
		checkIntegrity();
	}



	/**
	 * Le permite crear un objeto Collection con el número especificado de elementos.
	 * @param num_items  Un entero que especifica el número de elementos de la colección
	 */
	public function Collection(num_items :uint = 0) :void
	{
		_data = new Array(num_items);
		_dispatcher = new EventDispatcher(this);
	}

	/**
	 * Añade un elemento al final de la colección.
	 * @param item Elemento a añadir
	 * @return La nueva longitud de la colección
	 */
	public function addItem(item :Object) :uint
	{
		if(checkItemIntegrity(item))
		{
			var len :uint = _data.push(item);
			dispatchCollectionEvent(CollectionEvent.COLLECTION_ADD, len-1, [item]);
		}

		return length;
	}

	/**
	 * Añade un elemento en la posición de índice especificada.
	 * Si el índice esta fuera de los límites de la matriz interna, se emitirá un error fuera de rango (<code>RangeError</code>).
	 * @param item Elemento a añadir	 * @param index Posición de índice en la que se añade el elemento
	 * @return La nueva longitud de la colección
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("a");
		col.addItem("b");
		col.addItemAt("c", col.length-1);
	</listing>
	 */
	public function addItemAt(item :Object, index :uint) :uint
	{
		if(checkItemIntegrity(item))
		{
			if(index < 0 || index >= length) throw new RangeError("El índice esta fuera de los límites de la colección");

			_data.splice(index, 0, item);
			dispatchCollectionEvent(CollectionEvent.COLLECTION_ADD, index, [item]);
		}

		return length;
	}

	/**
	 * Añade los valores incluidos en la matriz especificada al final de la colección.
	 * @param source Matriz que contiene los datos que formarán parte de la colección
	 * @return La nueva longitud de la colección
	 */
	public function addItems(source :Array) :uint
	{
		for(var i:int=0; i<source.length; i++)
			addItem(source[i]);

		return length;
	}

	/**
	 * Obtiene un elemento en la posición de índice especificada.
	 * Si el índice esta fuera de los límites de la matriz interna, se emitirá un error fuera de rango (<code>RangeError</code>).
	 * @param index Posición de índice del elemento
	 * @return El elemento situado en la posición de índice especificada o un objeto <code>null</code>
	 */
	public function getItemAt(index :uint) :Object
	{
		if(index < 0 || index >= length) throw new RangeError("El índice esta fuera de los límites de la colección");

		return _data[index];
	}

	/**
	 * Devuelve la posición de índice de un elemento de la colección.
	 * Si no se encuentra el elemento, el valor devuelto es <code>-1</code>.
	 * @param item El elemento que se va a buscar en la matriz interna
	 * @return La posición de índice del elemento en la colección. Si no se encuentra el elemento, el valor devuelto es <code>-1</code>
	 */
	public function getItemIndex(item :Object) :int
	{
		return _data.indexOf(item, 0);
	}

	/**
	 * Establece un elemento en la posición de índice especificada.
	 * Si ya existe un elemento en esa posición, será reemplazado por el nuevo elemento.
	 * Si el índice esta fuera de los límites de la matriz interna, se emitirá un error fuera de rango (<code>RangeError</code>).
	 * @param item Elemento de reemplazo
	 * @param index Posición de índice en la que se reemplazará el elemento
	 * @return El elemento reemplazado
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("naranja");
		col.addItem("limón");
	trace( col.setItemAt("lima", 0) );  // "naranja"	trace( col );  // lima,limón
	</listing>
	 */
	public function setItemAt(item :Object, index :uint) :Object
	{
		if(!checkItemIntegrity(item)) return null;

		if(index < 0 || index >= length) throw new RangeError("El índice esta fuera de los límites de la colección");

		var old_item :Object = _data[index];

		_data[index] = item;

		dispatchCollectionEvent(CollectionEvent.COLLECTION_REPLACE, index, [old_item]);
		return old_item;
	}

	/**
	 * Reemplaza un elemento por otro elemento dentro de la colección.
	 * @param new_item Elemento de reemplazo
	 * @param old_item Elemento a reemplazar
	 * @return Un valor booleano que representa el resultado de la operación
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;
	var item :int = 12;
	var col :Collection = new Collection();
		col.addItem(item);
		col.addItem(24);
	trace( col.replaceItem(2, item) );  // true	trace( col.replaceItem(48, "24") );  // false	trace( col.replaceItem(48, 24) );  // true	trace( col );  // 2,48
	</listing>
	 */
	public function replaceItem(new_item :Object, old_item :Object) :Boolean
	{
		if(!checkItemIntegrity(new_item)) return false;

		var index :int = getItemIndex(old_item);
		if(index == -1) return false;

		_data.splice(index, 1, new_item);
		dispatchCollectionEvent(CollectionEvent.COLLECTION_REPLACE, index, [old_item]);
		return true;
	}

	/**
	 * Elimina el elemento especificado de la colección.
	 * @param item Elemento a eliminar
	 * @return Un valor booleano que representa el resultado de la operación
	 */
	public function removeItem(item :Object) :Boolean
	{
		var index :int = getItemIndex(item);
		if(index == -1) return false;

		removeItemAt(index);
		return true;
	}

	/**
	 * Elimina el elemento especificado de la posición de índice especificada.
	 * Si el índice esta fuera de los límites de la matriz interna, se emitirá un error fuera de rango (<code>RangeError</code>).
	 * @param index Posición de índice en la que se encuentra el elemento
	 * @return El elemento eliminado
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("Manwë");
		col.addItem("Varda");		col.addItem("Tulkas");

	var removed_item :Object = col.removeItemAt(2);
	trace( removed_item );  // Tulkas
	trace( col );  // Manwë,Varda
	</listing>
	 */
	public function removeItemAt(index :uint) :Object
	{
		if(index < 0 || index >= length) throw new RangeError("El índice esta fuera de los límites de la colección");

		var result_arr :Array = _data.splice(index, 1);
		dispatchCollectionEvent(CollectionEvent.COLLECTION_REMOVE, index, result_arr);
		return (result_arr.length > 0 ? result_arr[0] : null);
	}

	/**
	 * Elimina todos los elementos de la colección.
	 * @return Una matriz con los elementos eliminados
	 */
	public function removeAll() :Array
	{
		var copy_arr :Array = ArrayUtil.clone(_data);

		_data.splice(0, _data.length);

		dispatchCollectionEvent(CollectionEvent.COLLECTION_REMOVE, -1, [copy_arr]);
		return copy_arr;
	}

	/**
	 * Comprueba si el objeto Collection contiene el objeto especificado.
	 * @return Si el objeto Collection contiene el objeto especificado, el valor es <code>true</code>. En caso contrario, <code>false</code>
	 */
	public function contains(item :Object) :Boolean
	{
		return getItemIndex(item) > -1;
	}

	/**
	 * Devuelve una copia del objeto Collection actual.
	 * @return Una copia del objeto Collection actual
	 */
	public function clone() :Collection
	{
		var collect_clone :Collection = new Collection();

		for(var i:int=0; i<_data.length; i++)
			collect_clone.addItem(_data[i]);

		return collect_clone;
	}

	/**
	 * Ordena los elementos de la colección.
	 * @see Array.sort()
	 */
	public function sort(...args) : void
	{
		if(args[0] && args[1])
			_data.sort(args[0], args[1]);

		else if(args[0])
			_data.sort(args[0]);

		else if(args[1])
			_data.sort(args[1]);

		else
			_data.sort();

		_dispatcher.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, 0, ArrayUtil.clone(_data)));
	}



	/**
	 * Devuelve una cadena que representa los elementos de la colección especificada.
	 * @return Una cadena de elementos de la colección
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("cero");		col.addItem("uno");
		col.addItem("dos");		col.addItem("tres");
	trace( col );  // cero,uno,dos,tres
	</listing>
	 */
	public function toString() : String
	{
		return _data.toString();
	}

	/**
	 * Devuelve una matriz con los elementos de la colección de datos
	 * @return Una matriz que contiene los elementos de la colección
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("cero");
		col.addItem("uno");
		col.addItem("dos");
		col.addItem("tres");
	var arr :Array = col.toArray();
	trace(arr) // cero,uno,dos,tres	trace(arr.length) // 4
	</listing>
	 */
	public function toArray() : Array
	{
		return ArrayUtil.clone(_data);
	}



	/**
	 * Distrubuye los eventos CollectionEvent asociados.
	 * @see jp.raohmaru.toolkit.events.CollectionEvent
	 */
	private function dispatchCollectionEvent(type :String, position :int, items :Array) :void
	{
		_dispatcher.dispatchEvent(new CollectionEvent(type, position, items));		_dispatcher.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, position, items));
	}

	/**
	 * Comprueba el tipo de datos a añadir con en el tipo establecido en <code>integrityRule</code>. Si el tipo (la clase del dato) es diferente,
	 * no será añadido a la colección.
	 * @param value El nuevo dato a incorporar
	 * @return Un valor booleano que indica si el tipo es correcto
	 */
	private function checkItemIntegrity(value :*) : Boolean
	{
		if(!_integrity_rule) return true;

		var ok :Boolean = (value is _integrity_rule);

		if(!ok)
		{
			//throw new IllegalOperationError("El nuevo valor no cumple con las reglas de integridad " + _integrity_rule);
			trace( "Warning: El valor (" + value + ") no cumple con las reglas de integridad " + _integrity_rule + "\n\t No será añadido a la colección");
		}

		return ok;
	}

	/**
	 * Comprueba la integridad de los datos de la colección según el tipo establecido en <code>integrityRule</code>.
	 */
	private function checkIntegrity() : void
	{
		var checked_data :Array = [],
			illegal_data :Array = [];

		if(_integrity_rule)
		{
			for(var i:int=0; i<_data.length; i++)
			{
				if(_data[i] is _integrity_rule)
				{
					checked_data.push(_data[i]);
				}
				else
				{
					illegal_data[i] = _data[i];
				}
			}
		}

		_data = checked_data;

		for(i=0; i<illegal_data.length; i++)
			if(illegal_data[i]) dispatchCollectionEvent(CollectionEvent.COLLECTION_REMOVE, i, [illegal_data[i]]);
	}


	/**
	 * Método proxy. Permite obtener un elemento de la colección con el operador de acceso a matriz []. Internamente invoca al método <code>getItemAt()</code>.
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("cero");
		col.addItem("uno");
	trace( col[0] ) // cero
	</listing>
	 * @private
	 */
    override flash_proxy function getProperty(name :*) :*
    {
    	name = parseInt(name);
    	if(isNaN(name)) name = -1;
        return getItemAt(name);
    }

	/**
	 * Método proxy. Permite cambiar el valor de un elemento de la colección con el operador de acceso a matriz []. Internamente invoca al método
	 * <code>setItemAt()</code>.
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.Collection;

	var col :Collection = new Collection();
		col.addItem("cero");
		col.addItem("uno");
	col[1] = 1;	trace( col );  // cero,1
	</listing>
	 * @private
	 */
    override flash_proxy function setProperty(name :*, value :*) :void
    {
    	name = parseInt(name);
    	if(isNaN(name)) name = -1;
        setItemAt(value, name);
    }




	/**
	 * Registra un objeto de detector de eventos con un objeto EventDispatcher, de modo que el detector reciba la notificación de un evento.
	 * @see flash.events.EventDispatcher#addEventListener()
	 */
	public function addEventListener(type :String, listener :Function, useCapture :Boolean = false, priority :int = 0, useWeakReference :Boolean = false) :void
	{
		_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
	}

	/**
	 * Distribuye un evento en el flujo del evento.
	 * @see flash.events.EventDispatcher#dispatchEvent()
	 */
	public function dispatchEvent(evt :Event) :Boolean
	{
		return _dispatcher.dispatchEvent(evt);
	}

	/**
	 * Elimina un detector del objeto EventDispatcher.
	 * @see flash.events.EventDispatcher#removeEventListener()
	 */
	public function removeEventListener(type :String, listener :Function, useCapture :Boolean = false) :void
	{
		_dispatcher.removeEventListener(type, listener, useCapture);
	}

	/**
	 * Comprueba si hay registrado un detector de eventos con este objeto EventDispatcher o con cualquiera de sus ascendientes para el tipo de evento concreto.
	 * @see flash.events.EventDispatcher#willTrigger()
	 */
	public function willTrigger(type :String) :Boolean
	{
		return _dispatcher.willTrigger(type);
	}

	/**
	 * Comprueba si el objeto EventDispatcher tiene detectores registrados para un tipo concreto de evento.
	 * @see flash.events.EventDispatcher#hasEventListener()
	 */
	public function hasEventListener(type :String) :Boolean
	{
		return _dispatcher.hasEventListener(type);
	}
}
}