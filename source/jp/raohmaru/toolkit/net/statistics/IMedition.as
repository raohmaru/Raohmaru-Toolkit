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

package jp.raohmaru.toolkit.net.statistics
{

/**
 * La interfaz de IMedition proporciona los métodos y propiedades que requiere una clase de medición.
 * @author raohmaru
 */
public interface IMedition
{
	/**
	 * La URL que se va a solicitar.
	 */
	function get url() : String;
	function set url(value : String) : void;

	/**
	 * Define o obtiene el estado del objeto de medición. Si es <code>false</code>, se desactivarán las llamadas a <code>send()</code>
	 */
	function get enabled() : Boolean;
	function set enabled(value : Boolean) : void;

	/**
	 * Define si debe mostrarse el estado cada petición realizada con <code>send()</code> en la consola de salida.
	 */
	function get log() : Boolean;
	function set log(value : Boolean) : void;

	/**
	 * Define el método de envío de peticiones al servidor.
	 * @param data Datos a enviar junto a la petición.
	 */
	function send(data : Object) : void;
}
}