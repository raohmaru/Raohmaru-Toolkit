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
 * Utilidades para el tratamiento de cadenas de texto.
 * @author raohmaru
 */
public class StringUtil
{
	private static var UNICODE_CHARS	:Array = [ "Š", "Œ",  "Ž", "š", "œ",  "ž", "[ÀÁÂÃÄÅ]", 	"Æ",  "Ç", "[ÈÉÊË]", "[ÌÍÎÏ]",	"Ð", "Ñ", "[ÒÓÔÕÖØ]",	"[ÙÚÛÜ]",	"[ŸÝ]", "Þ",  "ß", "[àáâãäå]",	"æ",  "ç", "[èéêë]",	"[ìíîï]",	"ð", "ñ", "[òóôõöø]",	"[ùúûü]",	"[ýÿ]", "þ" ];
	private static var DECOMPOSED_CHARS	:Array = [ "S", "Oe", "Z", "s", "oe", "z", "A",			"Ae", "C", "E",		 "I",		"D", "N", "O",			"U",		"Y",	"Th", "ss", "a",		"ae", "c", "e",			"i",		"d", "n", "o",			"u",		"y",	"th" ];

	/**
	 * Especifica que la primera letra de cada palabra se convertirá en mayúscula (como en un titular).
	 * <i>"La Casa Gris Del Llano"</i>
	 */
	public static const TITLE : String = "title";
	/**
	 * Especifica que la primera letra de una sentencia, seperada por puntos, será mayúscula.
	 * <i>"Bajó del coche. Piso un charco. Maldijo."</i>
	 */
	public static const SENTENCE : String = "sentence";

	/**
	 * XML guarda la codificación Unicode para cada caracter HTML.
	 */
	public static const ENTITIES : XML = <root>
		<e code="quot"><![CDATA[\u0022]]></e>
		<e code="amp"><![CDATA[\u0026]]></e>
		<e code="apos"><![CDATA[\u0027]]></e>
		<e code="lt"><![CDATA[\u003C]]></e>
		<e code="gt"><![CDATA[\u003E]]></e>
		<e code="nbsp"><![CDATA[\u00A0]]></e>
		<e code="iexcl"><![CDATA[\u00A1]]></e>
		<e code="cent"><![CDATA[\u00A2]]></e>
		<e code="pound"><![CDATA[\u00A3]]></e>
		<e code="curren"><![CDATA[\u00A4]]></e>
		<e code="yen"><![CDATA[\u00A5]]></e>
		<e code="brvbar"><![CDATA[\u00A6]]></e>
		<e code="sect"><![CDATA[\u00A7]]></e>
		<e code="uml"><![CDATA[\u00A8]]></e>
		<e code="copy"><![CDATA[\u00A9]]></e>
		<e code="trade"><![CDATA[\u2122]]></e>
		<e code="reg"><![CDATA[\u00AE]]></e>
		<e code="deg"><![CDATA[\u00B0]]></e>
		<e code="plusmn"><![CDATA[\u00B1]]></e>
		<e code="sup1"><![CDATA[\u00B9]]></e>
		<e code="sup2"><![CDATA[\u00B2]]></e>
		<e code="sup3"><![CDATA[\u00B3]]></e>
		<e code="acute"><![CDATA[\u00B4]]></e>
		<e code="micro"><![CDATA[\u00B5]]></e>
		<e code="frac14"><![CDATA[\u00BC]]></e>
		<e code="frac12"><![CDATA[\u00BD]]></e>
		<e code="frac34"><![CDATA[\u00BE]]></e>
		<e code="iquest"><![CDATA[\u00BF]]></e>
		<e code="Agrave"><![CDATA[\u00C0]]></e>
		<e code="Aacute"><![CDATA[\u00C1]]></e>
		<e code="Acirc"><![CDATA[\u00C2]]></e>
		<e code="Atilde"><![CDATA[\u00C3]]></e>
		<e code="Auml"><![CDATA[\u00C4]]></e>
		<e code="Aring"><![CDATA[\u00C5]]></e>
		<e code="AElig"><![CDATA[\u00C6]]></e>
		<e code="Ccedil"><![CDATA[\u00C7]]></e>
		<e code="Egrave"><![CDATA[\u00C8]]></e>
		<e code="Eacute"><![CDATA[\u00C9]]></e>
		<e code="Ecirc"><![CDATA[\u00CA]]></e>
		<e code="Euml"><![CDATA[\u00CB]]></e>
		<e code="Igrave"><![CDATA[\u00CC]]></e>
		<e code="Iacute"><![CDATA[\u00CD]]></e>
		<e code="Icirc"><![CDATA[\u00CE]]></e>
		<e code="Iuml"><![CDATA[\u00CF]]></e>
		<e code="ETH"><![CDATA[\u00D0]]></e>
		<e code="Ntilde"><![CDATA[\u00D1]]></e>
		<e code="Ograve"><![CDATA[\u00D2]]></e>
		<e code="Oacute"><![CDATA[\u00D3]]></e>
		<e code="Ocirc"><![CDATA[\u00D4]]></e>
		<e code="Otilde"><![CDATA[\u00D5]]></e>
		<e code="Ouml"><![CDATA[\u00D6]]></e>
		<e code="Oslash"><![CDATA[\u00D8]]></e>
		<e code="Ugrave"><![CDATA[\u00D9]]></e>
		<e code="Uacute"><![CDATA[\u00DA]]></e>
		<e code="Ucirc"><![CDATA[\u00DB]]></e>
		<e code="Uuml"><![CDATA[\u00DC]]></e>
		<e code="Yacute"><![CDATA[\u00DD]]></e>
		<e code="THORN"><![CDATA[\u00DE]]></e>
		<e code="szlig"><![CDATA[\u00DF]]></e>
		<e code="agrave"><![CDATA[\u00E0]]></e>
		<e code="aacute"><![CDATA[\u00E1]]></e>
		<e code="acirc"><![CDATA[\u00E2]]></e>
		<e code="atilde"><![CDATA[\u00E3]]></e>
		<e code="auml"><![CDATA[\u00E4]]></e>
		<e code="aring"><![CDATA[\u00E5]]></e>
		<e code="aelig"><![CDATA[\u00E6]]></e>
		<e code="ccedil"><![CDATA[\u00E7]]></e>
		<e code="egrave"><![CDATA[\u00E8]]></e>
		<e code="eacute"><![CDATA[\u00E9]]></e>
		<e code="ecirc"><![CDATA[\u00EA]]></e>
		<e code="euml"><![CDATA[\u00EB]]></e>
		<e code="igrave"><![CDATA[\u00EC]]></e>
		<e code="iacute"><![CDATA[\u00ED]]></e>
		<e code="icirc"><![CDATA[\u00EE]]></e>
		<e code="iuml"><![CDATA[\u00EF]]></e>
		<e code="eth"><![CDATA[\u00F0]]></e>
		<e code="ntilde"><![CDATA[\u00F1]]></e>
		<e code="ograve"><![CDATA[\u00F2]]></e>
		<e code="oacute"><![CDATA[\u00F3]]></e>
		<e code="ocirc"><![CDATA[\u00F4]]></e>
		<e code="otilde"><![CDATA[\u00F5]]></e>
		<e code="ouml"><![CDATA[\u00F6]]></e>
		<e code="oslash"><![CDATA[\u00F8]]></e>
		<e code="ugrave"><![CDATA[\u00F9]]></e>
		<e code="uacute"><![CDATA[\u00FA]]></e>
		<e code="ucirc"><![CDATA[\u00FB]]></e>
		<e code="uuml"><![CDATA[\u00FC]]></e>
		<e code="yacute"><![CDATA[\u00FD]]></e>
		<e code="thorn"><![CDATA[\u00FE]]></e>
		<e code="yuml"><![CDATA[\u00FF]]></e>
	</root>;

