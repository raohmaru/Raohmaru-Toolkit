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
import flash.text.TextField;

/**
 * La clase FormValidate valida datos de entrada de formulario, del tipo TextField.
 * @author raohmaru
 */
public class FormValidate
{
	private static const	NIF_STRING :String = "TRWAGMYFPDXBNJZSQVHLCKET",
            				NIE_MAX_CHARS :uint = 10;

	private static var _passwordMinLength :uint = 4;

	/**
	 * Establece la longitud mínima para un campo de contraseña. El valor por defecto es 4.
	 * @see #validatePassword()
	 */
	public static function get passwordMinLength() :uint
	{
		return _passwordMinLength;
	}

	public static function set passwordMinLength(value :uint) :void
	{
		_passwordMinLength = value;
	}


	/**
	 * Comprueba que la cadena de texto no esté vacía.
	 * @param str Cadena a comprobar.
	 * @return Obtiene <code>true</code> si está vacía, <code>false</code> en caso contrario.
	 */
	public static function isEmpty(str :String) :Boolean
	{
		return (str == null || str == "" || str.replace(/ /g, "").length == 0);
	}

	/**
	 * Comprueba que la cadena de texto sea un valor numérico válido.
	 * @param str Cadena a comprobar.
	 * @return Obtiene <code>true</code> si es un número, <code>false</code> en caso contrario.
	 */
	public static function isNumber(str :String) :Boolean
	{
		return (str.replace(/\d|\.|-|\+/g, "").length == 0);
	}

	/**
	 * Valida un elemento según el tipo especificado.
	 * @param str Cadena de texto a validar
	 * @param type El tipo de validación que se ejecutará
	 * @param element Un objeto TextField para una validación del tipo FormType.CONFIRM
	 * @return El resultado de la validación
	 * @see jp.raohmaru.toolkit.form.FormType
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.form.FormType;
	import jp.raohmaru.toolkit.form.Form;<br>
	Form.validateElement("test&#64;example.org", FormType.EMAIL);</listing>
	 */
	public static function validateElement(str :String, type :String, element :TextField = null) :Boolean
	{
		switch(type)
		{
			case FormElementType.EMAIL:
				return validateEmail(str);

			case FormElementType.NUMBER:
				return isNumber(str);

			case FormElementType.POSTAL_CODE:
				return validatePostalCode(str);

			case FormElementType.MOBILE:
				return validateMobile(str);

			case FormElementType.PHONE:
				return validatePhone(str);

			case FormElementType.PHONE_MOBILE:
				return validatePhone(str) || validateMobile(str);

			case FormElementType.DNI:
				return validateNIF(str);

			case FormElementType.CIF:
				return validateCIF(str);

			case FormElementType.PASSWORD:
				return validatePassword(str);

			case FormElementType.CONFIRM:
				return confirmFields(element);

			case FormElementType.DATE:
				return validateDate(str);
		}

		return true;
	}

	/**
	 * Valida que una cadena de texto tenga formato de un e-mail.
	 * @param str Cadena que contiene un e-mail
	 * @return El resultado de la validación
	 */
	public static function validateEmail(str :String) :Boolean
	{
		var re :RegExp = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$/i;
		return (re.test(str));
	}

	/**
	 * Valida que una cadena de texto tenga formato de código postal (para el ámbito español).
	 * @param str Cadena que contiene un número de código postal
	 * @return El resultado de la validación
	 */
	public static function validatePostalCode(str :String) :Boolean
	{
		var cpNumber :Number = parseInt(str, 10);
		return !(isNaN(cpNumber) || str.length < 5 || cpNumber < 1001 || cpNumber > 52999 || str.substr(2, 5) == "000");
	}

	/**
	 * Valida que una cadena de texto tenga formato de móvil (para el ámbito español, esto es, que empiece por 6).
	 * @param str Cadena que contiene un número de móvil
	 * @return El resultado de la validación
	 */
	public static function validateMobile(str :String) :Boolean
	{
		return /^6\d{8}/.test(str);
	}

	/**
	 * Valida que una cadena de texto tenga formato de número de teléfono (para el ámbito español, esto es, que empiece por 8 ó 9).
	 * @param str Cadena que contiene un número teléfono
	 * @return El resultado de la validación
	 */
	public static function validatePhone(str :String) :Boolean
	{
		return /^[89]\d{8}/.test(str);
	}

