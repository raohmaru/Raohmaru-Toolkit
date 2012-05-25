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
 * La clase EventGroup contiene constantes enumeradas que representan grupos de constantes EventType, agrupadas por el operador binario |, permitiendo de esta
 * manera tener en una única variable diversos valores.
 * @example
<listing version="3.0">var flags : uint = EventGroup.MOUSE_EVENTS;
if((flags &amp; EventType.MOUSE_OVER) &gt; 0) trace("flags contains a MOUSE_OVER");
if((flags &amp; EventType.MOUSE_OUT) &gt; 0) trace("flags contains a MOUSE_OUT");
if((flags &amp; EventType.MOUSE_UP) &gt; 0) trace("flags contains a MOUSE_UP");</listing>
 * @see EventType
 * @see EventRegister
 * @author raohmaru
 */
public class EventGroup
{
	/**
	 * Agrupa a los eventos EventType.MOUSE_OVER, EventType.MOUSE_OUT y EventType.MOUSE_UP.
	 */
	public static const MOUSE_EVENTS		: uint = EventType.MOUSE_OVER 	| EventType.MOUSE_OUT 	| EventType.MOUSE_UP;
	/**
	 * Agrupa a los eventos EventType.MOUSE_OVER y EventType.MOUSE_OUT.
	 */
	public static const MOUSEOVER_EVENTS	: uint = EventType.MOUSE_OVER 	| EventType.MOUSE_OUT;
	/**
	 * Agrupa a los eventos EventType.ROLL_OVER, EventType.ROLL_OUT y EventType.MOUSE_UP.
	 */
	public static const ROLL_EVENTS			: uint = EventType.ROLL_OVER	| EventType.ROLL_OUT	| EventType.MOUSE_UP;
	/**
	 * Agrupa a los eventos EventType.ROLL_OVER y EventType.ROLL_OUT.
	 */
	public static const ROLLOVER_EVENTS		: uint = EventType.ROLL_OVER	| EventType.ROLL_OUT;
	/**
	 * Agrupa a los eventos EventType.MOUSE_OVER, EventType.MOUSE_OUT, EventType.MOUSE_DOWN y EventType.MOUSE_UP.
	 */
	public static const BUTTON_EVENTS		: uint = EventType.MOUSE_OVER	| EventType.MOUSE_OUT 	| EventType.MOUSE_DOWN | EventType.MOUSE_UP;
	/**
	 * Agrupa a los eventos EventType.FOCUS_IN y EventType.FOCUS_OUT.
	 */
	public static const TEXT_EVENTS			: uint = EventType.FOCUS_IN		| EventType.FOCUS_OUT;
	/**
	 * Agrupa a los eventos EventType.MOUSE_DOWN y EventType.MOUSE_UP.
	 */
	public static const DRAG_EVENTS			: uint = EventType.MOUSE_DOWN 	| EventType.MOUSE_UP;
	/**
	 * Agrupa a los eventos EventType.KEY_DOWN y EventType.KEY_UP.
	 */
	public static const KEYBOARD_EVENTS		: uint = EventType.KEY_DOWN 	| EventType.KEY_UP;
}
}