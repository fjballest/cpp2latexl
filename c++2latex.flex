/*                   -*- C++ -*-
 C++2LaTeX-l: Produce prettyprinted LaTeX files from  C++ or C sources
              for use in literate programs formatted with noweb

 Copyright (C) 1996 Francisco J. Ballesteros <nemo@nautilus> for the
                    literate (-l) version

 NOTE: The literate version does not include code from the plain c++2latex
 distribution but I still consider this program a derivative from the
 original one, at least in spirit ;-) -- nemo@nautilus
 The original c++2latex was copyright (C) 1990 Norbert Kiesel


 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 1, or (at your option)
 any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 Francisco J. Ballesteros 
 GSyC group, Computer Science
 Carlos III University of Madrid 
 C/ Butarque 15, E-28911 Leganes (Madrid)
 Spain
 nemo@gsyc.inf.uc3m.es or http://www.gsyc.inf.uc3m.es/~nemo

 Please contact me for comments, bugs or suggestions about this code.
*/

/* excluding the returns */
SPACE_AND_FORMAT_EFFECTORS 	([ \t\f\013])
RETURN_FORMAT_EFFECTORS 	([\n\r])
WHITESPACE 			({SPACE_AND_FORMAT_EFFECTORS})
WHITESPACE_RETURNS 		({RETURN_FORMAT_EFFECTORS})
DIGIT 	 			([0-9])
LETTER 	 			([a-zA-Z_])


LETTER_OR_DIGIT 	 	({LETTER}|{DIGIT})
IDENTIFIER 	 		({LETTER}(_?{LETTER_OR_DIGIT})*)


EXTENDED_DIGIT 	 		([0-9a-fA-F])
INTEGER  		(({DIGIT}({DIGIT})*)|(0[xX]({EXTENDED_DIGIT})*))
EXPONENT 	 		(e[-+]?{INTEGER})
DECIMAL_LITERAL 	 	({INTEGER}([.]{INTEGER})?({EXPONENT})?)


NUMERIC_LITERAL 	 	{DECIMAL_LITERAL}



