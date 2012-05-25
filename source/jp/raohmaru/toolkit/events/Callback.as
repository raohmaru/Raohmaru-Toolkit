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

/**
 * Utilidad para crear referencias de funciones añadiendo parámetros adicionales (úsese con <code>addEventListener</code>)
 *
 * @author raohmaru. Traducción y adición del método <code>simple</code>
 * @author (c) 2007 Ian Thomas. Freely usable in whatever way you like, as long as it's attributed
 */
public class Callback
{
	/**
	* Crea una referencia a una función para una acción de <i>callback</i>.<br>
	* Añade parámetros adicionales definidos por el usuario a los parámetros que la función devuelve normalmente.
	* @param handler Función de referencia
	* @param args Parámetros adicionales
	* @example
	<listing version="3.0">
	bot1.addEventListener(MouseEvent.MOUSE_UP, Callback.create(link, "http://raohmaru.com"));<br>
	function link(e : MouseEvent, url : String)
	{
		// ...
	}</listing>
	*/
	public static function create(handler:Function, ...args):Function
	{
		return function() : *
		{
			return handler.apply( this, arguments.concat(args) );
		};
	}

	/**
	* Crea una referencia a una función para una acción de <i>callback</i>.<br>
	* Sustituye los parámetros que la función devuelve normalmente por los parámetros definidos por el usuario.
	* @param handler Función de referencia.
	* @param args Parámetros adicionales.
	* @example
	<listing version="3.0">
	bot2.addEventListener(MouseEvent.MOUSE_UP, Callback.simple(update, 2, true));<br>
	function update(id : int, connect : Boolean)
	{
		// ...
	}</listing>
	* @author raohmaru
	*/
	public static function simple(handler:Function, ...args):Function
	{
		return function() : *
		{
			return handler.apply( this, args );
		};
	}
}
}