	/**
	 * Devuelve una copia de esta cadena capitalizada según el tipo especificado (convierte la primera letra de una palabra en mayúscula, dado el caso).
	 * @param str Cadena de texto
	 * @param type Forma en que se capitalizará la cadena (por defecto sólo la primera letra)
	 * @return Una copia de esta cadena
	 * @example
	 * <listing version="3.0">
	 * import jp.raohchan.utils.StringUtils;<br>	 * StringUtils.capitalize("En un agujero en el suelo, vivía un hobbit", StringUtil.TITLE);  // "En Un Agujero En El Suelo, Vivía Un Hobbit"	 * StringUtils.capitalize("empezó a contar: uno. dos. tres.", StringUtil.SENTENCE);  // "Empezó a contar: uno. Dos. Tres."</listing>
	 */
	public static function capitalize(str : String, type : String = null) : String
	{
		var arr : Array;

		switch(type)
		{
			case "title":		//"La Casa Gris Del Llano"
				arr = str.split(" ");
				arr.forEach(toUpperCaseFirstLetter);
				str = arr.join(" ");
				break;

			case "sentence":	//"Bajó del coche. Piso un charco. Maldijo."
				arr = str.split(". ");
				arr.forEach(toUpperCaseFirstLetter);
				str = arr.join(". ");
				break;

			default:			//"Torre en la montaña. disparos..."
				str = toUpperCaseFirstLetter(str);
		}

		return str;
	}

