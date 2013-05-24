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
import flash.display.DisplayObject;
import flash.geom.ColorTransform;

/**
 * La especia que necesita Paprika para funcionar. Formalmente, la clase PaprikaSpice representa un objeto con los parámetros para la interpolación
 * del objeto de destino.
 * @author raohmaru
 * @example
<listing version="3.0">
import jp.raohmaru.toolkit.motion.Paprika;import jp.raohmaru.toolkit.motion.easing.Circ;<br>
var spice :PaprikaSpice = Paprika.add(some_mc, 1, {autoAlpha:0});
    spice.ease = Circ.easeInOut;    spice.onComplete = function() :void
    {
    	// ...
    }</listing>
 */
public class PaprikaSpice
{
	/**
	 * Determina si la duración de la interpolación debe ser en segundos (<code>false</code>) o en fotogramas (<code>true</code>);
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.motion.Paprika;<br>
	Paprika.add(some_mc, 1, {scaleX:0}).useFrames = true;
	var spice :PaprikaSpice = Paprika.add(other_mc, 1, {alpha:1});	    spice.useFrames = true;</listing>
	 */
	public var useFrames :Boolean;
	/**
	 * La ecuación de movimiento a utilizar en la interpolación. Están incluidas en la librería en el paquete jp.raohmaru.toolkit.motion.easing.
	 */
	public var ease :Function;
	/**
	 * Función que será invocada automáticamente al finalizar la animación.
	 */
	public var onComplete :Function;
	/**
	 * Matriz con los parámetros a enviar a la función definida en <code>onComplete</code>.
	 */
	public var onCompleteParams :Array;
	/**
	 * Objeto al que se aplica la función definida en <code>onComplete</code>. Dentro de la función, <code>this</code> representará a este objeto.
	 */
	public var scope :Object;
	/**
	 * Función que se invoca durante la interpolación. El objeto al que se aplica la función es el definido por el parámetro <code>scope</code>.
	 * Los parámetros enviados se definen con la propiedad <code>onCompleteParams</code>.
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.motion.Paprika;<br>
	Paprika.add(some_mc, 1, {color:0xFFCC00}).onUpdate = onUpdate;
	function onUpdate(progress :Number) :void
	{
	    // ...
	}</listing>
	 */
	public var onUpdate :Function;
	/**
	 * Función que se invoca al inicio de la interpolación. El objeto al que se aplica la función es el definido por el parámetro <code>scope</code>.
	 * Los parámetros enviados se definen con la propiedad <code>onCompleteParams</code>.
	 */
	public var onStart :Function;
	/**
	 * Obtiene el progreso de la interpolación, un valor que va del 0 (inicio) al 1 (fin).
	 */
	public function get progress() :Number
	{
		return _q;
	}


	private var _time :Number,
				_duration :Number,				_from :PaprikaData,				_to :PaprikaData,				_started :Boolean,				_color :ColorTransform,
				_q :Number;
	/**
	 * @private
	 */
	internal var	target :Object,
					propList :Object,
					tweening :Boolean,
					prev :PaprikaSpice,					next :PaprikaSpice;

	private static const COLOR_PROPS :Array = [ "redOffset", "redMultiplier", "greenOffset", "greenMultiplier", "blueOffset", "blueMultiplier",
												"alphaMultiplier", "alphaOffset"];


	/**
	 * Crea una nueva instancia de la especia PaprikaSpice. Cada vez que se invoca el método <code>Paprika.add()</code> se genera un nuevo objeto PaprikaSpice.
	 * @see Paprika#add()
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.motion.Paprika;<br>
	var spice :PaprikaSpice = Paprika.add(some_mc, 1, {y:-110});</listing>
	 */
	public function PaprikaSpice()
	{
	}

	/**
	 * @private
	 */
	internal function setup(target :Object, time:Number, props :Object, ease :Function=null, delay :Number=0, onComplete :Function=null,
						  onCompleteParams :Array=null, scope :Object=null) :void
	{
		this.target = target;
		_duration = time;
		if(_duration <= 0) _duration = 0.001;

		propList = props;
		if(!_from) _from = new PaprikaData();
		if(!_to) _to = new PaprikaData();

		this.ease = ease || easeNone;
		if(delay < 0) delay = 0;
		_time = -delay;
		this.onComplete = onComplete;
		this.onCompleteParams = onCompleteParams;
		this.scope = scope || target;
		_started = false;		tweening = true;
		if(_color == null && target is DisplayObject) _color = target.transform.colorTransform;

		// Triquiñuela para que al poner duración 0 la interpolación sea instantánea
		if(_duration == 0.001) update(0.001);
	}

