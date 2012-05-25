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

package jp.raohmaru.toolkit.motion
{
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.Dictionary;
import flash.utils.getTimer;

/**
 * Otra librería de movimiento más, pero esta a mi gusto. ¡Paprika!<br>
 * El propósito es crear una clase básica ligera y muy rápida, con únicamente los métodos más utilizados en el desarrollo web. Para animaciones
 * más complejas o con efectos ya están las otras.<br>
 * Utiliza una reserva de objetos (object pool) de saco roto para optimizar el rendimiento.<br>
 * Esta inspirada (y a veces basada) en las tres grandes librerías de movimiento en AS3: caurina.Tweener, TweenMax y Tweensy.
 * @example
<listing version="3.0">
import jp.raohchan.motion.Paprika;
import jp.raohchan.motion.easing.Quad;<br>
Paprika.add(some_mc, .5, {x:100, y:200, rotation:15}, Quad.easeInOut, 0, onComplete, [some_mc]);

function onComplete(some_mc :DisplayObject) :void
{
	// ...
}</listing>
 * @author raohmaru
 * TODO Eventos como en eaze (http://code.google.com/p/eaze-tween/)
 */
public class Paprika extends EventDispatcher
{
	private static var	_engine :Sprite,
						_tasks :Dictionary,
						_pot :PaprikaPot,
						_time :int,
						_spices :int,
						_inited :Boolean;

	/**
	 * Añade una nueva especia a la lista de objetos de la animación. Si el objeto ya existe, se sustituirá en el caso que se sobreescriba una propiedad
	 * de dicho objeto que esté siendo animada, a menos que la animación empieza con retraso (<code>delay</code>);
	 * @param target Un objeto cuyas propiedades serán interpoladas.
	 * @param time La duración de la animación, en segundos o fotogramas. Para poder utilizar un valor en fotogramas, el atributo
	 * <code>PaprikaSpice.useFrames</code> se ha de establecer en <code>true</code>.
	 * @param props Un objeto con los valores finales de las propiedades del objeto que serán interpoladas. Acepta cualquier tipo de propiedad que tenga
	 * el objeto de destino. Existen también estas propiedas especiales:
	 * <ul><li><b>autoAlpha</b>: Modifica las propiedades <code>alpha</code> y <code>visible</code> del objeto, mostrándolo si <code>visible=false</code>
	 * y el valor de <code>autoAlpha</code> es superior a <code>0</code>, o ocultándolo si el valor es <code>0</code> al finalizar la animación.</li>
	 * <li><b>scale</b>: Modifica las propiedades <code>scaleX</code> y <code>scaleY</code> a la vez.</li>	 * <li><b>color</b>: Cambia el color del objeto, modificando su propiedad <code>transform.colorTransform</code>.</li>	 * <li><b>colorTint</b>: Porcentaje que se aplica al color de la tinta, expresado como valor decimal entre 0 y 1.</li>	 * <li><b>brightness</b>: Porcentaje de brillo, expresado como número decimal entre -1 y 1. Los valores positivos iluminan el objeto y un valor de 1
	 * convierte el objeto en un objeto totalmente blanco. Los valores negativos oscurecen el objeto y un valor de -1 convierte el objeto en un objeto
	 * totalmente negro.</li>	 * <li><b>contrast</b>: Cantidad de contraste a aplicar. Los valores van desde -1 (sin contrase), 0 (normal) a 1 (muy contrastado).</li></ul>
	 * @param ease La ecuación de movimiento a utilizar en la interpolación. Están incluidas en la librería en el paquete jp.raohchan.motion.easing.
	 * @param delay Cantidad de retraso en segundos o fotogramas hasta que se inicia la animación. Si es superior a 0 no se sobrescribirá la interpolación.
	 * @param onComplete Método que será invocado al finalizar la animación.	 * @param onCompleteParams Matriz con los parámetros a enviar a la función definida en <code>onComplete</code>.
	 * @param scope Objeto al que se aplica la función definida en <code>onComplete</code>. Si no se especifica, se usará <code>target</code>.
	 * @return Una instancia de la clase PaprikaSpice con los parámetros de la interpolación.
	 * @example
<listing version="3.0">import jp.raohchan.motion.Paprika;
import jp.raohchan.motion.easing.Quad;<br>
Paprika.add(some_mc, .5, {x:100, y:200, scale:1.2}, Quad.easeInOut);var spice :PaprikaSpice = Paprika.add(some_mc, .5, {x:100, y:200, color:0xFFCC00}, Quad.easeIn);</listing>
	 */
	public static function add(target :Object, time:Number, props :Object, ease :Function=null, delay :Number=0, onComplete :Function=null,
							   onCompleteParams :Array=null, scope :Object=null) :PaprikaSpice
	{
		if (!Boolean(target)) return null;
		if(!_inited)
		{
			if(!_engine) _engine = new Sprite();
			_tasks = new Dictionary(true);
			if(!_pot) _pot = new PaprikaPot();

			_engine.addEventListener(Event.ENTER_FRAME, update);

			_inited = true;
		}

		// Comprueba que exista el objeto en la lista; en caso afirmativo, si una nueva propiedad ya está siendo interpolada para este objeto,
		// se reemplazan todas sus propiedades por las nuevas a menos que delay > 0. En caso negativo, se crea un nuevo PaprikaSpice para el mismo objeto.
		if(_tasks[target] != null)
		{
			var obj :PaprikaSpice,
				curr :PaprikaSpice = _tasks[target],
				prop_list :Object,
				v :String;
			loop: while(true)
			{
				prop_list = curr.propList;
				for(v in props)
					// Si se interpola una misma propiedad, el objeto se sobrescribe a menos que la animación empiece con retraso
					if(v in prop_list && delay == 0)
					{
						obj = curr;
						break loop;
					}

				if(curr.next != null)
					curr = curr.next;
				else
					break;
			}

			// Si se interpolan propiedades nuevas o hay retraso, se añade un nuevo hermano
			if(obj == null)
			{
				obj = curr.next = _pot.retrieve();
				obj.prev = curr;
				_spices++;
			}
		}
		// Objeto nuevo
		else
		{
			obj = _tasks[target] = _pot.retrieve();
			_spices++;
		}

		obj.setup(target, time, props , ease, delay, onComplete, onCompleteParams, scope);

		if(_spices == 1) _time = getTimer();

		return obj;
	}

	/**
	 * Elimina y detiene la animación de una una especia de la lista de objetos interna.
	 * La instancia liberada es almacenada en el bote para su posterior reutilización.
	 * @param target Objeto con animaciones a remover.
	 */
	public static function remove(target :Object) :void
	{
		if(!_tasks) return;

		var obj :PaprikaSpice = _tasks[target];
		if(obj != null)
		{
			var next :PaprikaSpice;
			while(obj != null)
			{
				next = obj.next;
				_pot.drop(obj);
				obj.dispose();
				_spices--;
				obj = next;
			}
			delete _tasks[target];
		}
	}

	/**
	 * Detiene todas las interpolaciones que se están ejecutando, eliminándolas de la lista de ejecución interna.
	 * También vacía la reserva de objetos, liberando la memoria.
	 */
	public static function stop() :void
	{
		if(!_inited) return;

		var key :Object;
		for(key in _tasks)
			remove(PaprikaSpice(_tasks[key]).target);

		_pot.empty();
		_tasks = null;
		_engine.removeEventListener(Event.ENTER_FRAME, update);

		_inited = false;
	}

	/**
	 * Añade una especia con temporizador. No realiza ninguna interpolación sobre el objeto, únicamente invoca a la función <code>onComplete</code> cuando
	 * transcurre el tiempo especificado.
	 * @param target Un objeto sobre el que aplicar el temporizador.
	 * @param time La duración del temporizador, en segundos o fotogramas. Para poder utilizar un valor en fotogramas, el atributo
	 * <code>PaprikaSpice.useFrames</code> se ha de establecer en <code>true</code>.
	 * @param delay Cantidad de retraso en segundos o fotogramas hasta que se inicie el temporizador.
	 * @param onComplete Método que será invocado al finalizar el temporizador.
	 * @param onCompleteParams Matriz con los parámetros a enviar a la función definida en <code>onComplete</code>.
	 * @param scope Objeto al que se aplica la función definida en <code>onComplete</code>. Si no se especifica, se usará <code>target</code>.
	 * @example
<listing version="3.0">import jp.raohchan.motion.Paprika;<br>
Paprika.wait(this, 1, 0, function() :void
{
    //...
});</listing>
	 */
	public static function wait(target :Object, time:Number, delay :Number=0, onComplete :Function=null, onCompleteParams :Array=null, scope :Object=null) :PaprikaSpice
	{
		return add(target, time, {} , null, delay, onComplete, onCompleteParams, scope);
	}

	/**
	 * @private
	 * Manejador del evento <code>Event.ENTER_FRAME</code> del motor interno de la clase.
	 */
	private static function update(e :Event) :void
	{
		if(_spices == 0) return;

		var key :Object,
			obj :PaprikaSpice,
			next :PaprikaSpice,			prev :PaprikaSpice,
			dif :Number = getTimer() - _time,
			// Mejora la velocidad al recorrer una referencia a un objeto estático, que no al mismo objeto estático.
			tasks :Dictionary = _tasks;

		_time += dif;
		dif *= 0.001;

		for(key in tasks)
		{
			obj = tasks[key];
			// Con el nuevo sistema de hermanos (PaprikaSpice.prev & PaprikaSpice.next) cada objeto guarda la referencia al elemento
			// anterior y siguiente, como en una cadena.
			while(obj != null)
			{
				obj.update(dif);
				next = obj.next;
				// Comprueba que la animación haya acabado. tweening es false al terminar y si la instancia no ha sido reutilizada de nuevo.
				if(!obj.tweening)
				{
					prev = obj.prev;

					// Si no tiene hermanos, se borra de la lista. Si es un eslabón, une a sus hermanos entre si para no romper la cadena
					if(prev == null && next == null)
						delete _tasks[obj.target];
					else
					{
						if(prev != null) prev.next = next;						if(next != null) next.prev = prev;

						_tasks[obj.target] = (prev != null) ? prev : next;
					}

					_pot.drop(obj);
					obj.clear();
					_spices--;
				}
				obj = next;
			}
		}
	}

	/**
	 * Comprueba si el objeto especificado tiene una animación creada con Paprika. Retorna <code>true</code> en caso afirmativo.
	 * @param target Un objeto que se comparará con la lista interna de objetos animados.
	 * @return Un valor booleano.
	 */
	public static function isSpice(target :Object) :Boolean
	{
		return _tasks[target] != null;
	}

	/**
	 * Obtiene la instancia de PaprikaSpice asociada al objeto especificado.
	 * @param target Un objeto del que obtener la especia.
	 * @return La instancia asociada de PaprikaSpice. Si no tiene, retorna <code>null</code>.
	 */
	public static function getSpice(target :Object) :PaprikaSpice
	{
		return (isSpice(target)) ? _tasks[target] : null;
	}
}
}