	/**
	 * Convierte en mayúscula la primera letra de la cadena y devuelve una copia. Utilizada en el método <code>Array.forEach</code> de la función <code>capitalize</code>
	 * @param str Cadena a modificar
	 * @return Cadena modificada
	 * @see #capitalize()
	 */
	public static function toUpperCaseFirstLetter(str:String, index:int=0, arr:Array=null) : String
	{
		str = str.replace( /([a-zA-ZàáäèéëìíïòóöùúüÀÁÄÈÉËÌÍÏÒÓÖÙÚÜ])/, function() : String
		{
			return arguments[1].toUpperCase();
		} );

		if(arr) arr[index] = str;

		return str;
	}

	/**
	 * Convierte un valor numérico en un cadena con el número de dígitos especificados, añadiendo "0" hasta llegar a la longitud deseada.
	 * @param number Número a convertir.
	 * @param num_digits Número de dígitos que tendrá la cadena resultante.
	 * @param suffix Indica si los nuevos dígitos se deben insertar antes (<code>false</code>) o después (<code>true</code>) del número.
	 * @return La cadena resultante
	 * @example
	 * <listing version="3.0">StringUtils.toDigits(4, 2);  // "04"</listing>
	 */
	public static function toDigits(number : Object, num_digits : int = 2, suffix :Boolean = false) : String
	{
		var str : String = number.toString();
		while(str.length < num_digits)
			str = (!suffix) ? "0" + str : str + "0";
		return str;
	}

	/**
	 * Devuelva una copia de la cadena con el orden invertido.
	 * @param str Cadena original
	 * @return Cadena invertida
	 */
	public static function reverse(str : String) : String
	{
		return str.split("").reverse().join("");
	}

	/**
	 * Elimina de la cadena los caracteres especificados, y devuelva una copia.<br>Por defecto elimina los espacios.
	 * @param str Cadena original
	 * @param char Matriz con los caracteres a eliminar
	 * @return Una cadena sin los caracteres especificados
	 */
	public static function trim(str : String, chars : Array = null) : String
	{
		if(!chars) chars = [" "];

		for(var i:int=0; i<chars.length; i++)
			str = str.split(chars [i]).join("");

		return str;
	}

    /**
     * Quita las etiquetas HTML de la cadena especificada y devuelve una nueva cadena sin formato HTML.
     * @param source Una cadena con etiquetas HTML
     * @return Una nueva cadena sin formato HTML
     * @source Basado en el método com.ericfeminella.utils.StringUtils.removeHTML() de Eric J. Feminella [http://www.newcommerce.ca/]
     */
    public static function removeHTML(source :String) :String
    {
        var pattern:RegExp = /<[^>]*>/g;
        return source.replace(pattern, "");
    }

    /**
     * Quita las etiquetas HTML pasadas como argumentos de la cadena especificada, y devuelve una nueva cadena sin esas etiquetas.
     * @param source Una cadena con etiquetas HTML.
     * @param args Las etiquetas HTML a eliminar, únicamente el nombre sin los corchetes '&lt;&gt;'.
     * @return Una nueva cadena sin las etiquetas HTML
	 * @example
	 * <listing version="3.0">
	 * import jp.raohchan.utils.StringUtils;<br>
	 * var s :String = '<font size="36">¿Qué <br><B>HACEMOS</B>?</font>';
	 * StringUtil.removeHTMLTags(s, "font", "b");  // "¿Qué <br>HACEMOS?"</listing>
     */
    public static function removeHTMLTags(source :String, ...args :Array) :String
    {
    	var s :String = "";
    	for(var i:int=0; i<args.length; i++)
    	{
    		if(i > 0) s += "|";
    		s += "(<(/|)"+args[i]+"(>|( [^>]*>)))";
    	}

		var pattern:RegExp = new RegExp(s, "gi");
		return source.replace(pattern, "");
    }

	/**
	 * Reemplaza los caracteres HTML de una cadena por valores Unicode que sí puede renderizar correctamente Flash.
	 * También reemplaza las etiquetas <code>&lt;strong&gt;</code> y <code>&lt;em&gt;</code> por <code>&lt;b&gt;</code> e <code>&lt;i&gt;</code> respectivamente.
	 * @param str Cadena a analizar y reemplazar las ocurrencias.
	 * @return Una nueva cadena con los caracteres HTML reemplazados por valores Unicode.
	 */
	public static function parseHTML(str :String) : String
	{
		// Remplaza las etiquetas <strong> y <em> por <b> y <i>
		str = str.replace(new RegExp("strong>", "g"), "b>").replace(new RegExp("em>", "g"), "i>");
		var regexp :RegExp,
			ent :XML,
			s :String;

		for each (ent in ENTITIES.e)
		{
			s = "&"+ent.@code+";";
			regexp = new RegExp(s, "g");
			str = str.replace(regexp, ent);
			regexp = new RegExp(s.toUpperCase(), "g");
			str = str.replace(regexp, ent.toString().toUpperCase());
		}

		return str;
	}