	/**
	 * @private
	 */
	internal function update(dif :Number) :void
	{
		if(!tweening) return;

		if(useFrames)
			_time++;
		else
			_time += dif;

		if(_time >= 0)
		{
			if(!_started)
			{
				var v :String, w :String;
				for(v in propList)
				{
					w = v;
					if(w == "autoAlpha") w = "alpha";
					else if(w == "scale") w = "scaleX";
					if(w == "color" || w == "brightness" || w == "contrast")
					{
						_from.color = target.transform.colorTransform;
						_to.color = (propList.color != null || w == "brightness" || w == "contrast") ? target.transform.colorTransform : new ColorTransform();
						if(propList.color != null)
						{
							_to.color.color = propList.color;
							if("colorTint" in propList)
							{
								var r :Number = propList.colorTint / (1-(_to.color.redMultiplier+_to.color.greenMultiplier+_to.color.blueMultiplier)/3);
								_to.color.redOffset *= r;
								_to.color.greenOffset *= r;
								_to.color.blueOffset *= r;
								_to.color.redMultiplier = _to.color.greenMultiplier = _to.color.blueMultiplier = 1 - propList.colorTint;
							}
						}
						else if(w == "brightness")
						{
							r = propList.brightness * 255;
							if(r < 0) r = 0;
							_to.color.redOffset = _to.color.greenOffset = _to.color.blueOffset = r;
							if(propList.brightness < 0) propList.brightness = -propList.brightness;
							_to.color.redMultiplier = _to.color.greenMultiplier = _to.color.blueMultiplier = 1 - propList.brightness;
						}
						else if(w == "contrast")
						{
							_to.color.redOffset = _to.color.greenOffset = _to.color.blueOffset = 255 * propList.contrast;
							_to.color.redMultiplier = _to.color.greenMultiplier = _to.color.blueMultiplier = 1;
						}
						else
						{
							_to.color.alphaOffset = _from.color.alphaOffset;							_to.color.alphaMultiplier = _from.color.alphaMultiplier;
						}

						if("alpha" in propList || "autoAlpha" in propList)
							_to.color.alphaMultiplier = propList.alpha;

						var i :int = 7, p :String;
						while(i > -1)
						{
							p = COLOR_PROPS[i--];
							_to.color[p] -= _from.color[p];
						}
					}
					else if(w != "colorTint")
					{
						_from[w] = target[w];
						_to[w] = propList[v] - _from[w];
					}
				}

				// Propiedades especiales
				if("autoAlpha" in propList && propList.autoAlpha > 0 && target is DisplayObject)
					target.visible = true;

				if(Boolean(onStart)) onStart.apply(scope, onCompleteParams);

				_started = true;
			}

			if(_time > _duration) _time = _duration;
			_q = ease.call(null, _time, 0, 1, _duration);
			for(v in propList)
			{
				// Establecer las propiedades directamente por su nombre es mucho más rápido que con el operador de acceso [].
				if(v == "x")
					target.x = _from.x + _to.x * _q;

				else if(v == "y")
					target.y = _from.y + _to.y * _q;

				else if(v == "width")
					target.width = _from.width + _to.width * _q;

				else if(v == "height")
					target.height = _from.height + _to.height * _q;

				else if(v == "scaleX")
					target.scaleX = _from.scaleX + _to.scaleX * _q;

				else if(v == "scaleY")
					target.scaleY = _from.scaleY + _to.scaleY * _q;

				else if(v == "scale")
					target.scaleX = target.scaleY = _from.scaleX + _to.scaleX * _q;

				else if(v == "alpha" || v == "autoAlpha")
					target.alpha = _from.alpha + _to.alpha * _q;

				else if(v == "rotation")
					target.rotation = _from.rotation + _to.rotation * _q;

				else if(v == "color" || v == "brightness" || v == "contrast")
				{
					i = 7;
					while(i > -1)
					{
						p = COLOR_PROPS[i--];
						_color[p] = _from.color[p] + _to.color[p] * _q;
					}
					target.transform.colorTransform = _color;
				}
				else if(v == "colorTint") {}

				else
					target[v] = _from[v] + _to[v] * _q;
			}

			if(Boolean(onUpdate)) onUpdate.apply(scope, onCompleteParams ? [useFrames ? _time : progress].concat(onCompleteParams) : [useFrames ? _time : progress]);
		}

		if(_time >= _duration)
		{
			// Propiedades especiales
			if("autoAlpha" in propList && propList.autoAlpha <= 0 && target is DisplayObject)
				target.visible = false;

			tweening = false;
			if(Boolean(onComplete))
			{
				var oc :Function = onComplete;
				// Borra las referencias a funciones por si esta instancia se utiliza de nuevo
				onStart = null;
				onUpdate = null;
				onComplete = null;
				oc.apply(scope, onCompleteParams);
			}
		}
	}

	/**
	 * @private
	 * Elimina todos los valores y referencias de los atributos menos las instancias de PaprikaData, para luego no tener que crearlas de nuevo
	 * cuando se reutilice el objeto.
	 */
	internal function clear() :void
	{
		target = null;
		useFrames = false;
		_duration = 0;
		propList = null;
		ease = null;
		_time = 0;
		onComplete = null;
		onCompleteParams = null;
		scope = null;
		onUpdate = null;		onStart = null;
		_started = false;
		tweening = false;
		prev = null;		next = null;
		_q = 0;
	}

	/**
	 * @private
	 * Elimina completamente todos los valores y referencias de los atributos de la instancia de PaprikaSpice.
	 */
	internal function dispose() :void
	{
		clear();
		_to = null;
		_from = null;
		_color = null;
	}


	/**
	 * La equación por defecto aquí de sopetón, por optimizar.
	 */
	final private function easeNone (t:Number, b:Number, c:Number, d:Number) :Number
	{
		return c*t/d + b;
	}
}
}

import flash.geom.ColorTransform;

/**
 * @private
 * Al utilizar una clase en lugar de un objeto anónimo se incrementa la velocidad. Esta clase contiene las propiedades que
 * más comunmente se animan.
 */
internal dynamic class PaprikaData
{
	public var	x :Number,
				y :Number,
				width :Number,
				height :Number,
				scaleX :Number,
				scaleY :Number,				scale :Number,
				alpha :Number,
				autoAlpha :Number,
				rotation :Number,				color :ColorTransform;
}