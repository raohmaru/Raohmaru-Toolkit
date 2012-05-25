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
import jp.raohmaru.toolkit.events.HashMapEvent;

import flash.events.*;
import flash.utils.*;

/**
 * Se distribuye cuando se realiza un cambio en los elementos del objeto HashMap.
 * @eventType jp.raohchan.events.HashMapEvent.HASHMAP_CHANGE
 */
[Event(name="hashMapChange", type="jp.raohmaru.toolkit.events.HashMapEvent") ]
/**
 * Se distribuye cuando se añade un elemento en el objeto HashMap.
 * @eventType jp.raohchan.events.HashMapEvent.HASHMAP_ADD
 */
[Event(name="hashMapAdd", type="jp.raohmaru.toolkit.events.HashMapEvent") ]
/**
 * Se distribuye cuando se elimina un elemento del objeto HashMap.
 * @eventType jp.raohchan.events.HashMapEvent.HASHMAP_REMOVE
 */
[Event(name="hashMapRemove", type="jp.raohmaru.toolkit.events.HashMapEvent") ]
/**
 * Se distribuye cuando se reemplaza un elemento del objeto HashMap.
 * @eventType jp.raohchan.events.HashMapEvent.HASHMAP_REPLACE
 */
[Event(name="hashMapReplace", type="jp.raohmaru.toolkit.events.HashMapEvent") ]
/**
 * Se distribuye cuando se reestablecen los valores de un objeto HashMap.
 * @eventType jp.raohchan.events.HashMapEvent.HASHMAP_RESET
 */
[Event(name="hashMapReset", type="jp.raohmaru.toolkit.events.HashMapEvent") ]

/**
 * La clase HashMap le permite guardar datos en el par clave / valor y realizar operaciones sobre la misma.
 * Un objeto HashMap distribuye eventos HashMapEvent cuando se realizan modificaciones sobre los datos contenidos.<br><br>
 * Esta clase permite además utilizar el operador de acceso a matriz [] para acceder a los métodos <code>getValue()</code> y <code>setValue()</code>.
 * @see jp.raohchan.events.HashMapEvent
 * @example
<listing version="3.0">
import jp.raohchan.collections.HashMap;
import jp.raohchan.events.HashMapEvent;var map :HashMap = new HashMap();
	map.addEventListener(HashMapEvent.HASHMAP_ADD, mapHandler);

	map.add("nivel", 1);
	map.add("raza", "beffraen");
	map.add("edad", 29);
	map.add("ciudad", "Minas Tirith");	map["nombre"] = "Altaïr";	trace( map["raza"] );  // beffraen
function mapHandler(e :HashMapEvent)
{
	trace(e);
}</listing>
 * @author raohmaru
 * @source Basado en la clase ca.newcommerce.data.HashMap de Eric J. Feminella [http://www.newcommerce.ca/]
 */
public class HashMap extends Proxy implements IEventDispatcher, Iterable
{
	/**
	 * @private
	 */
	protected var	_dispatcher :EventDispatcher,
					_map :Dictionary,
					_weakKeys :Boolean;

	/**
	 * Obtiene el número de elementos del objeto HashMap.
	 */
	public function get size() :uint
	{
		var len :int = 0;
		for(var key:* in _map)
			len++;

		return len;
	}

	/**
	 * Obtiene una matriz con todas las claves del objeto HashMap.
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;
	import jp.raohchan.events.HashMapEvent;

	var map :HashMap = new HashMap();
		map.add("a", 1);
		map.add("b", 2);
		map.add("c", 3);
		map.add("d", 4);	trace( map.keys );  // b,d,a,c
	</listing>
	 */
	public function get keys() : Array
	{
		var keys :Array = [];

		for (var key:* in _map)
			keys.push( key );

		return keys;
	}

	/**
	 * Obtiene una matriz con todas los valores del objeto HashMap.
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;
	import jp.raohchan.events.HashMapEvent;

	var map :HashMap = new HashMap();
		map.add("a", 1);
		map.add("b", 2);
		map.add("c", 3);
		map.add("d", 4);

	trace( map.values );  // 2,4,1,3
	</listing>
	 */
	public function get values() : Array
	{
		var values :Array = [];

		for (var key:* in _map)
			values.push( _map[key] );

		return values;
	}


