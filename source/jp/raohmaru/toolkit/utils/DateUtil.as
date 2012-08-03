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
 * Añade nuevas funcionalidades a la clase Date.
 * @see Date
 * @author raohmaru
 */
public class DateUtil
{
	private static const _months : Array = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"],
						 _days : Array = ["Domingo","Lunes","Martes","Miércoles","Jueves","Viernes","Sábado"];

	/**
	 * Devuelve el nombre de un mes según su representación númerica (0 -&gt; Enero, 1 -&gt; Febrero, etc.).
	 * @param m El índice del mes
	 * @return String El nombre del mes
	 */
	public static function monthStringify(m : Number) : String
	{
		return _months[m];
	}

	/**
	 * Devuelve el nombre de un día según su representación númerica (0 -&gt; Domingo, 1 -&gt; Lunes, etc.).
	 * @param d El índice del día
	 * @return String El nombre del día
	 */
	public static function dayStringify(d : Number) : String
	{
		return _days[d];
	}

	/**
	 * Convierte una cadena que representa una fecha UTC en un objeto Date UTC (hora universal).
	 * @param str Fecha en formato UTC ("1900-01-01T00:00:00")
	 * @return Date Nuevo objeto Date con al fecha en formato UTC
	 */
	public static function parseUTCTime(str : String) : Date
	{
		var utcdate : Array = str.split("T")[0].split("-"),
			utchour : Array = str.split("T")[1].split(":"),
			utcsecs : Array = utchour[2].split("."),
			date : Date = new Date();
			date.setUTCFullYear(utcdate[0], utcdate[1]-1, utcdate[2]);
			date.setUTCHours(utchour[0], utchour[1], utcsecs[0], 0);

		return date;
	}

