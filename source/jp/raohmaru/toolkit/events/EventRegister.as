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
import flash.display.*;
import flash.events.*;

/**
 * Registrador de múltiples eventos comunes a objetos interactivos.
 *
 * @author raohmaru
 */
public class EventRegister
{
	/**
	* Añade eventos y comportamientos de botón a un objeto. Por defecto añade los eventos del grupo <code>EventGroup.MOUSE_EVENTS</code>.
	* @see EventDispatcher#addEventListener()
	* @param target El objeto que recibirá los eventos
	* @param callback Función del detector que procesa el evento
	* @param flags (= <code>EventGroup.MOUSE_EVENTS</code>) — Conjunto de los eventos que se registrarán (unidos por el operador binario |)
	* @param buttonMode Boolean = true
	* @param mouseChildren Boolean = false
	* @param useCapture : Boolean = false
	* @param priority : int = 0
	* @param useWeakReference : Boolean = false
	 * @example
	<listing version="3.0">EventRegister.addEventsListener(boton, eventHandler);<br>
EventRegister.addEventsListener(boton, eventHandler, EventRegister.ROLL_EVENTS);</br>
EventRegister.addEventsListener(boton, eventHandler, EventRegister.MOUSE_OVER | EventRegister.CLICK);</listing>
	*/
	public static function addEventsListener(	target : InteractiveObject, callback : Function, flags : uint = 11, // 11 == EventGroup.MOUSE_EVENTS
												buttonMode : Boolean = true, mouseChildren : Boolean = false,
												useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void
	{
		registerEvents(true, target, callback, flags, buttonMode, mouseChildren, useCapture, priority, useWeakReference);
	}

	/**
	* Quita eventos registrados en un objeto y los comportamientos de botón. Por defecto quita los eventos del grupo <code>EventGroup.MOUSE_EVENTS</code>.
	* @see EventDispatcher#removeEventListener()
	* @param target El objeto del que se elminarán los eventos
	* @param callback Función del detector que procesa el evento
	* @param flags (= <code>EventGroup.MOUSE_EVENTS</code>) —  Los tipos de eventos que se quitarán (unidos por el operador binario |)
	* @param buttonMode Boolean = false
	* @param mouseChildren Boolean = true
	* @param useCapture : Boolean = false
	 * @example
	<listing version="3.0">EventRegister.removeEventsListener(boton, eventHandler);<br>
EventRegister.removeEventsListener(boton, eventHandler, EventRegister.ROLL_EVENTS);</br>
EventRegister.removeEventsListener(boton, eventHandler, EventRegister.MOUSE_OVER | EventRegister.CLICK);</listing>
	*/
	public static function removeEventsListener(target : InteractiveObject, callback : Function, flags : uint = 11, // 11 == EventGroup.MOUSE_EVENTS
												buttonMode : Boolean = false, mouseChildren : Boolean = true,
												useCapture : Boolean = false) : void
	{
		registerEvents(false, target, callback, flags, buttonMode, mouseChildren, useCapture);
	}

	/**
	 * Extrae los eventos por su valor binario.
	 * @param flags Conjunto de los eventos que se registrarán (unidos por el operador binario |)
	 */
	private static function extractEventsFromFlags(flags : uint) : Array
	{
		var events : Array = [];

		if((flags & EventType.MOUSE_OVER)	> 0) events.push(MouseEvent.MOUSE_OVER);
		if((flags & EventType.MOUSE_OUT)	> 0) events.push(MouseEvent.MOUSE_OUT);
		if((flags & EventType.MOUSE_DOWN)	> 0) events.push(MouseEvent.MOUSE_DOWN);
		if((flags & EventType.MOUSE_UP)		> 0) events.push(MouseEvent.MOUSE_UP);
		if((flags & EventType.CLICK)		> 0) events.push(MouseEvent.CLICK);
		if((flags & EventType.DOUBLE_CLICK)	> 0) events.push(MouseEvent.DOUBLE_CLICK);
		if((flags & EventType.ROLL_OVER)	> 0) events.push(MouseEvent.ROLL_OVER);
		if((flags & EventType.ROLL_OUT)		> 0) events.push(MouseEvent.ROLL_OUT);
		if((flags & EventType.MOUSE_MOVE)	> 0) events.push(MouseEvent.MOUSE_MOVE);
		if((flags & EventType.MOUSE_WHEEL)	> 0) events.push(MouseEvent.MOUSE_WHEEL);
		if((flags & EventType.FOCUS_IN)		> 0) events.push(FocusEvent.FOCUS_IN);
		if((flags & EventType.FOCUS_OUT)	> 0) events.push(FocusEvent.FOCUS_OUT);
		if((flags & EventType.KEY_DOWN) 	> 0) events.push(KeyboardEvent.KEY_DOWN);
		if((flags & EventType.KEY_UP) 		> 0) events.push(KeyboardEvent.KEY_UP);

		return events;
	}

	/**
	 * Hace el trabajo sucio de registrar/quitar eventos.
	 * @see #addEventsListener()
	 * @see #removeEventsListener()
	 */
	private static function registerEvents(add : Boolean, target : InteractiveObject, callback : Function, flags : uint,
									buttonMode : Boolean, mouseChildren : Boolean,
									useCapture : Boolean, priority : int = 0, useWeakReference : Boolean = false) : void
	{
		if(target is Sprite)					target['buttonMode'] = buttonMode;
		if(target is DisplayObjectContainer)	target['mouseChildren'] = mouseChildren;
		target.mouseEnabled = true;

		var events : Array = extractEventsFromFlags(flags);

		for(var i:int=0; i<events.length; i++)
		{
			if(add)
				target.addEventListener(events[i], callback, useCapture, priority, useWeakReference);
			else
				target.removeEventListener(events[i], callback, useCapture);
		}
	}
}
}