	/**
	 * Comprueba si el numero de NIE o NIF es correcto y la última letra corresponde con el número.
	 * @param nif Una cadena con el numero de nie ((X || T)  + 8 numeros + una letra) o nif (8 numeros + una letra)
	 * @return Boolean
	 *
	 * @author Nahuel Scotti - nahuel.scotti@gmail.com
	 * @author SinguerInc - info@singuerinc.com
	 */
	public static function validateNIF(str :String) :Boolean
	{
		str = str.toUpperCase();

		//Verifico si es un nie o nif
		var isNie :Boolean = (str.indexOf("X") == 0 || str.indexOf("T") == 0);

		if(str.length < NIE_MAX_CHARS - 1) return false;

		if(isNie)
		{
			//verifico si es un nie con 8 numeros y lo convierto en nif
			if(str.length == NIE_MAX_CHARS)
				str = str.substr(1, 9);

			//verifico si es un nie con 7 numeros y lo convierto en nif
			else if (str.length == NIE_MAX_CHARS - 1)
				str = "0" + str.substring(1, str.length);
		}
   		else
		{
			//Si es nif compruebo que el primer caracter no sea una letra,
			//porque tal vez es un nie pero con una primea letra erronea.
			if(int(str.charAt(0)) is Number != true)
				return false;
		}

		var regExp :RegExp = /([0-9]{8})[A-Za-z]{1}/;
		if(!regExp.test(str)) return false;

		var input_nifLetter :String = str.charAt(str.length - 1);
		if(getNIF_letterFromDNI(str.substr(0, 8)) != input_nifLetter) return false;

		return true;
	}

	/**
	 * Comprueba si el numero de CIF es correcto.
	 * @param nif Una cadena con el numero de CIF.
	 * @return Boolean Un valor booleano que representa la validez del número CIF.
	 *
	 * @author Javier Vicente Medina - http://blog.xavirobot.com/validador-de-nif-cif-y-nie/
	 */
	public static function validateCIF(str :String) :Boolean
	{
		str = str.toUpperCase();
		var pares :int,
			impares :int,
			suma :String,
			ultima :String,
			unumero :int,
			uletra :Array = ["J","A","B","C","D","E","F","G","H","I"],
			xxx :String;
		
		if( !(/^[ABCDEFGHJKLMNPQS]\d{7}[0-9,A-J]$/g).exec(str) )
			return false;
		
		ultima = str.substr(8,1);
		for(var i :int=1; i<7; i++)
		{
			xxx = (2 * parseInt(str.substr(i++, 1))) + "0";
			impares += parseInt(xxx.substr(0, 1)) + parseInt(xxx.substr(1, 1));
			pares += parseInt(str.substr(i, 1));
		}
		xxx = (2 * parseInt(str.substr(i, 1))) + "0";
		impares += parseInt(xxx.substr(0, 1)) + parseInt(xxx.substr(1, 1));
		suma = (pares + impares).toString();
		unumero = 10 - parseInt(suma.substr(suma.length-1, 1));
		if(unumero == 10)
			unumero = 0;
		
		if((ultima == String(unumero)) || (ultima == uletra[unumero]))
			return true;
		
		return false;
	}

	/**
	 * Valida la longitud de un password contrastada con passwordMinLength.
	 * @param str Cadena de texto
	 * @return El resultado de la validación
	 * @see #passwordMinLength
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.form.Form;<br>
	Form.passwordMinLength = 6;
	Form.validatePassword("sun"); // false</listing>
	 */
	public static function validatePassword(str :String) :Boolean
	{
		return (str.length >= _passwordMinLength);
	}

	/**
	 * Valida que el contenido de un objeto TextField con nombre acabado en "_confirm" sea igual al de otro TextField sin la coletilla "_confirm" en el nombre.
	 * @param Objeto TextField a validar
	 * @return El resultado de la validación
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.form.FormType;
	import jp.raohmaru.toolkit.form.Form;
	import flash.text.TextField;<br>
	var city : TextField = new TextField();
	city.name = "city";
	city.text = "Berna";
	var city_confirm : TextField = new TextField();
	city_confirm.name = "city_confirm";
	city_confirm.text = "Zurich";
	Form.confirmFields(city); // false</listing>
	 */
	public static function confirmFields(element :TextField) :Boolean
	{
		var orig_tf :TextField = element.parent[element.name.substring(0, element.name.indexOf("_confirm"))];
		if(!orig_tf) return false;

		return orig_tf.text == element.text;
	}

	/**
	 * Valida que la fecha de nacimiento corresponda a una persona mayor de edad (en España mayor de 18 años).
	 * @param birth Objeto Date que contiene una fecha de nacimiento
	 * @param now Un valor para la fecha actual, que se utilizará para validar contra la fecha de nacimiento. Por defecto será la fecha del ordenador del usuario.
	 * @return El resultado de la validación (<code>true</code> si es mayor de edad).
	 */
	public static function validateAge(birth :Date, now :Date = null, age :uint = 18) :Boolean
	{
		if(!now) now = new Date();
		return (new Date(now.time - birth.time).fullYear - new Date(0).fullYear >= age);
	}

