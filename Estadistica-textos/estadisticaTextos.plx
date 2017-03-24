#!/usr/bin/perl -w

#
#	Práctica de estadística de textos basada en el conteo de palabras.
#	Debe de contarse cuantas veces aparece cada palabra en el texto (se considera palabra toda secencia de caracteres españoles)
#	Los resultados deben imprimirse en pantalla ordenados por el número de apariciones
#	El formato será: numero de apariciones(con 10 posiciones) + tabulador + palabra
#
#	Valorable la cuenta de caracteres con una sola lectura de la entrada
#
#	Referencia ordenación por valores : https://perlmaven.com/how-to-sort-a-hash-in-perl
#




my %words;	# hash para guardar la cuenta de las palabras
my %letters;	# hash para guardar la cuenta de las letras

#
# Rutina main del programa. Se encarga primero de lllamar a una rutina que abre el fichero y luego a la rutina que cuenta las palabras
# La he realizado más que nada por organizar el código como en los programas habituales
#
sub main{

	my $text = getText();

	countWords($text);
}

#
# Rutina encargada de contar palabras y mostrar el resultado por pantalla
#
sub countWords(){
	my ($text) = @_;
	
	# Divido el texto por todos aquellos caracteres que no se correspondan con los del español
	foreach my $word (split /[^a-zA-ZñÑáéíóúÁÉÍÓÚ]+/,$text){
		$word=lc($word);	#Paso la palabra a minúsculas para que no las vea como distintas
		$words{$word}++;	#Sumo a la cuenta de la palabra en el hashmap
		
		# Extraigo los caracteres de la palabra
		foreach my $letter(split//,$word){
			$letters{$letter}++;	# Sumo a la cuenta de los caracteres
		}
	}
	
	print "Caracteres:\n";
	# Imprimimos el resultado de los caracteres
	foreach my $letter(sort { $letters{$a} <=> $letters{$b} or $a cmp $b } keys %letters){
                $numerosRestantes ="0"x(10 - length($letters{$letter}));    # Añado tantos ceros como flten hasta que el número llegue a 10 posiciones
		print"$numerosRestantes$letters{$letter}\t$letter\n";
	}
	
	print "Palabras:\n";
	# Imprimo el resultado en el formato pedido
	foreach my $word (sort { $words{$a} <=> $words{$b} or $a cmp $b } keys %words){	# Organizamos lo datos por su valor
		$numerosRestantes ="0"x(10 - length($words{$word}));	# Añado tantos ceros como flten hasta que el número llegue a 10 posiciones
		print "$numerosRestantes$words{$word}\t$word\n";
	}
}

#
# Rutina que se encarga de leer el fichero de texto y devolver el contenido
#
sub getText{
	if ($#ARGV+1 == 1){	#Comprobamos que nos han pasado argumentos
		my $fileName = $ARGV[0];	#Tomamos el primer argumento como la dirección del fichero

		open(my $file, "<", $fileName)
			or die "--ERROR-- Imposible abrir [$fileName]: $!";	# Abrimos el fichero
		
		# Guardamos el contenido en una variable
		while (<$file>) {
			$text .= $_;
		}

		close($file);	# Cerramos el fichero

		return $text;	# Devolvemos el texto resultante
	}
}

main();