	/**
	 * Elimina los saltos de carro "extra" de una cadena obtenida de un nodo de texto de un XML.
	 * Por alguna razón, Flash Player interpreta los saltos de carro en un nodo texto de XML como dobles.
	 * @param str Cadena con saltos de carro "extra" procedente de un XML.
	 * @return Una nueva cadena con los saltos de carro adicionales eliminados.
	 * @example
	 * <listing version="3.0">
	 var str :String = someXML.thenode.text();
	 trace(str);
	 // Lorem ipsum dolor sit amet,	 //	 // consectetur adipiscing elit. Nam malesuada laoreet purus...	 //	 // Nam malesuada laoreet purus...

	 str = StringUtil.removeXMLNewLines(str)
	 trace(str);
	 // Lorem ipsum dolor sit amet,
	 // consectetur adipiscing elit. Nam malesuada laoreet purus...
	 // Nam malesuada laoreet purus...</listing>
	 */
	public static function removeXMLNewLines(str :String) : String
	{
		return str.replace(/\r/g, "");
		// Otro método
		//return unescape(escape(str).split("%0D%0A").join("%0A"));
	}

	/**
	 * Elimina todos los saltos de carro y nuevas líneas de una cadena de texto.
	 * @param str Cadena a procesar.
	 * @return Una nueva cadena sin saltos de carro ni caracteres de nueva línea.
	 */
	public static function removeBreakLines(str :String) : String
	{
		return unescape(escape(str).split("%0D%0A").join(""));
	}

	/**
	 * Procesa una cadena de texto, reemplazando los caracteres con acentos (y otros caracteres especiales) por sus homónimos no acentuados.
	 * La siguiente tabla muestra los caracteres que son reemplazados por el caracter de la columna de la derecha:
<table class="innertable" width="200">
<tr>
	<td>Š</td>
	<td width="40%">S</td>
</tr>
<tr>
	<td>Œ</td>
	<td>Oe</td>
</tr>
<tr>
	<td>Ž</td>
	<td>Z</td>
</tr>
<tr>
	<td>š</td>
	<td>s</td>
</tr>
<tr>
	<td>œ</td>
	<td>oe</td>
</tr>
<tr>
	<td>ž</td>
	<td>z</td>
</tr>
<tr>
	<td>ÀÁÂÃÄÅ</td>
	<td>A</td>
</tr>
 	<tr>
	<td>Æ</td>
	<td>Ae</td>
</tr>
<tr>
	<td>Ç</td>
	<td>C</td>
</tr>
<tr>
	<td>ÈÉÊË</td>
	<td>E</td>
</tr>
<tr>
	<td>ÌÍÎÏ</td>
	<td>I</td>
</tr>
	<tr>
	<td>Ð</td>
	<td>D</td>
</tr>
<tr>
	<td>Ñ</td>
	<td>N</td>
</tr>
<tr>
	<td>ÒÓÔÕÖØ</td>
	<td>O</td>
</tr>
	<tr>
	<td>ÙÚÛÜ</td>
	<td>U</td>
</tr>
	<tr>
	<td>ŸÝ</td>
	<td>Y</td>
</tr>
<tr>
	<td>Þ</td>
	<td>Th</td>
</tr>
<tr>
	<td>ß</td>
	<td>ss</td>
</tr>
<tr>
	<td>àáâãäå</td>
	<td>a</td>
</tr>
	<tr>
	<td>æ</td>
	<td>ae</td>
</tr>
<tr>
	<td>ç</td>
	<td>c</td>
</tr>
<tr>
	<td>èéêë</td>
	<td>e</td>
</tr>
	<tr>
	<td>ìíîï</td>
	<td>i</td>
</tr>
	<tr>
	<td>ð</td>
	<td>d</td>
</tr>
<tr>
	<td>ñ</td>
	<td>n</td>
</tr>
<tr>
	<td>òóôõöø</td>
	<td>o</td>
</tr>
	<tr>
	<td>ùúûü</td>
	<td>u</td>
</tr>
	<tr>
	<td>ýÿ</td>
	<td>y</td>
</tr>
<tr>
	<td>þ</td>
	<td>th</td>
</tr>
</table>
	 * @param str Cadena de texto
	 * @return Una cadena con los caracteres reemplazados.
	 * @source Basado en el siguiente artículo [http://stackoverflow.com/questions/587242/replacing-accents-w-their-counterparts-in-as3]
	 */
	public static function decomposeUnicode(str :String) :String
	{
		var i :int = UNICODE_CHARS.length;

		while(--i > -1)
		{
			str = str.replace( new RegExp(UNICODE_CHARS[i], "g"), DECOMPOSED_CHARS[i]);
		}
		return str;
	}
}
}