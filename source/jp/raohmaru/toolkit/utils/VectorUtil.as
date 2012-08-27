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
 * Conjunto de métodos que extienden la funcionalidad de la clase Vector.
 * @see Array
 * @author raohmaru
 */
public class VectorUtil
{
	/**
	 * Desordena los elementos de un vector siguiendo el algoritmo Fisher–Yates.
	 * Este método modifica el vector.
	 * @param arr Vector original a desordenar
	 * @return Vector desordenado
	 */
	public static function shuffle(v :Object) :Object
	{
		var i :int = v.length,
			j :int,
			t :*;
		while (i > 0)
		{
			j = Math.random() * i;
			t = v[--i];
			v[i] = v[j];
			v[j] = t;	
		}
		
		return v;
	}
}
}