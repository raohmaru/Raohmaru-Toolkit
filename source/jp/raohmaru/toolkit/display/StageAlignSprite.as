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

package jp.raohmaru.toolkit.display
{
import jp.raohmaru.toolkit.motion.Paprika;
import jp.raohmaru.toolkit.motion.easing.Linear;
import flash.display.*;
import flash.events.*;

/**
 * Clase "envoltorio" o "decorador", que dota de la funcionalidad de alineación con el escenario a un objeto de visualización.
 * @author raohmaru
 * @example
<listing version="3.0">
import flash.display.StageAlign;import jp.raohmaru.toolkit.display.StageAlignSprite;<br>
StageAlignSprite.stageWidth = 990;
StageAlignSprite.stageHeight = 660;<br>
new StageAlignSprite(some_mc, StageAlign.BOTTOM);var sagui :StageAlignSprite = new StageAlignSprite(other_mc);
    sagui.align = StageAlign.TOP;    sagui.pixelSnap = true;
</listing>
 */
public class StageAlignSprite extends EventDispatcher
{
	private var _movie :DisplayObject,
				_align :String,				_pixel_snap :Boolean,
				_stage :Stage,
				_x :Number,
				_y :Number,
				_browser_fix :Boolean,
				_tween :Boolean,
				_tween_ease :Function = Linear.easeNone,
				_tween_time :Number = .2;

	/**
	 * Ancho real del documento en píxeles. Es necesario especificarlo para una correcta alineación.
	 * Si se obtuviera dinámicamente en una película ejecutada desde el navegador se obtendría un valor erróneo, si el valor
	 * del tamaño es percentual o en Internet Explorer si la película se incrusta con herramientas como SWFObject.
	 */
	public static var stageWidth :int;
	/**
	 * Altura real del documento en píxeles. Es necesario especificarla para una correcta alineación.
	 * Si se obtuviera dinámicamente en una película ejecutada desde el navegador se obtendría un valor erróneo, si el valor
	 * del tamaño es percentual o en Internet Explorer si la película se incrusta con herramientas como SWFObject.
	 */	public static var stageHeight :int;

	/**
	 * Obtiene o define la alineación del objeto de visualización respecto al escenario.
	 * @see flash.display.StageAlign
	 * @default null
	 */
	public function get align() :String
	{
		return _align;
	}
	public function set align(value :String) :void
	{
		_align = value;
	}

	/**
	 * Ajusta la posición del objeto de visualización a valores enteros, evitando que se produzca aliasing y los textos se vean borrosos.
	 * @default false
	 */
	public function get pixelSnap() :Boolean
	{
		return _pixel_snap;
	}
	public function set pixelSnap(value :Boolean) :void
	{
		_pixel_snap = value;
	}

	/**
	 * Establece u obtiene la posición horizontal del objeto Sprite, que sirve de referencia al ajustar la posición del mismo cuando se redimensiona el
	 * escenario. Por defecto toma la propiedad <code>x</code> del objeto Sprite.
	 */
	public function get x() :Number
	{
		return _x;
	}
	public function set x(value :Number) :void
	{
		_x = value;
	}

	/**
	 * Establece u obtiene la posición vertial del objeto Sprite, que sirve de referencia al ajustar la posición del mismo cuando se redimensiona el
	 * escenario. Por defecto toma la propiedad <code>y</code> del objeto Sprite.
	 */
	public function get y() :Number
	{
		return _y;
	}
	public function set y(value :Number) :void
	{
		_y = value;
	}

	/**
	 * Establece si el desplazamiento del Sprite al cambiar el tamaño del escenario debe ser animado o instantáneo.
	 * @default false
	 * @example
<listing version="3.0">
import flash.display.StageAlign;
import jp.raohmaru.toolkit.display.StageAlignSprite;<br>
import jp.raohmaru.toolkit.motion.easing.Quad;<br>
StageAlignSprite.init(700, 450);<br>
var sagui :StageAlignSprite = new StageAlignSprite(some_mc, StageAlign.TOP);
    sagui.align = StageAlign.TOP;
	salign.tween = true;
	salign.tweenTime = .4;
	salign.tweenEase = Quad.easeOut;
</listing>
	 */
	public function get tween() :Boolean
	{
		return _tween;
	}
	public function set tween(value :Boolean) :void
	{
		_tween = value;
	}

	/**
	 * La ecuación de movimiento a utilizar en la interpolación.
	 * Para animar el desplamiento del Sprite, establecer <code>tween = true</code>.
	 * @default jp.raohmaru.toolkit.motion.easing.Linear.easeNone
	 * @see #tween
	 */
	public function get tweenEase() :Function
	{
		return _tween_ease;
	}
	public function set tweenEase(value :Function) :void
	{
		_tween_ease = value;
	}

	/**
	 * La duración de la animación, en segundos.
	 * Para animar el desplamiento del Sprite, establecer <code>tween = true</code>.
	 * @default .2
	 * @see #tween
	 */
	public function get tweenTime() :Number
	{
		return _tween_time;
	}
	public function set tweenTime(value :Number) :void
	{
		_tween_time = value;
	}


	/**
	 * Crea una nueva instancia de StageAlignSprite, responsable de alinear al Sprite especificado como parámetro respecto al escenario.
	 * @param movie Un objeto Sprite que será alineado respecto al escenario.
	 * @param align Un valor de la clase StageAlign que especifica la alineación del escenario en Flash Player o el navegador.	 * @param pixelSnap Ajusta la posición del objeto de visualización a valores enteros.	 * @param waitForBrowserInit Corrige el error que se produce al incrustar un SWF con SWFObject o librerías JavaScript similares en un HTML, con
	 * el parámetro	<code>scale</code> igual a <code>noScale</code>; entonces el navegador en primera instancia reporta erróneamente
	 * <code>Stage.stageWidth</code> y <code>Stage.stageHeight</code> al cargar o recargar la página (retorna 0).
	 * @see flash.display.StageAlign
	 */
	public function StageAlignSprite(movie :DisplayObject, align :String = null, pixelSnap :Boolean=false, waitForBrowserInit :Boolean=false)
	{
		_movie = movie;
		_align = align;
		_pixel_snap = pixelSnap;
		_x = _movie.x;
		_y = _movie.y;
		_browser_fix = waitForBrowserInit;


		if(_movie.stage)
			addStageListener();
		else
			_movie.addEventListener(Event.ADDED_TO_STAGE, addStageListener);
	}

	/**
	 * Otra manera de establecer el ancho y el alto del documento, más adecuado a las convenciones de programación en ActionScript.
	 * Establece las propiedades <code>stageWidth</code> y <code>stageHeight</code> a los valores especificados.
	 * @param width Ancho real del documento en píxeles.	 * @param height Altura real del documento en píxeles.
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.display.StageAlignSprite;<br>
	StageAlignSprite.stageWidth = 800;	StageAlignSprite.stageHeight = 600;	// Esto es lo mismo	StageAlignSprite.init(800, 600);
	</listing>
	 */
	public static function init(width :int, height :int) :void
	{
		stageWidth = width;		stageHeight = height;
	}


	private function addStageListener(e :Event = null) :void
	{
		_stage = _movie.stage;
		_movie.removeEventListener(Event.ADDED_TO_STAGE, addStageListener);
		_stage.addEventListener(Event.RESIZE, onResizeStage);		_stage.addEventListener(Event.FULLSCREEN, onResizeStage);

		if(_browser_fix)
			// Al meter un flash con SWFObject, desde el navegador reporta stageWidth=0 al cargar o cargar la página
			_movie.addEventListener(Event.ENTER_FRAME, checkStage);
		else
			onResizeStage();
	}

	private function onResizeStage(e :Event = null) :void
	{
		if(_stage.stageWidth <= 0 && _stage.stageHeight <= 0) return;

		if(_align == null || _align == "") return;

		// Si se retorna de pantalla completa, las dimensiones justo después del evento son las mismas que en fullscreen.
		// Hay que esperar un fotograma.
		if(e && e.type == Event.FULLSCREEN)
		{
			_movie.addEventListener(Event.ENTER_FRAME, checkStage);
			return;
		}

		var x :Number,			y :Number;

		if(_align.indexOf("L") != -1 && _stage.align.indexOf("L") == -1)
			x = (stageWidth - _stage.stageWidth) / (_stage.align.indexOf("R") == -1 ? 2 : 1);

		else if(_align.indexOf("R") != -1 && _stage.align.indexOf("R") == -1)
			x = (_stage.stageWidth - stageWidth) / (_stage.align.indexOf("L") == -1 ? 2 : 1);


		if(_align.indexOf("T") != -1 && _stage.align.indexOf("T") == -1)
			y = (stageHeight - _stage.stageHeight) / (_stage.align.indexOf("B") == -1 ? 2 : 1);

		else if(_align.indexOf("B") != -1 && _stage.align.indexOf("B") == -1)
			y = (_stage.stageHeight - stageHeight) / (_stage.align.indexOf("T") == -1 ? 2 : 1);

		x = (x != x) ? _movie.x : (_pixel_snap) ? Math.round(x+_x) : x+_x;
		y = (y != y) ? _movie.y : (_pixel_snap) ? Math.round(y+_y) : y+_y;

		if(_tween)
			Paprika.add(_movie, _tween_time, {x:x, y:y}, _tween_ease);
		else
		{
			_movie.x = x;
			_movie.y = y;
		}

		if(e == null)
			e = new Event(Event.RESIZE);
		dispatchEvent(e);
	}

	/**
	 * Comprueba que el ancho y el alto del stage sean mayores que 0. Esto sucede cuando se incrusta un SWF con SWFObject o similares y el valor
	 * scale es igual a noScale; entonces los navegadores reportan erróneamente Stage.stageWidth y Stage.stageHeight al cargar o recargar
	 * la página.
	 */
	private function checkStage(e :Event) :void
	{
		if(_stage.stageWidth > 0 && _stage.stageHeight > 0)
		{
			_movie.removeEventListener(Event.ENTER_FRAME, checkStage);
			onResizeStage();
		}
	}


	/**
	 * Elimina todos los eventos del objeto Sprite asociado y la referencia al mismo, para la correcta recolección de basura.
	 */
	public function dispose() :void
	{
		_movie.removeEventListener(Event.ADDED_TO_STAGE, addStageListener);
		_movie.removeEventListener(Event.ENTER_FRAME, checkStage);
		_movie = null;

		_stage.removeEventListener(Event.RESIZE, onResizeStage);
		_stage.removeEventListener(Event.FULLSCREEN, onResizeStage);
		_stage = null;
	}
}
}