	/**
	 * Obtiene un nuevo iterador para la colección de datos asociada.
	 * @return Una nueva instancia de Iterator
	 * @see ArrayIterator
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.Collection;
	import jp.raohchan.collections.Iterator;

	var collection :Collection = new Collection();
		collection.addItem(0);
		collection.addItem(1);
		collection.addItem(2);
		collection.addItem(3);
		collection.addItem(4);
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
		return new HashIterator( toObject() );
	}



	/**
	 * Crea un nuevo objeto HashMap, indicando si debe utilizar referencias "débiles" en las claves del objeto.
	 * @param useWeakReferences Indica al objeto Dictionary interno que utilice referencias "débiles" en las claves del objeto.
	 * @see flash.utils.Dictionary
	 */
	public function HashMap(useWeakReferences: Boolean = true) :void
	{
		_map = new Dictionary(useWeakReferences);
		_weakKeys = useWeakReferences;
		_dispatcher = new EventDispatcher(this);
	}

	/**
	 * Añade un nuevo par clave / valor al objeto Dictionary interno.	 * Si ya existe la clave especificada en el objeto HashMap, el valor se reemplazará.	 * @param key La clave a añadir	 * @param value El valor a añadir
	 * @return El nuevo tamaño de la instancia de HashMap
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;
	var map :HashMap = new HashMap();
		map.add( "nivel", 1 );
		map.add( "raza", "beffraen" );
		map.add( "edad", 29 );

	trace(map);	// salida	// {
	// 		nivel: 1
	// 		raza: beffraen
	// 		edad: 29
	// }
	</listing>
	 */
	public function add(key :*, value :* = null) :uint
	{
		var replace :Boolean = containsKey(key),
			old_value :* = (replace) ? _map[key] : undefined;

		_map[key] = value;
		dispatchHashMapEvent( HashMapEvent[replace ? 'HASHMAP_REPLACE' : 'HASHMAP_ADD'], key, (replace ? old_value : value) );

		return size;
	}

	/**
	 * Obtiene los pares clave / valor del objeto Dictionary especificado y los añade a la instancia de HashMap.
	 * Si ya existe la clave especificada en el objeto HashMap, el valor se reemplazará.
	 * @param dict Un objeto Dictionary del que obtener las claves y valores
	 * @return El nuevo tamaño de la instancia de HashMap
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;	import flash.utils.Dictionary;

	var dict :Dictionary = new Dictionary(true);
		dict["altura"] = 1.85;
		dict["ojos"] = "verdes";

	var map :HashMap = new HashMap();
		map.addDictionary( dict );

	trace(map);
	// salida
	// {
	// 		altura: 1.85
	// 		ojos: "verdes"
	// }
	</listing>
	 */
	public function addDictionary(dict :Dictionary) :uint
	{
		for(var key :String in dict)
			add( key, dict[key] );

		return size;
	}

	/**
	 * Añade un objeto con al menos una propiedad <code>key</code> o <code>value</code>.
	 * Si sólo se define una propiedad, esta será utilizada para definir tanto la clave como el valor.
	 * Si ya existe la clave especificada en el objeto HashMap, el valor se reemplazará.
	 * @param entry Un objeto con valores a añadir en el objeto HashMap.
	 * @return El nuevo tamaño de la instancia de HashMap
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;

	var map :HashMap = new HashMap();
		map.addEntry( {key:"a", value:1} );
		map.addEntry( {key:"b"} );
		map.addEntry( {value:3} );

	trace(map);
	// salida
	// {
	// 		b: b
	// 		3: 3
	// 		a: 1
	// }
	</listing>
	 */
	public function addEntry(entry :Object) :uint
	{
		if(entry.hasOwnProperty("key") || entry.hasOwnProperty("value"))
		{
			add( (entry.key != undefined ? entry.key : entry.value), (entry.value != undefined ? entry.value : entry.key) );
		}
		else
		{
			throw new ArgumentError("La entrada debe tener al menos una propiedad 'key' o 'value'");
		}

		return size;
	}

