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
 * Conjunto de métodos que extienden la funcionalidad de la clase XML
 * @author raohmaru
 */
public class XMLUtil
{
	/**
	 * Serializa un objeto y devuelve un XML con las propiedades del objeto como pares nodo / valor.
	 * @param source Objeto origen a serializar	 * @param rootNodeName Nombre del nodo principal del XML resultante
	 * @param ns Un nombre de espacios a asignar al XML resultante
	 * @return Un objeto XML creado a partir del objeto especificado
	 * @example El siguiente ejemplo muestra como se serializa un objeto que contiene otro objeto y una matriz:
	<listing version="3.0">
	import jp.raohmaru.toolkit.utils.XMLUtil;	var weapons :Object = {
		first : "sword",
		second : "bow",
		shield : false
	}
	var o :Object = {
		name : "Aloê",
		age : 55,
		status : "medium",
		pow : [100, 1290],
		weapons : weapons
	};

	var ns :Namespace = new Namespace("rol", "http://example.org/2012/test")
	var xml :XML = XMLUtil.serialize(o, "character", ns);
	trace( xml.toXMLString() );
	// Outputs:	// &lt;rol:character xmlns:rol=&quot;http://example.org/2012/test&quot;&gt;
	//   &lt;rol:pow&gt;
	//     &lt;rol:0&gt;100&lt;/rol:0&gt;
	//     &lt;rol:1&gt;1290&lt;/rol:1&gt;
	//   &lt;/rol:pow&gt;
	//   &lt;rol:status&gt;medium&lt;/rol:status&gt;
	//   &lt;rol:weapons&gt;
	//     &lt;rol:second&gt;bow&lt;/rol:second&gt;
	//     &lt;rol:shield&gt;false&lt;/rol:shield&gt;
	//     &lt;rol:first&gt;sword&lt;/rol:first&gt;
	//   &lt;/rol:weapons&gt;
	//   &lt;rol:name&gt;Aloê&lt;/rol:name&gt;
	//   &lt;rol:age&gt;55&lt;/rol:age&gt;
	// &lt;/rol:character&gt;	trace( xml.ns::status );  // medium
	</listing>
	 */
	public static function serialize(source :Object, rootNodeName :String, ns :Namespace = null) :XML
	{
		var xml :XML = new XML(<{rootNodeName}></{rootNodeName}>),
			count :int = 0;

		for(var i:String in source)
		{
			xml.appendChild( serialize(source[i], i, ns) );
			count++;
		}

		if(count == 0) xml = new XML(<{rootNodeName}>{source}</{rootNodeName}>);

		if(ns) xml.setNamespace(ns);

		return xml;
	}

	/**
	 * Comprueba si el objeto XML o XMLList contiene un nodo del nombre especificado.
	 * @param xml Un objeto XML o XMLList.
	 * @param name El nombre del nodo secundario.
	 * @return Un valor booleano, verdadero si lo contiene y falso en caso contrario.
	 */
	public static function hasNode(xml :Object, name :String) :Boolean
	{
		if( !(xml is XML) && !(xml is XMLList) ) return false;

		return (xml[name].length() > 0);
	}

	/**
	 * Comprueba si el objeto XML o XMLList contiene un atributo del nombre especificado.
	 * @param xml Un objeto XML o XMLList.
	 * @param name El nombre del atributo.
	 * @return Un valor booleano, verdadero si lo contiene y falso en caso contrario.
	 */
	public static function hasAttribute(xml :Object, name :String) :Boolean
	{
		if( !(xml is XML) && !(xml is XMLList) ) return false;

		return (xml.@[name].length() > 0);
	}

	/**
	 * Comprueba si el objeto XML existe, es decir, si es un nodo real de un XML padre.
	 * @param xml Un objeto XML o XMLList.
	 * @return Un valor booleano, verdadero si lo existe y falso en caso contrario.
	 */
	public static function exists(xml :Object) :Boolean
	{
		if( !(xml is XML) && !(xml is XMLList) ) return false;

		//return (xml.text().length() > 0 || xml.attributes().length() > 0 || xml.hasComplexContent());
		// Simple pero eficaz
		return (xml.toXMLString() != "");
	}


	/**
	 * Ordena los elementos secundarios del objeto XML según el valor de un nodo o de un atributo específico.
	 * @param xml Un objeto XML.
	 * @param childOrAttributeName Nombre de un elemento secundario o de un atributo, cuyos valores se utilizarán para ordenar los elementos secundarios del objeto XML.
	 * @param arraySortArgs Uno o más números o nombres de constantes definidas, separados por el operador bitwise OR (|) (OR en modo bit) que cambian el comportamiento de la ordenación. Estos son los valores válidos:
<UL><LI><CODE>Array.CASEINSENSITIVE</CODE> o 1 </LI>
<LI><CODE>Array.DESCENDING</CODE> o 2 </LI>
<LI><CODE>Array.UNIQUESORT</CODE> o 4 </LI>
<LI><CODE>Array.RETURNINDEXEDARRAY</CODE> u 8 </LI>
<LI><CODE>Array.NUMERIC</CODE> o 16 </LI></UL>
	 * @return Un nuevo objeto XML ordenado.
	 * @see Array#sortOn()
	 * @example El siguiente ejemplo muestra como se ordenan los elementos secundarios de un objeto XML utilizando <code>XMLUtil.sortXml</code>:
<listing version="3.0">
import jp.raohmaru.toolkit.utils.XMLUtil;

var xml :XML = &lt;root&gt;
	&lt;row order="5" state="a"&gt;
		&lt;Puntuacion&gt;28&lt;/Puntuacion&gt;
	&lt;/row&gt;
	&lt;row order="2" state="h"&gt;
		&lt;Puntuacion&gt;0&lt;/Puntuacion&gt;
	&lt;/row&gt;
	&lt;row order="56" state="c"&gt;
		&lt;Puntuacion&gt;50&lt;/Puntuacion&gt;
	&lt;/row&gt;
	&lt;row order="111" state="z"&gt;
		&lt;Puntuacion&gt;122&lt;/Puntuacion&gt;
	&lt;/row&gt;
&lt;/root&gt;;

// Ordena os elementos secundarios del objeto XML según el elemento &lt;Puntuacion&gt;
trace( XMLUtil.sortXml(xml, "Puntuacion", Array.NUMERIC | Array.DESCENDING) );
// Ordena os elementos secundarios del objeto XML según el atributo "state"
trace( XMLUtil.sortXml(xml, "&#64;state",  Array.DESCENDING) );
</listing>
	 */
	public static function sortXml(xml :XML, childOrAttributeName :String, arraySortArgs :*=0) :XML
	{
		var len :uint = xml.children().length();

		if( len == 0 )
			return xml;

		if( len > 1 )
		{
			var arr :Array = [],
				node :XML,
				children :XMLList = xml.children().copy(),
				child :String = childOrAttributeName,
				isAttr :Boolean = (childOrAttributeName.indexOf("@") != -1);
			if(isAttr)
			{
				var attribute :String = childOrAttributeName.substr(1);
				child = child.substring(1) + "__sort";
			}

			for each (node in children)
			{
				if(isAttr)
					node.appendChild( <{ child }>{ node.attribute(attribute) }</{ child }> );
				arr.push(node);
			}

			arr.sortOn(child, arraySortArgs);
			xml = new XML(<root />);

			for(var i:int=0; i<arr.length; i++)
			{
				node = arr[i];
				if(isAttr)
					delete node[child];
				xml.appendChild( node );
			}
		}

		return xml;
	}
}
}