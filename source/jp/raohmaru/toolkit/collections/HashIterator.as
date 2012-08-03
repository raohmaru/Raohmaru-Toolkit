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

/**
 * La clase HashIterator proporciona los métodos para recorrer los elementos de un objeto.
 * @example
<listing version="3.0">
import jp.raohmaru.toolkit.collections.HashIterator;import jp.raohmaru.toolkit.collections.Iterator;

var collect :Object = { "a": 1, "b":2, "c":3, "d":4, "e":5};
var it:Iterator = new HashIterator(collect);

while( it.hasNext() )
{
	trace( "["+it.position+"] &gt; " + it.next());
}
// Salida:
//			[0] &gt; b,2
//			[1] &gt; c,3
//			[2] &gt; d,4
//			[3] &gt; e,5
//			[4] &gt; a,1</listing>
 * @author raohmaru
 */
public class HashIterator implements Iterator
{
	private var _index :int = 0,
				_collection :Object,
				_len :uint,
				_loop :Boolean;

	/**
	 * Crea una nueva instancia de HashIterator.
	 * @param collection Un objeto que será recorrido
	 */
	public function HashIterator(collection :Object)
	{
		_collection = collection;
		_index = 0;

		for(var key:* in _collection)
			_len++;
	}

	/**
	 * Obtiene o define la posición del índice interno que recorre el objeto.
	 * Si la nueva posición excede de los límites de la colección, se adecuará a esos límites. Si la propiedad <code>loop</code> es <code>true</code>,
	 * el nuevo índice se establecerá a un valor equivalente al número de veces que sobrepasa la longitud de la colección, cómo si la recorriera en bucle.
	 */
    public function get position() : int
    {
        return _index;
    }
    public function set position(value :int) :void
    {
    	if(value >= _len)
    	{
    		if(!loop)
    			value = _len-1;
    		else
    			while(value >= _len)
    				value -= _len;
    	}
    	else if(value < 0)
    	{
    		if(!loop)
    			value = 0;
    		else
    			while(value < 0)
    				value += _len;
    	}
    	_index = value;
    }

	/**
	 * @inheritDoc
	 */
    public function get count() : uint
    {
        return _len;
    }

   	/**
	 * @inheritDoc
	 * @default false
	 */
    public function get loop() : Boolean
    {
        return _loop;
    }
    public function set loop(value :Boolean) :void
    {
    	_loop = value;
    }

	/**
	 * Obtiene el elemento actual del objeto en una matriz con el par clave / valor.
	 * @return Una matriz que contiene la clave y el valor del elemento actual del objeto
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.collections.HashIterator;
	var collect :Object = { "a": 1, "b":2, "c":3, "d":4, "e":5 };
	var it:Iterator = new HashIterator(collect);

	trace(it.next()); // Devuelve [a,1]
	trace(it.current());  // Devuelve [b,2]", pues el índice interno ha avanzado una posición con next()
	</listing>
	 */
	public function current() :Object
	{
		var obj :Object = next();
		_index--;
		return obj;
	}

	/**
	 * @inheritDoc
	 */
	public function first() :Object
	{
		_index = 0;
		return getAt(_index);
	}

	/**
	 * @inheritDoc
	 */
	public function last() :Object
	{
		_index = _len-1;
		return getAt(_index);
	}

	/**
	 * @inheritDoc
	 */
	public function getAt(pos :uint) :Object
	{
		var temp_index :uint,
			value :Array;

		for(var key:* in _collection)
		{
			if(temp_index++ == pos) value = [key, _collection[key] ];
		}

		return value;
	}


	/**
	 * Determina si quedan elementos en el objeto a recorrer.
	 * Si <code>loop</code> se ha establecido a <code>true</code> siempre devuelve verdadero.
	 * @return Un valor booleano que indica si quedan elementos en el objeto
	 */
	public function hasNext() :Boolean
	{
		if(_loop) return true;
		return _index < _len && _len > 0;
	}

	/**
	 * Obtiene el siguiente elemento en una matriz con el par clave / valor y aumenta en uno el índice interno.
	 * @return Una matriz que contiene la clave y el valor del siguiente elemento del objeto
	 */
	public function next() :Object
	{
		var value :Array = getAt(_index) as Array;
		_index++;

		if(loop)
			if(_index >= _len)
				reset();

		return value;
	}

	/**
	 * Determina si quedan elementos en el objeto a recorrer en sentido ascendente.
	 * Si <code>loop</code> se ha establecido a <code>true</code> siempre devuelve verdadero.
	 * @return Un valor booleano que indica si quedan elementos anteriores al actual  en el objeto
	 */
	public function hasPrevious() :Boolean
	{
		if(_loop) return true;
		return _index > 0 && _len > 0;
	}

	/**
	 * Obtiene el elemento anterior en una matriz con el par clave / valor y disminuye en uno el índice interno.
	 * @return Una matriz que contiene la clave y el valor del elemento anterior del objeto
	 */
	public function previous() :Object
	{
		var value :Array = getAt(_index) as Array;
		_index--;

		if(loop)
			if(_index < 0)
				_index = _len-1;

		return value;
	}

	/**
	 * @inheritDoc
	 */
	public function reset() :void
	{
		_index = 0;
	}
}
}