	/**
	 * Valida que la una fecha sea correcta y coincida con el patrón especificado. Los caracteres especiales deben ir separados entre ellos por el mismo
	 * caracter separador, y los grupos de caracteres especiales deben ir separados por un espacio.
	 * Caracteres especiales:<br><br>
<table class="innertable">
<tr>
	<th width="84"><b>Caracter especial</b></th>
	<th width="391">Descripción</th>
</tr>
<tr>
	<td><b>d</b></td>
	<td>Día del mes sin ceros iniciales</td>
</tr>
<tr>
	<td><b>dd</b></td>
	<td>Día del mes con ceros iniciales</td>
</tr>
<tr>
	<td><b>m</b></td>
	<td>Representación numérica de un mes, sin ceros iniciales</td>
</tr>
<tr>
	<td><b>mm</b></td>
	<td>Representación numérica de un mes, con ceros iniciales</td>
</tr>
<tr>
	<td><b>yy</b></td>
	<td>Una representación de dos dígitos de un año</td>
</tr>
<tr>
	<td><b>yyyy</b></td>
	<td>Una representación numérica completa de un año</td>
</tr>
<tr>
	<td><b>H</b></td>
	<td>Formato de 24-horas de una hora sin ceros iniciales</td>
</tr>
<tr>
	<td><b>HH</b></td>
	<td>Formato de 24-horas de una hora con ceros iniciales</td>
</tr>
<tr>
	<td><b>M</b></td>
	<td>Minutos sin ceros iniciales</td>
</tr>
<tr>
	<td><b>MM</b></td>
	<td>Minutos con ceros iniciales</td>
</tr>
<tr>
	<td><b>S</b></td>
	<td>Segunds sin ceros iniciales</td>
</tr>
<tr>
	<td><b>SS</b></td>
	<td>Segunds con ceros iniciales</td>
</tr>
</table>
	 * @param str Cadena a comprobar.
	 * @param format El patrón que debe seguir la cadena.
	 * @return El resultado de la validación.
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.form.FormValidate;

	FormValidate.validateDate("01/01/1988");  // true	FormValidate.validateDate("1/10/95", "d/m/yy");  // true	FormValidate.validateDate("01-31-1288 22:50:31", "mm-dd-yyyy HH:MM:SS");  // true
	</listing>
	 */
	public static function validateDate(str :String, format :String = "dd/mm/yyyy") :Boolean
	{
		var delimiters :Array,
			patterns :Array = format.split(" "),
			values :Array = str.split(" ");

		// Obtiene los delimitadores de cada grupo de caracteres especiales
		for(var i:int=0; i<patterns.length; i++)
		{
			delimiters = patterns[i].match(/[dmyHMS]+(\W+)[dmyHMS]+/);
			if(delimiters)
			{
				patterns[i] = patterns[i].split(delimiters[1]);
				values[i] =  values[i].split(delimiters[1]);

				if(patterns.length != values.length) return false;
			}
			else
			{
				return false;
			}
		}

		var validated :Boolean,
			s :String,
			type :String;

		for(i=0; i<patterns.length; i++)
		{
			for(var j:int=0; j<patterns[i].length; j++)
			{
				validated = false;
				type = patterns[i][j];
				s = values[i][j];

				if( (type.length == 1 && (s.length != 1 && s.length != 2)) || (type.length > 1 && type.length != s.length) ) return false;

				switch(type)
				{
					case "d":
					case "dd":
	        			if(type.length == 1 && s.length == 1)
	        			{
	        				if( !(/[1-9]/).test(s) ) return false;
	        			}
	        			else if(!( /(0[1-9])|([12][0-9])|(3[01])/.test(s) ) )
	        			{
	        				return false;
	        			}

						validated = true;
						break;

					case "m":
					case "mm":
	        			if(type.length == 1 && s.length == 1)
	        			{
	        				if( !(/[1-9]/).test(s) ) return false;
	        			}
	        			else if(!( /(0[1-9])|(1[0-2])/.test(s) ) )
	        			{
	        				return false;
	        			}

						validated = true;
						break;

					case "yy":
						if(!( /\d{2}/.test(s) ) ) return false;
						validated = true;
						break;

					case "yyyy":
						if(!( /\d{4}/.test(s) ) ) return false;
						validated = true;
						break;

					case "H":
					case "HH":
	        			if(type.length == 1 && s.length == 1)
	        			{
	        				if( !(/\d/).test(s) ) return false;
	        			}
	        			else if(!( /([01]\d)|(2[0-3])/.test(s) ) )
	        			{
	        				return false;
	        			}

						validated = true;
						break;

					case "M":
					case "MM":
					case "S":
					case "SS":
	        			if(type.length == 1 && s.length == 1)
	        			{
	        				if( !(/\d/).test(s) ) return false;
	        			}
	        			else if(!( /([0-4]\d)|(5[0-9])/.test(s) ) )
	        			{
	        				return false;
	        			}

						validated = true;
						break;
				}

				if(!validated ) return false;
			}
		}

		return true;
	}



	/**
	 * Utilizando el DNI devuelve la última letra que le corresponde al NIF.
	 * @author Nahuel Scotti - nahuel.scotti@gmail.com
	 * @author SinguerInc - info@singuerinc.com
	 * @param dni Una cadena de 8 numeros
	 * @return String Una letra correspondiente a la ultima letra del NIF
	 */
	private static function getNIF_letterFromDNI(dni :String) :String
	{
		var charIndex :int = int(dni.substr(0, 8)) % 23;

		return (NIF_STRING.charAt(charIndex)).toUpperCase();
	}
}
}