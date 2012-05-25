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
import flash.net.navigateToURL;
import flash.net.URLRequest;

/**
 * Conjunto de utilidades para la navegación web y los métodos HTTP.
 * @author raohmaru
 */
public class WebUtil
{
	/**
	* Implementa el método getURL previo a AS3.
	* @param url Dirección URL
	* @param window Ventana de destino
	* @author Trevor McCauley (http://www.senocular.com/)
	*/
    public static function getURL(url:String, window:String = "_self") : void
    {
        var req:URLRequest = new URLRequest(url);

        try
        {
            navigateToURL(req, window);
        }
        catch (e:Error)
        {
            trace("Navigate to URL failed ", e.message);
        }
    }

	/**
	* Devuelve una variable get con un valor aleatorio para evitar que se caché una URL.
	* @param delim Caracter separador que irá delante de la cadena resultante
	* @return String
	* @example <listing version="3.0">Web.noCache("&amp;");      // "&amp;nch=485548752659"</listing>
	*/
    public static function noCache(delim : String = "?") : String
    {
    	return delim + "nch=" + noCacheNum();
    }

	/**
	* Devuelve un valor aleatorio que ha de añadirse al final de una petición URL para evitar que se caché.
	* @return uint
	*/
    public static function noCacheNum() : uint
    {
    	return Math.random()*1000000000000;
    }
}
}
