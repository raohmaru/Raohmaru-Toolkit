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

package jp.raohmaru.toolkit.net.data
{

/**
 * La clase XMLData hereda de ExternalData la funcionalidad de carga de datos externos y añade la naturaleza de XML al tipo de datos almacenados.
 * @author raohmaru
 */
public class XMLData extends ExternalData
{
	/**
	 * Obtiene una copia del objeto XML de datos interno.
	 */
	override public function get data() : *
	{
		return (_data) ? XML(_data).copy() : null;
	}

	/**
	 * Crea un objeto XMLData.
	 */
	public function XMLData()
	{
		XML.ignoreWhitespace = true;
	}

	/**
	 * @inheritDoc
	 */
	override public function toString() : String
	{
		return XML(_data).toXMLString();
	}
}
}