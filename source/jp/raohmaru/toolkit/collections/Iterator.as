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
 * La interfaz Iterator define la API para las clases que realizan una iteración por una colección de datos.
 * @author raohmaru
 * @source Basado en el trabajo de Joey Lott y Dany Patterson en el libro "ActionScript 3 Patrones de diseño", Ediciones Anaya Multimedia, Madrid 2008
 */
public interface Iterator
{
	/**
	 * Obtiene o define la posición del índice interno que recorre la colección de datos.
	 */
	function get position() : int;
	function set position(value :int) : void;

	/**
	 * Obtiene el tamaño de la colección de datos.
	 */
	function get count() : uint;

	/**
	 * Define si el iterador debe recorrer la colección de datos en bucle. Si se establece a <code>true</code>, vuelve a empezar si alcanza el último elemento
	 * (el índice interno se pone a <code>0</code>), o retorna el último elementos si se ha retrocedido hasta el prinicipio.
	 */
	function get loop() : Boolean;
	function set loop(value :Boolean) : void;

	/**
	 * Obtiene el elemento actual de la coleccíon de datos.
	 * @return El elemento actual de la colección
	 */
	function current() :Object;

	/**
	 * Determina si quedan elementos en la colección de datos a recorrer.
	 * @return Un valor booleano que indica si quedan elementos en la colección de datos
	 */
	function hasNext() :Boolean;

	/**
	 * Obtiene el siguiente elemento y aumenta en uno el índice interno.
	 * Si <code>loop</code> es <code>true</code> y se ha alcanzado el último elemento de la colección, el índice interno se establece a 0.
	 * @return El siguiente elemento de la colección
	 */
	function next() :Object;

	/**
	 * Determina si quedan elementos en la colección de datos a recorrer en sentido ascendente.
	 * @return Un valor booleano que indica si quedan elementos anteriores al actual en la colección de datos
	 */
	function hasPrevious() :Boolean;

	/**
	 * Obtiene el elemento anterior y disminuye en uno el índice interno.
	 * Si <code>loop</code> es <code>true</code> y se ha alcanzado el primer elemento de la colección, el índice interno se establece a la última posición.
	 * @return El siguiente anterior de la colección
	 */
	function previous() :Object;

	/**
	 * Obtiene el primer elemento y restablece a <code>0</code> el índice interno.
	 * @return El primer elemento de la colección.
	 */
	function first() :Object;

	/**
	 * Obtiene el último elemento y establece el índice interno a la última posición.
	 * @return El último elemento de la colección.
	 */
	function last() :Object;

	/**
	 * Obtiene un elemento en la posición indicada. Si está fuera de los límites de la colección, el valor obtenido será <code>null</code>.
	 * Este método no modifica el índice interno.
	 * @see #position
	 * @return El elemento en la posición indicada.
	 */
	function getAt(pos :uint) :Object;

	/**
	 * Restablece el índice interno a <code>0</code>.
	 */
	function reset() :void;
}
}