	/**
	 * Devuelve una cadena de texto con la fecha formateada según el patrón especificado.
	 * Todas las coincidencias se cambiarán por el valor que representan:<br><br>
<table class="innertable">
<tr>
	<th width="64"><b>Patrón</b></th>
	<th width="411">Descripción</th>
	<th width="68">Ejemplo</th>
</tr>
<tr>
	<td><b>MER</b></td>
	<td>Ante meridiano y Post meridiano en mayúsculas </td>
	<td>AM o PM </td>
</tr>
<tr>
	<td><b>MER</b></td>
	<td>Ante meridiano y Post meridiano en minúsculas</td>
	<td>am o pm </td>
</tr>
<tr>
	<td><b>HH</b></td>
	<td>Formato de 24-horas de una hora con ceros iniciales</td>
	<td>00 a 23</td>
</tr>
<tr>
	<td><b>H</b></td>
	<td>Formato de 24-horas de una hora sin ceros iniciales</td>
	<td>0 a 23</td>
</tr>
<tr>
	<td><b>hh</b></td>
	<td>Formato de 12-horas de una hora con ceros iniciales</td>
	<td>00 a 12 </td>
</tr>
<tr>
	<td><b>h</b></td>
	<td>Formato de 12-horas de una hora sin ceros iniciales</td>
	<td>0 a 12 </td>
</tr>
<tr>
	<td><b>MM</b></td>
	<td>Minutos con ceros iniciales</td>
	<td>00 a 59</td>
</tr>
<tr>
	<td><b>M</b></td>
	<td>Minutos sin ceros iniciales</td>
	<td>0 a 59</td>
</tr>
<tr>
	<td><b>SS</b></td>
	<td>Segundos con ceros iniciales</td>
	<td>00 a 59</td>
</tr>
<tr>
	<td><b>S</b></td>
	<td>Segunds sin ceros iniciales</td>
	<td>0 a 59</td>
</tr>
<tr>
	<td><b>ms</b></td>
	<td>Milisegundos</td>
	<td>54321</td>
</tr>
<tr>
	<td><b>Day</b></td>
	<td>Una representación textual de un día, la primera letra en mayúscula </td>
	<td>Lunes</td>
</tr>
<tr>
	<td><b>day</b></td>
	<td>Una representación textual de un día</td>
	<td>lunes</td>
</tr>
<tr>
	<td><b>dd</b></td>
	<td>Día del mes con ceros iniciales</td>
	<td>01 a 31</td>
</tr>
<tr>
	<td><b>d</b></td>
	<td>Día del mes sin ceros iniciales</td>
	<td>1 a 31</td>
</tr>
<tr>
	<td><b>Month</b></td>
	<td>Una representación textual de un mes, la primera letra en mayúscula</td>
	<td>Agosto</td>
</tr>
<tr>
	<td><b>month</b></td>
	<td>Una representación textual de un mes</td>
	<td>agosto</td>
</tr>
<tr>
	<td><b>Mon</b></td>
	<td>Las tres primeras letras del nombre de un mes, la primera letra mayúscula</td>
	<td>Feb</td>
</tr>
<tr>
	<td><b>mon</b></td>
	<td>Las tres primeras letras del nombre de un mes</td>
	<td>feb</td>
</tr>
<tr>
	<td><b>mm</b></td>
	<td>Representación numérica de un mes, con ceros iniciales</td>
	<td>01 a 12 </td>
</tr>
<tr>
	<td><b>m</b></td>
	<td>Representación numérica de un mes, sin ceros iniciales</td>
	<td>1 a 12 </td>
</tr>
<tr>
	<td><b>yyyy</b></td>
	<td>Una representación numérica completa de un año</td>
	<td>2012</td>
</tr>
<tr>
	<td><b>yy</b></td>
	<td>Una representación de dos dígitos de un año</td>
	<td>08</td>
</tr>
</table><br>
	 * Este método se inspira en la función de PHP <code>date()</code>.
	 * @param format Formato de la cadena de salida
	 * @param date Objeto Date del que se devolverá una representación de cadena
	 * @param utc Indica si la cadena de salida ha de estar en la hora universal (UTC)
	 * @param L_CHAR Caracter izquierdo de separación de coincidencias de patrón. Si tanto <code>L_CHAR</code> y <code>R_CHAR</code> son iguales a "%", y en la cadena
	 * de formato no hay ningún caracter "%", se considerará que no hay caracter de separación entre patrones
	 * (<code>DateUtil.toFormattedTime("yyyy-mm-dd HH:MM:SS")</code> dará como resultado "2012-12-11 17:35:36")
	 * @param R_CHAR Caracter derecho de separación de coincidencias de patrón.
	 * @see http://es2.php.net/date
	 * @example
	<listing version="3.0">
	import jp.raohmaru.toolkit.utils.DateUtil;

	DateUtil.toFormattedTime("%Day% %d% de %Month% de %yyyy%");  // Lunes 1 de Diciembre de 2012</listing>
	 */
	public static function toFormattedTime(format :String, date :Date = null, utc :Boolean = false, L_CHAR :String = "%", R_CHAR :String = "%") :String
	{
		if(!date) date = new Date();

		var dia_semana :Number =		utc ? date.getUTCDay() : date.getDay(),
			dia_semana_name :String =	dayStringify(dia_semana),

			dia :Number =				utc ? date.getUTCDate() : date.getDate(),  //obtengo el día del mes

			mes :Number =				utc ? date.getUTCMonth() : date.getMonth(),
			mes_name :String =			monthStringify(mes),

			anno :Number =				utc ? date.getUTCFullYear() : date.getFullYear(),

			hora :Number =				utc ? date.getUTCHours() : date.getHours(),
			hora12 :Number =			(hora > 12) ? hora-12 : hora,
			minutos :Number =			utc ? date.getUTCMinutes() : date.getMinutes(),
			segundos :Number =			utc ? date.getUTCSeconds() : date.getSeconds();

		var pattern_object :Object =
		{
			MER:	(hora > 12) ? "PM" : "AM",
			mer:	(hora > 12) ? "pm" : "am",

			HH: 	StringUtil.toDigits(hora, 2),
			H: 		hora,
			hh: 	StringUtil.toDigits(hora12, 2),
			h: 		hora12,

			MM: 	StringUtil.toDigits(minutos, 2),
			M: 		minutos,

			SS: 	StringUtil.toDigits(segundos, 2),
			S: 		segundos,

			ms:		utc ? date.getMilliseconds() : date.getUTCMilliseconds(),

			Day:	dia_semana_name,
			day:	dia_semana_name.toLowerCase(),
			dd:		StringUtil.toDigits(dia, 2),
			d:		dia,

			Month:	mes_name,
			month:	mes_name.toLowerCase(),
			Mon:	mes_name.substr(0 ,3),			mon:	mes_name.toLowerCase().substr(0 ,3),
			mm:		StringUtil.toDigits(mes+1, 2),
			m:		(mes+1),

			yyyy:	anno,
			yy:		anno.toString().substr(2)
		};

		// Debido a que Flash desordena las claves de los objetos, creamos una matriz con el orden correcto
		var keys :Array = ["MER", "HH", "H", "hh", "h", "MM", "M", "SS", "S", "ms", "Day", "day", "dd", "d", "Month", "month", "Mon", "mon", "mm", "m", "yyyy", "yy"];

		// Si no hay ningún caracter de variable ("%"), se considera que todo es una plantilla (DateUtil.toFormattedTime("yyyy-mm-dd HH:MM:SS"))
		var wildcard :Boolean = true;
		if(L_CHAR == "%" && R_CHAR == "%" && format.indexOf("%") == -1)
		{
			L_CHAR = R_CHAR = "(\\b)";
			wildcard = false;
		}

		for(var i:int=0; i<keys.length; i++)
		{
			format = format.replace(	new RegExp(	L_CHAR+keys[i]+R_CHAR, "g"),
													(wildcard ? "" : "$1") + pattern_object[keys[i]] + (wildcard ? "" : "$2"));
		}

		return format;
	}

