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

/**
 * La clase FormType es una enumeración de valores constantes empleados en la restricción y validación de formularios.
 * @author raohmaru
 */
public class FormElementType
{
	/**
	 * Define un campo de formulario como del tipo e-mail.
	 */
	public static const EMAIL : String = "email";
	/**
	 * Define un campo de formulario como del tipo texto.
	 */
	public static const TEXT : String = "text";
	/**
	 * Define un campo de formulario como del tipo numérico.
	 */
	public static const NUMBER : String = "number";
	/**
	 * Define un campo de formulario como del tipo código postal.
	 */
	public static const POSTAL_CODE : String = "postal_code";
	/**
	 * Define un campo de formulario como del tipo número de móvil.
	 */
	public static const MOBILE : String = "mobile";
	/**
	 * Define un campo de formulario como del tipo número de teléfono.
	 */
	public static const PHONE : String = "phone";
	/**
	 * Define un campo de formulario como del tipo número de teléfono o de móvil.
	 */
	public static const PHONE_MOBILE : String = "phone_mobile";
	/**
	 * Define un campo de formulario como del tipo DNI / NIE.
	 */
	public static const DNI : String = "dni";
	/**
	 * Define un campo de formulario como del tipo CIF.
	 */
	public static const CIF : String = "cif";
	/**
	 * Define que un campo de formulario debe validarse comparándose a otro.
	 */
	public static const CONFIRM : String = "confirm";
	/**
	 * Define un campo de formulario como del tipo contraseña.
	 */
	public static const PASSWORD : String = "password";
	/**
	 * Define que debe validarse si el usuario es mayor de edad según la entrada de datos.
	 */
	public static const AGE : String = "age";
	/**
	 * Define un campo de formulario como del tipo fecha.
	 */
	public static const DATE : String = "date";
}
}