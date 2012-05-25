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

package jp.raohmaru.toolkit.motion
{

/**
 * Esta clase representa el bote donde almacenar las instancias de la especia PaprikaSpice, reservándolas en memoria, reutilizándolas y creando nuevas
 * instancias sólo cuando es necesario.
 * @author raohmaru
 * @source Basado en la clase com.flashdynamix.utils.ObjectPool de Shane McCartney [http://www.lostinactionscript.com/blog/index.php]
 */
public class PaprikaPot
{
	internal var size :int,
				 length :int;
	private var _list :Array = [];


	/**
	 * Crea un nuevo objeto PaprikaPot. La primera vez que se llama al método <code>Paprika.add()</code> se crea una instancia de PaprikaPot
	 * para almacenar la especia.
	 */
	public function PaprikaPot()
	{
	}

	/**
	 * Obtiene una nueva instancia de la clase PaprikaSpice. Si no ha objetos disponibles se crea uno nuevo y se aumenta el tamaño de la rerserva.
	 * @return Una instancia de PaprikaSpice.
	 */
	public function retrieve() :PaprikaSpice
	{
		if(length == 0)
		{
			size++;
			return new PaprikaSpice();
		}

		return _list[--length];
	}

	/**
	 * Deposita un objeto, guardándolo en memoria para que vuelva a ser utilizado.
	 * @param item Una instancia de PaprikaSpice limpia de referencias.
	 */
	public function drop(item :PaprikaSpice) :void
	{
		_list[length++] = item;
	}

	/**
	 * Vacía la lista interna de objetos, liberando memoria.
	 */
	public function empty() :void
	{
		size = length = _list.length = 0;
	}
}
}