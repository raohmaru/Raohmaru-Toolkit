/*
Disclaimer for Robert Penner's Easing Equations license:

TERMS OF USE - EASING EQUATIONS

Open source under the BSD License.

Copyright � 2001 Robert Penner
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package jp.raohmaru.toolkit.motion.easing 
{
/**
 * Ecuaciones de movimiento de Robert Penner utilizadas por la clase Paprika.
 */
public class Elastic 
{
	private static const _2PI :Number = Math.PI * 2;

	public static function easeIn(t :Number, b :Number, c :Number, d :Number, a :Number = 0, p :Number = 0) :Number 
	{
		var s :Number;
		if (t == 0) return b;  
		if ((t /= d) == 1) return b + c;  
		if (!p) p = d * .3;
		if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) 
		{ 
			a = c; 
			s = p / 4; 
		}
			else s = p / _2PI * Math.asin(c / a);
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * _2PI / p)) + b;
	}

	public static function easeOut(t :Number, b :Number, c :Number, d :Number, a :Number = 0, p :Number = 0) :Number 
	{
		var s :Number;
		if (t == 0) return b;  
		if ((t /= d) == 1) return b + c;  
		if (!p) p = d * .3;
		if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) 
		{ 
			a = c; 
			s = p / 4; 
		}
			else s = p / _2PI * Math.asin(c / a);
		return (a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * _2PI / p) + c + b);
	}

	public static function easeInOut(t :Number, b :Number, c :Number, d :Number, a :Number = 0, p :Number = 0) :Number 
	{
		var s :Number;
		if (t == 0) return b;  
		if ((t /= d * 0.5) == 2) return b + c;  
		if (!p) p = d * (.3 * 1.5);
		if (!a || (c > 0 && a < c) || (c < 0 && a < -c)) 
		{ 
			a = c; 
			s = p / 4; 
		}
			else s = p / _2PI * Math.asin(c / a);
		if (t < 1) return -.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * _2PI / p)) + b;
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * _2PI / p) * .5 + c + b;
	}
}
}