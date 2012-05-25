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
 * La clase EventType es una enumeración de valores constantes para la clase EventRegister, que corresponden a los eventos más comunes de Flash.
 * Contienen un valor numérico uint que permite que sea combinado con otros valores de EventType en operaciones binarias, para luego extraer su valor
 * por separado.
 * @example
<listing version="3.0">
var flags : uint = EventType.MOUSE_OVER | EventType.CLICK;<br>
if((flags &amp; EventType.MOUSE_OVER) &gt; 0) trace("flags contains a MOUSE_OVER");
if((flags &amp; EventType.CLICK) &gt; 0) trace("flags contains a CLICK");
</listing>
 * @see EventRegister
 * @author raohmaru
 */
public class EventType
{
	/**
	 * Corresponde al evento flash.events.MouseEvent.MOUSE_OVER.
	 */
	public static const	MOUSE_OVER		: uint = 1;
	/**
	 * Corresponde al evento flash.events.MouseEvent.MOUSE_OUT.
	 */
	public static const	MOUSE_OUT 		: uint = 2;
	/**
	 * Corresponde al evento flash.events.MouseEvent.MOUSE_DOWN.
	 */
	public static const	MOUSE_DOWN		: uint = 4;
	/**
	 * Corresponde al evento flash.events.MouseEvent.MOUSE_UP.
	 */
	public static const	MOUSE_UP		: uint = 8;
	/**
	 * Corresponde al evento flash.events.MouseEvent.CLICK.
	 */
	public static const	CLICK			: uint = 16;
	/**
	 * Corresponde al evento flash.events.MouseEvent.DOUBLE_CLICK.
	 */
	public static const	DOUBLE_CLICK	: uint = 32;
	/**
	 * Corresponde al evento flash.events.MouseEvent.ROLL_OVER.
	 */
	public static const	ROLL_OVER		: uint = 64;
	/**
	 * Corresponde al evento flash.events.MouseEvent.ROLL_OUT.
	 */
	public static const	ROLL_OUT		: uint = 128;
	/**
	 * Corresponde al evento flash.events.MouseEvent.MOUSE_MOVE.
	 */
	public static const	MOUSE_MOVE		: uint = 256;
	/**
	 * Corresponde al evento flash.events.MouseEvent.MOUSE_WHEEL.
	 */
	public static const	MOUSE_WHEEL		: uint = 512;
	/**
	 * Corresponde al evento flash.events.FocusEvent.FOCUS_IN.
	 */
	public static const	FOCUS_IN		: uint = 1024;
	/**
	 * Corresponde al evento flash.events.FocusEvent.FOCUS_OUT.
	 */
	public static const	FOCUS_OUT		: uint = 2048;
	/**
	 * Corresponde al evento flash.events.KeyboardEvent.KEY_DOWN.
	 */
	public static const	KEY_DOWN		: uint = 4096;
	/**
	 * Corresponde al evento flash.events.KeyboardEvent.KEY_UP.
	 */
	public static const	KEY_UP			: uint = 8192;
}
}