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

package jp.raohmaru.toolkit.utils
{

/**
 * Conjunto de métodos que amplían las funcionalidades de la clase Number.
 * @see Number
 * @author raohmaru
 */
public class NumberUtil
{
	/**
	* Comprueba si un número es par.
	* @return Boolean
	* @param value Número a comprobar
	*/
	public static function isEven(value : Number) : Boolean
	{
		return( (value & 1) == 0 );
	}

	/**
	* Comprueba si un valor númerico es un entero.
	* @return Boolean
	* @param value Número a comprobar
	*/
	public static function isInt(value : Number) : Boolean
	{
		//return  value.toString().indexOf(".") == -1;
		return (value - Math.floor(value) == 0);
	}

	/**
	* Comprueba si el valor es un número de coma flotante.
	* @return Boolean
	* @param value Número a comprobar
	*/
	public static function isFloat(value : Number) : Boolean
	{
		//return value.toString().indexOf(".") != -1;
		return (value - Math.floor(value) != 0);
	}

	/**
	* Devuelve <code>true</code> si el valor es <code>NaN</code> (no es un número).
	* Este método es una versión optimizada de la funcion global <code>isNaN()</code>.
	* @return Boolean Devuelve <code>true</code> si el valor es <code>NaN</code> (no es un número) y <code>false</code> en caso contrario.
	* @param value Valor numérico o expresión matemática que se va a evaluar.
	* @see isNaN
	* @author Jackson Dunstan [http://jacksondunstan.com/articles/983]
	*/
	public static function isNaN(value :Number) :Boolean
	{
		return value != value;
	}

	/**
	* Devuelve <code>true</code> si el valor es un número.
	* Este método es una versión optimizada de la funcion global <code>!isNaN()</code>.
	* @return Boolean Devuelve <code>true</code> si el valor es un número y <code>false</code> en caso contrario (es NaN).
	* @param value Valor numérico o expresión matemática que se va a evaluar.
	* @author Jackson Dunstan [http://jacksondunstan.com/articles/983]
	* @see #isNaN()
	*/
	public static function isNotNaN(value :Number) :Boolean
	{
		return value == value;
	}

	/**
	* Devuelve el número de decimales que contiene un número
	* @return uint
	* @param n Número
	*/
	public static function decimalLenght(n : Number) : uint
	{
		if(!isFloat(n)) return 0;

		var n_str : String = n.toString().split(".")[1];
		return n_str.length;
	}

	/**
	 * Obtiene un valor de color ARGB a partir de un color RGB y un valor de alpha.
	 * @return Un color en formato ARGB.
	 * @param rgb El valor de un color RGB en hexadecimal.
	 * @param newAlpha La cantidad de transparencia asignada al color. Debe ser un valor comprendido entre 0x00 y 0xFF (0 y 255).
	 */
	public static function colorToARGB(rgb :uint, alpha :uint = 255) :uint
	{
		if(alpha > 255) alpha = 255;

		return (alpha<<24) + rgb;
	}

	/**
	 * Redondea el número en notación de coma fija. La notación de coma fija significa que la cadena contendrá un número concreto de
	 * dígitos tras la coma decimal, conforme a lo especificado en el parámetro <code>fractionDigits</code>. El rango válido para el
	 * parámetro <code>fractionDigits</code> va de 0 a 20. Al especificar un valor situado fuera de este rango, se emite una excepción.
	 * @return Number
	 * @param n Número a redondear.
	 * @param fractionDigits Un entero entre 0 y 20, ambos inclusive, que representa el número deseado de cifras decimales.
	 * @see Number.toFixed()
	 */
	public static function toFixed(n :Number, fractionDigits:uint) :Number
	{
		return Number( n.toFixed(fractionDigits) );
	}

}
}