	/**
	* Obtiene la clave asociada al valor especificado.
	* Si existen múltiples valores con el mismo valor, se retornará la primera clave localizada.
	* Si no se encuentra el valor, la clave devuelta es <code>null</code>.
	* @param value El valor del que obtener la clave asociado
	* @return La clave asociada al valor
	*/
	public function getKey(value :*) :*
	{
		var id :String = null;

		for(var key:* in _map)
		{
			if(_map[key] == value)
			{
				id = key;
				break;
			}
		}

		return id;
	}

	/**
	* Obtiene el valor asociado a la clave especificada.
	* Si existen múltiples claves con el mismo valor, se retornará el primer valor localizado.
	* Si no se encuentra la clave, el valor devuelto es <code>null</code>.
	* @param key La clave de la que obtener el valor asociado
	* @return El valor asociado a la clave
	*/
	public function getValue(key :*) :*
	{
		return _map[key];
	}

	/**
	 * Establece un valor asociado a la clave especificada.
	 * Si no existe en la clase Dictionary interna la clave especificada, el valor se añadirá; en caso contrario, se reemplazará.
	 * @param key La clave a añadir
	 * @param value El valor a añadir
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;
	import jp.raohchan.events.HashMapEvent;

	var map :HashMap = new HashMap();
		map.add( "marca", "audi" );
		map.add( "color", 0xCCCCCC );		map.setValue( "puertas", 4 );  // Emite un evento HashMapEvent.HASHMAP_ADD		map.setValue( "color", 0xFF98CA );  // Emite un evento HashMapEvent.HASHMAP_REPLACE
	</listing>
	 */
	public function setValue(key :*, value :* = null) :void
	{
		add(key, value);
	}

	/**
	 * Elimina el par clave / valor asociado a la clave especificada.
	 * @param key La clave a eliminar junto al valor asociado
	 * @return Un valor booleano que representa el resultado de la operación
	 */
	public function removeKey(key :*) :Boolean
	{
		var result :Boolean = false;

		if(containsKey(key))
		{
			var deleted_value :* = _map[key];
			delete _map[key];
			dispatchHashMapEvent(HashMapEvent.HASHMAP_REMOVE, key, deleted_value);
			result = true;
		}

		return result;
	}

	/**
	 * Elimina el par clave / valor asociado al valor especificado.
	 * @param key El valor a eliminar junto a la clave asociada
	 * @return Un valor booleano que representa el resultado de la operación
	 */
	public function removeValue(value :*) :Boolean
	{
		return removeKey( getKey(value) );
	}

	/**
	 * Reestablece todos los valores asignados a las claves en el objeto HashMap a <code>undefined</code>.
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;
	import jp.raohchan.events.HashMapEvent;

	var map :HashMap = new HashMap();
		map.add( "red", 0xFF0000 );
		map.add( "silver", 0xCCCCCC );		map.add( "white", 0xFFFFFF );

	map.reset();	trace( map );	// salida
	// {
	// 	red: undefined
	// 	silver: undefined
	// 	white: undefined
	// }
	</listing>
	 */
	public function reset() : void
	{
		for(var key :* in _map)
			_map[key] = undefined;

		dispatchHashMapEvent(HashMapEvent.HASHMAP_RESET, undefined, undefined);
	}

	/**
	 * Elimina todas las claves y sus valores asociados.
	 * @return Un nuevo objeto HashMap con los elementos eliminados
	 */
	public function clear() :HashMap
	{
		var map_clone :HashMap = clone(),
			keys_clone :Array = keys;
		_map = new Dictionary(_weakKeys);

		for(var i:int=0; i<keys_clone.length; i++)
			dispatchHashMapEvent(HashMapEvent.HASHMAP_REMOVE, keys_clone[i], map_clone[keys_clone[i]]);

		return map_clone;
	}

	/**
	 * Comprueba si el objeto HashMap contiene la clave especificada.
	 * @return Si el objeto HashMap contiene la clave especificada, el valor es <code>true</code>. En caso contrario, <code>false</code>
	 */
	public function containsKey(key :*) :Boolean
	{
		return _map.hasOwnProperty( key );
	}

