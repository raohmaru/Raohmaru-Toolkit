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

package jp.raohmaru.toolkit.form
{
import jp.raohmaru.toolkit.utils.ArrayUtil;

/**
 * Utilidades para componentes de formulario.
 * @author raohmaru
 */
public class FormUtil
{
	/**
	 * Devuelva una matriz con tantos elementos como el rango especificado, siendo cada elemento de la matriz un objeto con los valores <code>label</code> y
	 * <code>value</code> igual al número correspondiente.
	 * @param start Inicio del rango (o fin del rango si no se especifica <code>end</code>).
	 * @param end Fin del rango.
	 * @param decimal Convierte los valores en números de coma flotante y desplaza la coma la cantidad de decimales especificados.
	 * @return Una matriz con el rango especificado.
	 * @example
	 * <listing version="3.0">
	 * import jp.raohmaru.toolkit.form.FormUtil;
	 * import fl.data.DataProvider;
	 *
	 * var dp:DataProvider = new DataProvider();
	 * 	dp.addItems(FormUtil.addRangeComboItems(10, 0, 1));
	 * trace(dp.length);  // 11
	 *
	 * cb.dataProvider = dp;
	 * </listing>
	 */
	public static function getRangeComboItems(start : int, end : int = 0, decimal : int = 0) : Array
	{
		var arr : Array = ArrayUtil.range(start, end, decimal),
			data :Array = [];

		for each (var v:Number in arr) {
		   data.push( {label:v, value:v} );
		}

		return data;
	}

	/**
	 * Obtiene una cadena con los caracteres restringidos según el tipo especificado.
	 * @param type Tipo de restricción
	 * @return Cadena con caracteres a restringir
	 * @see flash.text.TextField#restrict
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.form.FormType;
	import jp.raohmaru.toolkit.form.FormUtil;<br>
	email_input.restrict = FormUtil.getRestrictChars(FormType.EMAIL);</listing>
	 */
	public static function getRestrictChars(type : String) : String
	{
		var rchars : String;

		switch(type)
		{
			case FormElementType.EMAIL:
				rchars = "0-9a-zA-Z\\-+._@";
				break;

			case FormElementType.NUMBER:
				rchars = "0-9\\-+.";
				break;

			case FormElementType.POSTAL_CODE:
			case FormElementType.MOBILE:
			case FormElementType.PHONE:
			case FormElementType.PHONE_MOBILE:
				rchars = "0-9";
				break;

			case FormElementType.DNI:
			case FormElementType.CIF:
				rchars = "0-9a-zA-Z";
				break;
		}

		return rchars;
	}
}
}