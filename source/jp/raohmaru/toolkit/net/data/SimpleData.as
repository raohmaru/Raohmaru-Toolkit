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

package jp.raohmaru.toolkit.net.data
{
import flash.events.EventDispatcher;

/**
 * La clase SimpleData es un contenedor de datos genéricos para compartir datos en tiempo de ejecución dentro del ámbito de una aplicación.
 * Su verdadera naturaleza es ser heredada en otros tipos de clase que extiendan su funcionalidad, actuando SimpleData como una clase abstracta.
 * @author raohmaru
 */
public class SimpleData extends EventDispatcher
{
	/**
	 * @private
	 */
	protected var _data :*;

	/**
	 * Obtiene un referencia o define el objeto que se almacena en la instancia de SimpleData.
	 */
	public function get data() :*
	{
		return _data;
	}
	public function set data(value :*) :void
	{
		_data = value;
	}

	/**
	 * Tamaño de los datos almacenados. Es un método abstracto y debe definirse en las clases descendientes. Siempre retorna <code>0</code>.
	 */
	public function get length() :uint
	{
		return 0;
	}


	/**
	 * Crea una nueva instancia de la clase SimpleData.
	 */
	public function SimpleData ()
	{
	}

	/**
	 * Crea una representación de cadena de los datos contenidos en el proveedor de datos.
	 */
	override public function toString() :String
	{
		return _data.toString();
	}
}
}