	/**
	 * Comprueba si el objeto HashMap contiene el valor especificado.
	 * @return Si el objeto HashMap contiene el valor especificado, el valor devuelto es <code>true</code>. En caso contrario, <code>false</code>
	 */
	public function containsValue(value :*) :Boolean
	{
		return ( getKey(value) != null );
	}

	/**
	 * Devuelve una copia del objeto HashMap actual.
	 * @return Una copia del objeto HashMap actual
	 */
	public function clone() :HashMap
	{
		var map_clone :HashMap = new HashMap(_weakKeys);

		for(var key :* in _map)
			map_clone.add( key, _map[key] );

		return map_clone;
	}

	/**
	 * Devuelve una representación de cadena del objeto HashMap.
	 * @return Una cadena con las claves y los valores del objeto HashMap
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;

	var map :HashMap = new HashMap();
		map.add(0, "cero");		map.add(1, "uno");
		map.add(2, "dos");		map.add(3, "tres");
	trace( map );
	// salida	// {
	// 	0: cero
	// 	1: uno
	// 	2: dos
	// 	3: tres
	// }
	</listing>
	 */
	public function toString() : String
	{
		var output :String = "{";
		for(var key :* in _map)
			output += "\n\t" + key + ": " + _map[key];

		return output + "\n}";
	}

	/**
	 * Devuelve una matriz con todos los pares clave / valor.
	 * @return Una matriz que contiene los elementos del objeto HashMap actual
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;

	var map :HashMap = new HashMap();
		map.add("cero", 0);
		map.add("uno", 1);
		map.add("dos", 2);
		map.add("tres", 3);
	var arr :Array = map.toArray();
	trace(arr);  // uno,1,dos,2,tres,3,cero,0	trace(arr[1]);  // dos,2	trace(arr.length);  // 4
	</listing>
	 */
	public function toArray() : Array
	{
		var arr :Array = [];
		for(var key :* in _map)
			arr.push( [key, _map[key]] );

		return arr;
	}

	/**
	 * Devuelve un objeto cuyas propiedades son las claves y los valores asociados del objeto HashMap actual.
	 * @return Un objeto con los pares clave / valor del objeto HashMap actual.
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;

	var map :HashMap = new HashMap();
		map.add("name", "user0");
		map.add("type", "default");
		map.add("data", [128, 256]);
	var obj :Object = map.toObject();
	trace( obj.name );  // user0
	trace( obj["data"] );  // 128,256
	</listing>
	 */
	public function toObject() : Object
	{
		var obj :Object = {};
		for(var key :* in _map)
			obj[key] = _map[key];

		return obj;
	}

	/**
	 * Distrubuye los eventos HashMapEvent asociados.
	 * @see jp.raohchan.events.HashMapEvent
	 */
	private function dispatchHashMapEvent(type :String, key :*, value :*) :void
	{
		_dispatcher.dispatchEvent(new HashMapEvent(type, key, value));		_dispatcher.dispatchEvent(new HashMapEvent(HashMapEvent.HASHMAP_CHANGE, key, value));
	}

	/**
	 * Método proxy. Permite obtener un elemento de la colección con el operador de acceso a matriz []. Internamente invoca al método <code>getValue()</code>.
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;

	var map :HashMap = new HashMap();
		map.add("alpha", 0.1);
		map.add("beta", 2);

	trace( map["alpha"] );  // 0.1
	trace( map["beta"] );  // 2
	</listing>
	 * @private
	 */
    override flash_proxy function getProperty(key :*) :*
    {
        return getValue(key);
    }

	/**
	 * Método proxy. Permite cambiar el valor de un elemento de la colección con el operador de acceso a matriz []. Internamente invoca al método
	 * <code>setValue()</code>.
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.HashMap;

	var map :HashMap = new HashMap();
		map.add("alpha", 0.1);
		map.add("beta", 2);

	trace( map.getKey(2) );  // beta
	trace( map.getValue("alpha") );  // 0.1
	</listing>
	 * @private
	 */
    override flash_proxy function setProperty(key :*, value :*) :void
    {
        setValue(key, value);
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