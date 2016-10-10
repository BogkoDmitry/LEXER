%{
#pragma GCC diagnostic ignored "-Wformat"
int quant = 0, kol = 1;
%}

%%


[0-9]+										{ printf("%s(%s,%d,%d,%d) ", "NUM", yytext, kol, quant, quant + yyleng - 1); quant += yyleng;}
			
"skip"|"write"|"read"|"if"|"then"|"else"|"do"|"while"		{ printf("%s(%s,%d,%d,%d) ", "KW", yytext, kol, quant, quant + yyleng - 1); quant += yyleng;}
		
:=											{ printf("%s(%d,%d,%d) ", "Assign", kol, quant, quant + yyleng - 1); quant += yyleng;}	
		
[A-Za-z_][A-Za-z0-9_]* 						{ printf("%s(%s,%d,%d,%d) ", "VAR", yytext, kol, quant, quant + yyleng - 1); quant += yyleng;}	
		
(\+)|(\-)|(\*)|(\/)|(\%)					{ printf("%s(%s,%d,%d,%d) ", "OP_ARIFMET", yytext, kol, quant, quant + yyleng - 1); quant += yyleng;}

(==)|(!=)|(>)|(>=)|(<)|(<=)|(&&)|(\|\|)		{ printf("%s(%s,%d,%d,%d) ", "OP_BOOL", yytext, kol, quant, quant + yyleng - 1); quant += yyleng;}	

\(									{ printf("%s(%d,%d,%d) ", "OPEN", kol, quant, quant + yyleng - 1); quant += yyleng;}	
		
\)									{ printf("%s(%d,%d,%d) ", "CLOSE", kol, quant, quant + yyleng - 1); quant += yyleng;}

\;									{ printf("%s(%d,%d,%d) ", "COLON", kol, quant, quant + yyleng - 1); quant += yyleng;}
		
\n 									{ kol++; quant = 0;}
				
[ |\f|\n|\r|\t|\v]					{};

.									{ printf("%s(%s,%d,%d,%d) ", "UNDEF", yytext, kol, quant, quant + yyleng - 1); quant += yyleng;}

"**"								{ printf("%s(%d,%d,%d)\n", "POW", kol, quant, quant + yyleng - 1); quant += yyleng;}
"//".*\n							{printf("COMMENT(%d, %d, %d)\n" , kol, quant, quant + yyleng - 1); kol++; quant = 0;}

%%

int main(int argc, char** argv)
{
	if (argc > 1)
	{
		if (!(yyin = fopen(argv[1], "r"))) 
		{
			printf("File not open: %s\n", argv[1] );
			yyterminate();
		}
	}
	else
	{
		printf("Missing file name\n");
		yyterminate();
	}
        yylex(); 
}
