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
 * Conjunto de métodos que extienden la funcionalidad de la clase Array.
 * @see Array
 * @author raohmaru
 */
public class ArrayUtil
{
	/**
	 * Desordena los elementos de una matriz de manera aleatoria. Este método modifica la matriz.
	 * @param arr Matriz original a desordenar
	 * @return Matriz desordenada
	 */
	public static function unsort(arr : Array) : Array
	{
		var clone_arr : Array = clone(arr),
			len : int = clone_arr.length,
			random : Number;

		empty(arr);

		for(var i:int=0; i<len; i++)
		{
			random = Math.round( Math.random()*(clone_arr.length-1) );
			arr.push( clone_arr.splice( random, 1 )[0] );
		}

		return arr;
	}

	/**
	 * Ordena los elementos de una matriz siguiendo un orden natural (en la forma en que lo haría un ser humano). Este método modifica la matriz.
	 * @param arr Matriz original a ordenar
	 * @return Matriz ordenada
	 * @example
	 * <listing version="3.0">
	 var arr : Array = ["img5","img2","img4","img1","img10","img0","img14"];
	 ArrayUtils.natsort(arr);
	 trace(arr) // img0,img1,img2,img4,img5,img10,img14</listing>
	 */
	public static function natsort(arr : Array) : Array
	{
		return arr.sort(naturalCompareSort);
	}

	/**
	 * Clona una matriz.
	 * @param arr Matriz origen
	 * @return Nueva matriz clon de la original
	 */
	public static function clone(arr : Array) : Array
	{
		var clone_arr : Array = [];

		// Matrices numéricas
		if(arr.length)
		{
			clone_arr = arr.concat();
		}
		// Matrices asociativas
		else
		{
			for(var key:String in arr)
				clone_arr[key] = arr[key];
		}

		return clone_arr;
	}

	/**
	 * Genera una matriz con un número de elementos igual a la longitud del rango, cuyos valores están comprendidos en el rango espeficado.
	 * @param start Inicio del rango (o fin del rango si no se especifica <code>end</code>)
	 * @param end Fin del rango
	 * @param decimal Convierte los valores en números de coma flotante y desplaza la coma la cantidad de decimales especificados
	 */
	public static function range(start : int, end : int = 0, decimal : int = 0) : Array
	{
		if(end == 0)
		{
			end = start;
			start = 0;
		}

		end += (end >= start) ? 1 : -1;

		var arr : Array = [],
			incr : int = (end >= start) ? 1 : -1;

		// Iteración rápida para rangos de tipo int
		if(decimal == 0)
		{
			for(var i:int=start; i!=end; i)
			{
				arr.push(i);
				i += incr;
			}
		}
		// Iteración más lenta cuando hay decimales, así no menoscaba el rendimiento de cuando no hay
		else
		{
			decimal = Math.pow(10, decimal);
			var n : Number = start;

			for(var j:int=start; j!=end; j)
			{
				// Es más rápido dividir o multiplicar un Number que un int.
				// Y al parecer uint es lentísimo
				arr.push(j/decimal);
				n += 1;
				j += incr;
			}
		}

		return arr;
	}

	/**
	 * Vacía una matriz de todos sus elementos.
	 * @param arr Matriz a vaciar
	 * @return Una nueva matriz con los elementos eliminados
	 */
	public static function empty(arr : Array) : Array
	{
		// Matrices numéricas
		if(arr.length)
		{
			//return arr.splice(0, arr.length);
			// Infinitamente más rapido
			arr.length = 0;
			return arr;
		}
		// Matrices asociativas
		else
		{
			var clone_array : Array = clone(arr);

			for(var key:String in arr)
				delete arr[key];

			return clone_array;
		}
	}



	/**
	 * Algoritmo de ordenación natural (ordena en la forma en que lo haría un ser humano) utilizado como función de comparación.
	 * @version 0.2
	 * @author Jim Palmer (based on chunking idea from Dave Koelle). Released under MIT license
	 * @author raohmaru, Ported to AS3 by
	 * @example
	 * <listing version="3.0">
	 someArray.sort(ArrayUtils.naturalSort);</listing>
	 */
	public static function naturalCompareSort (a : Object, b : Object) : Number
	{
	    // setup temp-scope variables for comparison evauluation
	    var x : String = a.toString().toLowerCase() || '',
	    	y : String = b.toString().toLowerCase() || '',
	    	// Selecciona un caracter extrañísimo de poco uso para hacer de separador
	        nC : String = String.fromCharCode(1),
	        xN : Array = x.replace(/([-]{0,1}[0-9.]{1,})/g, nC + '$1' + nC).split(nC),
	        yN : Array = y.replace(/([-]{0,1}[0-9.]{1,})/g, nC + '$1' + nC).split(nC),
	        xD : Number = (new Date(x)).getTime(),
	        yD : Number = (new Date(y)).getTime();

	    // natural sorting of dates
	    if ( xD && yD && xD < yD )
	        return -1;
	    else if ( xD && yD && xD > yD )
	        return 1;

	    // natural sorting through split numeric strings and default strings
	    for ( var cLoc:int=0, numS:Number=Math.max( xN.length, yN.length ); cLoc < numS; cLoc++ )
	        if ( ( parseFloat( xN[cLoc] ) || xN[cLoc] ) < ( parseFloat( yN[cLoc] ) || yN[cLoc] ) )
	            return -1;
	        else if ( ( parseFloat( xN[cLoc] ) || xN[cLoc] ) > ( parseFloat( yN[cLoc] ) || yN[cLoc] ) )
	            return 1;
	    return 0;
	}
}
}
