#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(-utf8);
use DBI;

my $q = CGI->new;
print $q->header("text/html; charset=utf-8");
my $titulo = $q->param('titulo');
my $markdown = $q->param('markdown');
#Segundo
my $title = $q->param('title');
my $markdown2 = $q->param('markdown2');

my $user = 'alumno';
my $password = 'pweb1';
my $dsn = "DBI:MariaDB:database=pweb1;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

if((defined($titulo) and defined($markdown)) or (!defined($title) and !defined($markdown2))){
my $sth = $dbh->prepare("INSERT INTO Fakewiki(Title, Text) VALUES (?,?)");
$sth->execute($titulo, $markdown);

print <<BLOCK;
<!DOCTYPE html>
<html>
  <head>
  <title>Pagina wiki</title>
  </head>
    <body>
    <h1>$titulo</h1>
    <br>
    <h3>$markdown</h3>
    <hr>
    <h2>Página grabada
    <a href="list.pl"> Lista de páginas</a>
    </h2>
    </body>
</html>
BLOCK
}
elsif((!defined($titulo) and !defined($markdown)) or (defined($title) and defined($markdown2))){
my $sth = $dbh->prepare("UPDATE Fakewiki SET Text=? WHERE Title=?");
$sth->execute($markdown2, $title);
print <<BLOCK;
<!DOCTYPE html>
<html>
  <head>
  <title>Pagina wiki</title>
  </head>
    <body>
    <h1>$title</h1>
    <br>
    <h3>$markdown2</h3>
    <hr>
    <h2>Página grabada
    <a href="list.pl"> Lista de páginas</a>
    </h2>
    </body>
</html>
BLOCK
}
