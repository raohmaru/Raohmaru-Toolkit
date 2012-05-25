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
 * La clase ArrayIterator proporciona los métodos para recorrer los elementos de una matriz.
 * @example
<listing version="3.0">
import jp.raohchan.collections.ArrayIterator;import jp.raohchan.collections.Iterator;

var arr :Array = [0,1,2,3,4];
var it:Iterator = new ArrayIterator(arr);

while( it.hasNext() )
{
	trace( "["+it.position+"] -&gt; " + it.next());
}
// Salida:
//			[0] -&gt; 0
//			[1] -&gt; 1
//			[2] -&gt; 2
//			[3] -&gt; 3
//			[4] -&gt; 4</listing>
 * @author raohmaru
 * @source Basado en el trabajo de Joey Lott y Dany Patterson en el libro "ActionScript 3 Patrones de diseño", Ediciones Anaya Multimedia, Madrid 2008
 */
public class ArrayIterator implements Iterator
{
	private var _index :int = 0;
	private var _collection :Array;	private var _loop :Boolean;

	/**
	 * Crea una nueva instancia de ArrayIterator.
	 * @param collection Una matriz que será recorrida
	 */
	public function ArrayIterator(collection :Array)
	{
		_collection = collection;
		_index = 0;
	}

	/**
	 * Obtiene o define la posición del índice interno que recorre la matriz.
	 * Si la nueva posición excede de los límites de la colección, se adecuará a esos límites. Si la propiedad <code>loop</code> es <code>true</code>,
	 * el nuevo índice se establecerá a un valor equivalente al número de veces que sobrepasa la longitud de la colección, cómo si la recorriera en bucle.
	 */
    public function get position() : int
    {
        return _index;
    }
    public function set position(value :int) :void
    {
    	if(value >= _collection.length)
    	{
    		if(!loop)
    			value = _collection.length-1;
    		else
    			while(value >= _collection.length)
    				value -= _collection.length;
    	}
    	else if(value < 0)
    	{
    		if(!loop)
    			value = 0;
    		else
    			while(value < 0)
    				value += _collection.length;
    	}
    	_index = value;
    }

	/**
	 * Obtiene la longitud de la matriz.
	 * @see Array.length
	 */
    public function get count() : uint
    {
        return _collection.length;
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
	 * Obtiene el elemento actual de la matriz.
	 * @return El elemento actual de la matriz
	 * @example
	<listing version="3.0">
	import jp.raohchan.collections.ArrayIterator;

	var arr :Array = ["a", "b", "c", "d"];
	var it:ArrayIterator = new ArrayIterator(arr);

	trace(it.next()); // Devuelve "a"	trace(it.current());  // Devuelve "b", pues el índice interno ha avanzado una posición con next()
	</listing>
	 */
	public function current() :Object
	{
		return _collection[_index];
	}

	/**
	 * @inheritDoc
	 */
	public function first() :Object
	{
		_index = 0;
		return _collection[_index];
	}

	/**
	 * @inheritDoc
	 */
	public function last() :Object
	{
		_index = _collection.length-1;
		return _collection[_index];
	}

	/**
	 * @inheritDoc
	 */
	public function getAt(pos :uint) :Object
	{
		if (pos >= 0 && pos < _collection.length)
			return _collection[pos];
		else
			return null;
	}


	/**
	 * Determina si quedan elementos en la matriz a recorrer.
	 * Si <code>loop</code> se ha establecido a <code>true</code> siempre devuelve verdadero.
	 * @return Un valor booleano que indica si quedan elementos en la matriz
	 */
	public function hasNext() :Boolean
	{
		if(_loop) return true;
		return _index < _collection.length && _collection.length > 0;
	}

	/**
	 * @inheritDoc
	 */
	public function next() :Object
	{
		var o :Object = _collection[_index++];

		if(loop)
			if(_index >= _collection.length)
				reset();

		return o;
	}

	/**
	 * Determina si quedan elementos en la matriz a recorrer en sentido ascendente.
	 * Si <code>loop</code> se ha establecido a <code>true</code> siempre devuelve verdadero.
	 * @return Un valor booleano que indica si quedan elementos anteriores al actual en la matriz.
	 */
	public function hasPrevious() :Boolean
	{
		if(_loop) return true;
		return _index > 0 && _collection.length > 0;
	}

	/**
	 * @inheritDoc
	 */
	public function previous() :Object
	{
		var o :Object = _collection[_index--];

		if(loop)
			if(_index < 0)
				_index = _collection.length-1;

		return o;
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