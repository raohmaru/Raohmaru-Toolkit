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

package jp.raohmaru.toolkit.net
{
/**
 * La clase Asset representa objeto de recurso utilizado en la lista de descarga de un objeto AssetLoader.
 * @author raohmaru
 */
public class Asset
{
	/**
	 * La URL que señala a un archivo externo o a un origen de datos.
	 */
	public var url :String;
	/**
	 * Nombre identificativo para el recurso.
	 */
	public var name :String;
	/**
	 * Valía del recurso para que éste ocupe un rango mayor en la propiedad <code>AssetLoader.overallProgress</code>.
	 * @see jp.raohmaru.toolkit.net.AssetLoader#overallProgress
	 * @default 1
	 */
	public var importance :Number;
	/**
	 * Un valor que define el tipo de recurso a descargar. Los posibles valores son:
	 * <ul><li>AssetLoader.FILE (un archivo)</li>
	 * <li>AssetLoader.DATA (un origen de datos, p. ej. un archivo XML)</li></ul>
	 * @default AssetLoader.FILE
	 */
	public var type :String;
	/**
	 * Indica si los datos descargados deben guardarse en memoria.
	 * @default true
	 */
	public var save :Boolean;
	/**
	 * @private
	 */
	internal var scale :Number;

	/**
	 * Crea un nuevo objeto Asset con los parámetros especificados.
	 * @param url La URL que señala a un archivo externo o a un origen de datos.
	 * @param name Nombre identificativo para el recurso.
	 * @param importance Valía del recurso para que éste ocupe un rango mayor en la propiedad <code>overallProgress</code>.
	 * @param type Un valor que define el tipo de recurso a descargar. Los posibles valores son:
	 * <ul><li>AssetLoader.FILE (un archivo)</li>
	 * <li>AssetLoader.DATA (un origen de datos, p. ej. un archivo XML)</li></ul>
	 */
	public function Asset(url :String, name :String, importance :Number=1, type :String="file", save: Boolean=true)
	{
		this.url = url;
		this.name = name;
		this.importance = importance;
		this.scale = importance;
		this.type = type;
		this.save = save;
	}

	/**
	 * Crea una copia del objeto Asset y define el valor de cada parámetro para que coincida con el original.
     * @return Copia de la instancia de Asset actual.
	 */
	public function clone() :Asset
	{
		return new Asset(url, name, importance, type, save);
	}
}
}