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
 * El iterador NullIterator permite construir clases que sean iterables pero que realmente no tienen ninguna colección.
 * Todas las operaciones retornan valores <code>null</code>, <code>false</code> o <code>0</code>.
 * @author raohmaru
 * @source Basado en el trabajo de Joey Lott y Dany Patterson en el libro "ActionScript 3 Patrones de diseño", Ediciones Anaya Multimedia, Madrid 2008
 */
public class NullIterator implements Iterator
{
	/**
	 *  Crea una nueva instancia de la clase NullIterator.
	 */
	public function NullIterator()
	{

	}

	/**
	 * Obtiene o define la posición del índice interno que recorre la colección de datos. El valor devuelto siempre es <code>0</code>.
	 */
    public function get position() : int
    {
        return 0;
    }
    public function set position(value :int) :void
    {

    }

   	/**
	 * Obtiene la longitud de la matriz. Siempre devuelve <code>0</code>
	 */
    public function get count() : uint
    {
        return 0;
    }

   	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>false</code>
	 */
    public function get loop() : Boolean
    {
        return false;
    }
    public function set loop(value :Boolean) :void
    {

    }


	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function current() :Object
	{
		return null;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function first() :Object
	{
		return null;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function last() :Object
	{
		return null;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function getAt(pos :uint) :Object
	{
		return null;
	}


	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>false</code>
	 */
	public function hasNext() :Boolean
	{
		return false;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function next() :Object
	{
		return null;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function hasPrevious() :Boolean
	{
		return false;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function previous() :Object
	{
		return null;
	}

	/**
	 * @inheritDoc
	 * @return Siempre devuelve <code>null</code>
	 */
	public function reset() :void
	{
	}
}
}