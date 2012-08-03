/*
Copyright (C) 2012 raohmaru <http://raohmaru.com>

This file is part of Raohmaru Toolkit.

Raohmaru Toolkit is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Raohmaru Toolkit is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with Raohmaru Toolkit.  If not, see <http://www.gnu.org/licenses/>.
*/

package jp.raohmaru.toolkit.utils
{
/**
 * Conjunto de métodos que extienden la funcionalidad de la clase Math.
 * @see Math
 * @author raohmaru
 */
public class MathUtil
{
	/**
	 * @private
	 */
	private static const HEX_NUMBERS :String = "0123456789abcdef";


	/**
	* Devuelve un valor de coma flotante aleatorio entre un valor mínimo y un valor máximo.
	* @return Number
	* @param min Valor inferior (o máximo si no se especifica <code>max</code>)
	* @param max Valor superior
	* @param decimal Convierte el valor en un número de coma flotante y desplaza la coma la cantidad de decimales especificados
	* @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.utils.MathUtil;

	trace( MathUtil.random() );  // 0.35709940269589424
	trace( MathUtil.random(10) );  // 7.056785519234836
	trace( MathUtil.random(-5, 5) );  // -0.1471709879115224
	trace( MathUtil.random(0, .99, 2) );  // 0.37	</listing>
	*/
	public static function random(min : Number = NaN, max : Number = NaN, decimal : int = 0) : Number
	{
		if(isNaN(min)) return Math.random();

		if(isNaN(max))
		{
			max = min;
			min = 0;
		}

		var r : Number = Math.random()*(max-min) + min;
		if(decimal > 0)
		{
			decimal = Math.pow(10, decimal);
			r = Math.round(r * decimal) / decimal;
		}
		return r;
	}

	/**
	* Devuelve un valor entero aleatorio entre un valor mínimo y un valor máximo.
	* @return int
	* @param min Valor inferior (o máximo si no se especifica <code>max</code>)
	* @param max Valor superior
	*/
	public static function randomInt(min : int = 1, max : int = 0) : int
	{
		if(max == 0)
		{
			max = min;
			min = 0;
		}

		return int(Math.round( Math.random()*(max-min) + min ));
	}

	/**
	* Devuelve un valor booleano aleatorio según la probabilidad estimada.
	* @return Boolean
	* @param prob % de probabilidad que salga <code>true</code>
	*/
	public static function randomBool(prob : Number = 50) : Boolean
	{
		return (Math.random()*100 < prob);
	}

	/**
	* Devuelve aleatoriamente -1 ó 1 según la probabilidad estimada.
	* @return Number
	* @param prob % de probabilidad que salga 1
	*/
	public static function randomSign(prob : Number = 50) : int
	{
		return (Math.random()*100 < prob) ? 1 : -1;
	}

	/**
	* Devuelve aleatoriamente 0 ó 1 según la probabilidad estimada.
	* @return Number
	* @param prob % de probabilidad que salga 1
	*/
	public static function randomBit(prob : Number = 50) : int
	{
		return ( ((Math.random()*100)) < prob) ? 1 : 0;
	}

	/**
	 * Devuelve un entero sin signo aleatorio entre 0x0 y 0xFFFFFF.
	 * @return Un valor entre 0x0 y 0xFFFFFF
	 */
	public static function randomHexColor() : uint
	{
		return randomInt(16777215);
	}

	/**
	 * Devuelve un valor entero sin signo aleatorio correspondiente a una gama de color gris, del blanco al negro.
	 * El rango de valores va del 0 (negro) al 255 (blanco).
	 * @param min Valor inferior (o máximo si no se especifica <code>max</code>).
	 * @param max Valor superior.
	 * @return uint
	 */
	public static function randomGreyColor(min :uint=255, max :uint=0) : uint
	{
		if(max == 0)
		{
			max = min;
			min = 0;
		}
		if(min > 255) min = 255;		if(max > 255) max = 255;

		var n1 :String = HEX_NUMBERS.substr(randomInt(15),1),
			n2 :String = HEX_NUMBERS.substr(randomInt(15),1),
			n :uint = parseInt(n1+n2+n1+n2+n1+n2, 16),
			n255 :Number = (n * 255) / 0xFFFFFF;

		if(n255 < min) n = (min * 0xFFFFFF) / 255;
		else if(n255 > max) n = (max * 0xFFFFFF) / 255;

		return n;
	}

	/**
	* Convierte un valor en grados a radianes.
	* @return Number
	* @param grados Grados a convertir
	*/
	public static function toRadian(grados : Number) : Number
	{
		return(grados*Math.PI/180);
	}

	/**
	* Convierte un valor en radianes a grados.
	* @return Number
	* @param radianes Radianes a convertir
	*/
	public static function toDegree(radianes : Number) : Number
	{
		return(radianes*180/Math.PI);
	}

	/**
	* Devuelve una lista desordenada de valores entre el rango especificado, ambos inclusive.
	* @return Array
	* @param min Inicio de la lista
	* @param max Fin de la lista
	* @param decimal Convierte el valor en un número de coma flotante y desplaza la coma la cantidad de decimales especificados
	*/
	public static function chaos(min : int, max : int = 0, decimal : int = 0) : Array
	{
		if(max == 0)
		{
			if(min > 0)
			{
				max = min;
				min = 0;
			}
		}

		decimal = (decimal > 0) ? Math.pow(10, decimal) : 1;

		var lista : Array = new Array(),
			valores : Array = new Array();

		for(var i : int=min; i<=max; i++) lista.push(i/decimal);
		var len : int = lista.length;
		for(i=0; i<len; i++)
			valores.push( lista.splice( MathUtil.randomInt(lista.length-1), 1 )[0] );

		return valores;
	}

	/**
	 * Determina si un número entero está dentro del rango de valores (valor mínimo y máximo inclusive), y en caso de sobrepasarlo lo adecúa a los límites del rango.
	 * @param n El número a comprobar
	 * @param range_start Inicio del rango (o fin del rango si no se especifica <code>range_end</code>)
	 * @param range_end Fin del rango
	 */
	public static function checkRange(n : int, range_start : int, range_end : int = 0) : int
	{
		if(range_end == 0)
		{
			range_end = range_start;
			range_start = 0;
		}

		if(n > range_end)
		{
			while(n > range_end) n -= Math.abs( range_end+1 - range_start );
		}
		else if(n < range_start)
		{
			while(n < range_start) n += Math.abs( range_end+1 - range_start );
		}

		return n;
	}
}
}