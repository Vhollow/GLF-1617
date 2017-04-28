%{

int	nflo ;	/* Numero de ficheros en línea de órdenes */
int	nfa ;	/* Número de fichero actualmente en uso */
char	**avg;	/* av[1..na]	*/


int	nrow = 0;
int	ncol = 0;	/* Número de columna (carácter dentro de línea) */
int fila = 0;
int columna = 0;

%}

%S	CMN
%S 	NCLASE
%S 	CLASE
%S 	METATR
%S  METODO
%S  COM
%S  COM_CLAS
%S  COM_MET

llaveApertura "{"
llaveCierre "}"
nombre	($|_|[A-Za-z])($|_|[A-Za-z]|[0-9])*
class	((public|private)[ |\t]+)?(abstract[ |\t]+)?(class)[ |\t]+
nombreClase	{nombre}[ |\t|\n]*{llaveApertura}
metAtr [ |\t]*((public|protected|private)[ |\t]+)?{nombre}[ |\t]+
nombreMetodo	{nombre}[ |\t|\n]*
listaArgumentos "("(({argumento},)*{argumento})?")"("{")[ |\t]*
argumento nombre[ |\t]+nombre
nombreAtributo	[A-Za-z]+[ |\t]*;
comenLinea "//".*\n
comenMulti "/*"
comenMultiFin "*/"

%%



<NCLASE>{

	{nombreClase}	{
		ncol += strlen(yytext);
		yytext[strlen(yytext)-1]='\0';
		printf("-Class: %s row: %d column: %d\n",yytext,fila,columna);
		BEGIN CLASE;
	}
}
<CLASE>{
	{comenMulti} {
		BEGIN COM_CLAS;
	}
	{metAtr} {
		fila = nrow;
		columna = ncol;
		ncol += strlen(yytext);
		BEGIN METATR;
	}
	{llaveCierre} {
		ncol += strlen(yytext);
		BEGIN 0;
	}
}
<METATR>{
	{nombreAtributo} {
		ncol += strlen(yytext);
		yytext[strlen(yytext)-1]='\0';
		printf("Atributo: %s row: %d column: %d \n",yytext,fila,columna);
		BEGIN CLASE;
	}
	{nombreMetodo} {
		ncol += strlen(yytext);
		printf("Metodo: %s row: %d column: %d \n",yytext,fila,columna);
		BEGIN METODO;
	}
}
<METODO>{
	{comenMulti} {
		BEGIN COM_MET;
	}
	{llaveCierre} { BEGIN CLASE; }
}
<COM>{
	{class} {
		;
	}
	{comenMultiFin} {
		BEGIN 0;
	}
}
<COM_CLAS>{
	{metAtr} {
		;
	}
	{llaveCierre} {
		;
	}
	{comenMultiFin} {
		BEGIN CLASE;
	}
}
<COM_MET>{
	{llaveCierre} {
		;
	}
	{comenMultiFin} {
		BEGIN METODO;
	}
}
{class} {
	fila = nrow;
	columna = ncol;
	ncol += strlen(yytext);
	BEGIN NCLASE;
}
{comenLinea} {
	nrow ++;
	ncol = 0;
}
{comenMulti} {
	BEGIN COM;
}

[^ \t\n]+	{ncol += strlen(yytext);}
. {
	ncol += strlen(yytext);
}
\n {
  nrow++;
	ncol = 0;
}
%%


int main(int na, char *av[]) {

	int	i;

	ncol = nrow = 0 ;

	nflo = na - 1 ;
	avg = (char **) malloc(nflo * sizeof(char *)) ;
 	for (i=1 ; i<na ; i++) { avg[i-1] = strdup(av[i]) ; }

	nfa = 0 ;
	yyin = fopen(avg[nfa++], "r");

	yylex();

}

int yywrap(void) {


    fclose(yyin) ;

    ncol = nrow = 0 ;

    if (nfa >= nflo) return 1;
    yyin=fopen(avg[nfa++], "r") ;
    return 0;
}