CHARACTER_LITERAL 	 	(\'.\')


NO_QUOTE 	 		([^"\n])
NO_QUOTE_OR_PERCENT 	 	([^"%\n])
DOUBLE_PERCENT 	 		([%][%])
QUOTED_QUOTE 	 		(\\\")
STRING_LITERAL                (\"({NO_QUOTE}*({QUOTED_QUOTE})*)*\")



COMMENT 	 		("//".*)


%{
void fix( void)
{
  int i = 0;
  int leng = strlen(yytext);
  while (i != leng) {
     if (yytext[i] == '#')
        printf("\\#");
     else if (yytext[i] == '%')
        printf("\\%%");
     else if (yytext[i] == '_')
        printf("\\_");
     else if (yytext[i] == '&')
        printf("\\&");
     else if (yytext[i] == '{')
        printf("\\{");
     else if (yytext[i] == '}')
        printf("\\}");
     else if (yytext[i] == '$')
        printf("\\$");
     else if (yytext[i] == '^')
        printf("\\^");
     else if (yytext[i] == '\\')
        printf("\\begin{math}\\backslash\\end{math}");
     else
        printf("%c", yytext[i]);
     i++;
  };

}
%}

%START WEBDOC  BCOMMENT C  

/* 2.9 and 2.2 */

%%
"@file"		    	{BEGIN(WEBDOC); ECHO;}
"@begin code".*		{BEGIN(C); ECHO;}
"@end code".*		{BEGIN(WEBDOC); ECHO;}
"@begin docs".*		{BEGIN(WEBDOC); ECHO;}
"@use".*			{ECHO;}
<WEBDOC>"@text".*       {BEGIN(WEBDOC); ECHO;}
<WEBDOC>"@nl".*		{BEGIN(WEBDOC); ECHO;}
<WEBDOC>"@begin".*	{BEGIN(WEBDOC); ECHO;}
<WEBDOC>"@end".*	{BEGIN(WEBDOC); ECHO;}
<WEBDOC>"@quote".*	{BEGIN(C); ECHO;}
"@endquote".*		{BEGIN(WEBDOC);  ECHO;}

"/*"			{BEGIN(BCOMMENT); ECHO; printf("\\CComment{");}
<BCOMMENT>"*/"          { printf("}"); ECHO; BEGIN(C); }
<BCOMMENT>[^*]*         {BEGIN(BCOMMENT); fix();}
<BCOMMENT>.		{BEGIN(BCOMMENT); fix();}
"//".*"\n"		{printf("\\CCComment{"); fix(); printf("}\n");}



"#"[ \t]*"include"	{BEGIN(C); printf("\\CPPinclude ");}
"#"[ \t]*"define"	{BEGIN(C); printf("\\CPPdefine ");}
"#"[ \t]*"undef"	{BEGIN(C); printf("\\CPPundef ");}
"#"[ \t]*"pragma"	{BEGIN(C); printf("\\CPPpragma ");}
"#"[ \t]*"if"		{BEGIN(C); printf("\\CPPif ");}
"#"[ \t]*"ifdef"	{BEGIN(C); printf("\\CPPifdef ");}
"#"[ \t]*"ifndef"       {BEGIN(C); printf("\\CPPifndef ");}
"#"[ \t]*"elif"		{BEGIN(C); printf("\\CPPelif ");}
"#"[ \t]*"else"		{BEGIN(C); printf("\\CPPelse ");}
"#"[ \t]*"error"	{BEGIN(C); printf("\\CPPerror ");}
"#"[ \t]*"line"         {BEGIN(C); printf("\\CPPline ");}
"#"[ \t]*"ex"           {BEGIN(C); printf("\\CPPex ");}
"#"[ \t]*"endif"	{BEGIN(C); printf("\\CPPendif ");}


"auto"			{BEGIN(C); printf("\\Cauto ");}
"double"		{BEGIN(C); printf("\\Cdouble ");}
"int"			{BEGIN(C); printf("\\Cint ");}
"struct"		{BEGIN(C); printf("\\Cstruct ");}
"break"			{BEGIN(C); printf("\\Cbreak ");}
"else"			{BEGIN(C); printf("\\Celse ");}
"long"			{BEGIN(C); printf("\\Clong ");}
"switch"		{BEGIN(C); printf("\\Cswitch ");}
"case"			{BEGIN(C); printf("\\Ccase ");}
"enum"			{BEGIN(C); printf("\\Cenum ");}
"register"		{BEGIN(C); printf("\\Cregister ");}
"typedef"		{BEGIN(C); printf("\\Ctypedef ");}
"char"			{BEGIN(C); printf("\\Cchar ");}
"extern"		{BEGIN(C); printf("\\Cextern ");}
"return"		{BEGIN(C); printf("\\Creturn ");}
"union"			{BEGIN(C); printf("\\Cunion ");}
"const"			{BEGIN(C); printf("\\Cconst ");}
"float"			{BEGIN(C); printf("\\Cfloat ");}
"short"			{BEGIN(C); printf("\\Cshort ");}
"unsigned"		{BEGIN(C); printf("\\Cunsigned ");}
"continue"		{BEGIN(C); printf("\\Ccontinue ");}
"for"			{BEGIN(C); printf("\\Cfor ");}
"signed"		{BEGIN(C); printf("\\Csigned ");}
"void"			{BEGIN(C); printf("\\Cvoid ");}
"default"		{BEGIN(C); printf("\\Cdefault ");}
"goto"			{BEGIN(C); printf("\\Cgoto ");}
"sizeof"		{BEGIN(C); printf("\\Csizeof ");}
"volatile"		{BEGIN(C); printf("\\Cvolatile ");}
"do"			{BEGIN(C); printf("\\Cdo ");}
"if"			{BEGIN(C); printf("\\Cif ");}
"static"		{BEGIN(C); printf("\\Cstatic ");}
"while"			{BEGIN(C); printf("\\Cwhile ");}
"new"			{BEGIN(C); printf("\\Cnew ");}
"delete"		{BEGIN(C); printf("\\Cdelete ");}
"this"			{BEGIN(C); printf("\\Cthis ");}
"operator"		{BEGIN(C); printf("\\Coperator ");}
"class"			{BEGIN(C); printf("\\Cclass ");}
"public"		{BEGIN(C); printf("\\Cpublic ");}
"protected"		{BEGIN(C); printf("\\Cprotected ");}
"private"		{BEGIN(C); printf("\\Cprivate ");}
"virtual"		{BEGIN(C); printf("\\Cvirtual ");}
"friend"		{BEGIN(C); printf("\\Cfriend ");}
"inline"		{BEGIN(C); printf("\\Cinline ");}
"dynamic"		{BEGIN(C); printf("\\Cdynamic ");}
"typeof"		{BEGIN(C); printf("\\Ctypeof ");}
"all"			{BEGIN(C); printf("\\Call ");}
"except"		{BEGIN(C); printf("\\Cexcept ");}
"exception"		{BEGIN(C); printf("\\Cexception ");}
"raise"			{BEGIN(C); printf("\\Craise ");}
"raises"		{BEGIN(C); printf("\\Craises ");}
"reraise"		{BEGIN(C); printf("\\Creraise ");}
"try"			{BEGIN(C); printf("\\Ctry ");}
"asm"			{BEGIN(C); printf("\\Casm ");}
"catch"			{BEGIN(C); printf("\\Ccatch ");}
"overload"		{BEGIN(C); printf("\\Coverload ");}

"->"			{BEGIN(C); ECHO;}
"<<"			{BEGIN(C); ECHO;}
">>"			{BEGIN(C); ECHO;}
"<="			{BEGIN(C); ECHO;}
">="			{BEGIN(C); ECHO;}
"!="			{BEGIN(C); ECHO;}
"||"			{BEGIN(C); ECHO;}
"..."			{BEGIN(C); printf("\\ldots ");}
"*="			{BEGIN(C); ECHO;}
"<<="			{BEGIN(C); ECHO;}
">>="			{BEGIN(C); ECHO;}
"^="			{BEGIN(C); ECHO;}
"|="			{BEGIN(C); ECHO;}
"~"			{BEGIN(C); ECHO;}
"*"			{BEGIN(C); ECHO;}
"^"			{BEGIN(C); ECHO;}
"|"			{BEGIN(C); ECHO;}
"->*"			{BEGIN(C); ECHO;}
"/"			{BEGIN(C); ECHO;}
"<"			{BEGIN(C); ECHO;}
">"			{BEGIN(C); ECHO;}
"&&"			{BEGIN(C); ECHO;}
"%="			{BEGIN(C); ECHO;}
"&="			{BEGIN(C); ECHO;}
"{"			{BEGIN(C); printf("\\{");}
"}"			{BEGIN(C); printf("\\}");}
"\\"                    {BEGIN(C); 
                          printf("\\begin{math}\\backslash\\end{math}");}
"&"			{BEGIN(C); ECHO;}
"%"			{BEGIN(C); ECHO;}
"--"			{BEGIN(C); ECHO;}
".*"			{BEGIN(C); ECHO;}
"?"			{BEGIN(C); ECHO;}
":"			{BEGIN(C); ECHO;}
"="			{BEGIN(C); ECHO;}
","			{BEGIN(C); ECHO;}
"."			{BEGIN(C); ECHO;}
";"			{BEGIN(C); ECHO;}
"!"			{BEGIN(C); ECHO;}
"-"			{BEGIN(C); ECHO;}
"+"			{BEGIN(C); ECHO;}
"/="			{BEGIN(C); ECHO;}
"=="			{BEGIN(C); ECHO;}
"++"			{BEGIN(C); ECHO;}
"+="			{BEGIN(C); ECHO;}
"-="			{BEGIN(C); ECHO;}
"("			{BEGIN(C); ECHO;}
")"			{BEGIN(C); ECHO;}
"["			{BEGIN(C); ECHO;}
"]"			{BEGIN(C); ECHO;}
"::"			{BEGIN(C); ECHO;}

{IDENTIFIER}            {BEGIN(C); fix();}

([0-9]*\.[0-9]+[fFlL]?)		 {ECHO;}
([0-9]+\.[0-9]*[fFlL]?)		 {ECHO;}
([0-9]*\.?[0-9]+[eE][+-]?[0-9]+) {ECHO;}
([0-9]+\.?[0-9]*[eE][+-]?[0-9]+) {ECHO;}
[0-9]+[uUlL]?			 {ECHO;}
L?'[ -~]'			 {ECHO;}
L?'\\[ntvbrfa\\?'"]'		 {ECHO;}
L?'\\[0-7]{1,3}'		 {ECHO;}
L?'\\x[0-9a-fA-F]{1,2}'		 {ECHO;}
0x[0-9a-fA-F]+[uUlL]?		 {ECHO;}
.				 {ECHO;}


%%


main()
{
  yylex();
  exit(0);
}