	/**
	 * Obtiene el número de la semana a partir de una fecha específica.
	 * @param date Objeto Date del que obtener el número de semana.
	 * @return int Un número que corresponde a la semana del año, según la fecha especificada.
	 * @author Michael Remy
	 * @source [http://board.flashkit.com/board/showthread.php?threadid=755170]
	 */
	public static function weekNumber(date :Date) :int
	{
		// 1 - CALC JULIAN DATE NUMBER (note: nothing to do with the Julian calendar)
		var wfullyear :int = date.getFullYear();
		var wmonth :int = date.getMonth() + 1;
		var wdate :int = date.getDate();
		//
		var wa :int = int((14 - wmonth) / 12);
		var wy :int = wfullyear + 4800 - wa;
		var wm :int = wmonth + 12 * wa - 3;

		// wJDN is the Julian Day Number
		var wJDN:int = wdate + int(((153 * wm) + 2) / 5) + wy * 365
		 + int(wy / 4)
		 - int(wy / 100)
		 + int(wy / 400) - 32045;

		// 2 - CALC WEEK NB
		var d4 :int = (((wJDN + 31741 - (wJDN % 7)) % 146097) % 36524) % 1461;
		var L :int = int(d4 / 1460);
		var d1 :int = ((d4 - L) % 365) + L;

		return int(d1 / 7) + 1;
	}

	/**
	 * Obtiene un objeto Date a partir de un año y un número de semana.
	 * @param year Dígito de 4 números del año completo.
	 * @param week Número de la semana, un valor del 1 al 53.
	 * @return Date Una fecha con el primer día de la semana correspondiente a los datos facilitados.
	 */
	public static function weekNumberToDate(year :int, week :int) :Date
	{
		var date :Date = new Date(year, 0, 1); // 1 de enero del año especificado
		var i :int = 1;
		while(i++ <= 53)  //53 semanas puede tener un año (si es bisiesto)
		{
			// Semana tras semana comprueba el número de la misma
			date.date += 7;
			if(weekNumber(date) == week) break;
		}

		date.date -= date.day;  //Pone la fecha al primer día de la semana inglesa (0 = domingo)
		date.date++;  //Corrige la fecha al primer día de la semana europea (1 = lunes)

		return date;
	}

	/**
	 * Devuelve el día del año (de 1 a 366) de la fecha especificada.
	 * @param date Un objeto Date con una fecha válida.
	 * @return int Un valor númerico del día del año (1 - 366).
	 * @source Basado en la función calculateISO8601WeekNumber [http://board.flashkit.com/board/showthread.php?threadid=755170]
	 * @author Rick McCarty, 1999
	 * @author R.Bozzolo, 2006
	 * @author A.Colonna, 2008
	 */
	public static function dayOfYearNumber(date :Date) :int
	{
		// 1) Convert date to Y M D
		var Y :Number = date.getFullYear();
		var M :Number = date.getMonth();
		var D :Number = date.getDate();

		// 2) Find out if Y is a leap year
		var isLeapYear :Boolean = (Y % 4 == 0  &&  Y % 100 != 0) || Y % 400 == 0;

		// 4) Find the Day of Year Number for Y M D
		var month :Array = [0,31,59,90,120,151,181,212,243,273,304,334];
		var DayOfYearNumber :int = D + month[M];
		if (isLeapYear && M > 1)
			DayOfYearNumber++;

		return DayOfYearNumber;
	}
}
}